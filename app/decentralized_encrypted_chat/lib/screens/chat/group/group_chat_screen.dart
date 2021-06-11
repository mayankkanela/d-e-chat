import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/models/message.dart';
import 'package:decentralized_encrypted_chat/provider/chat_provider.dart';
import 'package:decentralized_encrypted_chat/provider/message_provider.dart';
import 'package:decentralized_encrypted_chat/screens/chat/group/message_item.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as utils;
import 'package:decentralized_encrypted_chat/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GroupChatScreen extends StatefulWidget {
  final CurrentUser currentUser;
  final Chat chat;
  final String? chatKey;

  const GroupChatScreen(
      {Key? key,
      required this.currentUser,
      required this.chat,
      required this.chatKey})
      : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late final TextEditingController _msgTEC;
  late final String? _chatKey;
  late final TextEditingController _emailTEC;

  @override
  void initState() {
    super.initState();
    _msgTEC = TextEditingController();
    _emailTEC = TextEditingController();
    _chatKey = widget.chatKey;
  }

  @override
  void dispose() {
    _msgTEC.dispose();
    _emailTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final dh = ScreenConfig.blockSizeVertical;
    final dw = ScreenConfig.blockSizeHorizontal;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(dw, dh),
        body: Provider<MessageProvider>(
          create: (ctx) => MessageProvider(),
          child: Builder(
            builder: (ctx) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        context
                            .watch<MessageProvider>()
                            .getAllMessages(widget.chat.docId);
                        return StreamProvider<List<Message>?>(
                          initialData: null,
                          create: (_) =>
                              context.watch<MessageProvider>().messageStream,
                          child: Builder(
                            builder: (context) {
                              final data = context.watch<List<Message>?>();
                              data?.sort((a, b) =>
                                  b.timestamp.millisecondsSinceEpoch.compareTo(
                                      a.timestamp.millisecondsSinceEpoch));
                              if (data != null &&
                                  data.length > 0 &&
                                  _chatKey != null) {
                                final _controller = ScrollController();
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((_) {
                                  if (_controller.hasClients) {
                                    _controller.jumpTo(
                                        _controller.position.maxScrollExtent);
                                  } else {
                                    setState(() => null);
                                  }
                                });

                                return ListView.builder(
                                  controller: _controller,
                                  itemCount: data.length,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (_, i) {
                                    return GroupMessageItem(
                                      chatKey: _chatKey,
                                      message: data[data.length - 1 - i],
                                      dw: dw,
                                      dh: dh,
                                      currentUser: widget.currentUser.email,
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(widget.chatKey == null
                                      ? "UNABLE_TO_DECRYPT_SESSION_KEY_CLEAR_DATA!"
                                      : "No Messages....."),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _msgTEC,
                            maxLines: null,
                            onFieldSubmitted: (msg) => _sendMessage(msg, ctx),
                            decoration: InputDecoration(
                                labelText: "Enter your message here.",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                          ),
                        ),
                      ),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _sendMessage(_msgTEC.text, ctx),
                          icon: Icon(
                            Icons.send_rounded,
                            size: kTextTabBarHeight,
                          ))
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(double dw, double dh) {
    return AppBar(
      backgroundColor: Colors.black,
      brightness: Brightness.dark,
      actions: [
        if (widget.chat.status != Status.unprivileged)
          IconButton(
              onPressed: () => _addMemberDialog(dw, dh), icon: Icon(Icons.add))
      ],
      title: Text(
        widget.chat.groupName ?? "NaN",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _sendMessage(String msg, BuildContext context) async {
    if (!utils.isNullOrEmpty(msg)) {
      final res = await Provider.of<MessageProvider>(context, listen: false)
          .sendMessage(
              plainMessage: msg,
              symKey: _chatKey,
              from: widget.currentUser.email,
              documentId: widget.chat.docId);
      if (res) _msgTEC.clear();
    }
  }

  _addMemberDialog(double dw, double dh) async {
    if (widget.chat.status != Status.unprivileged)
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(dh * 2))),
                actionsPadding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                title: Text(
                  "Enter email to add a member.",
                  style: TextStyle(color: Colors.black, fontSize: dh * 3),
                ),
                content: InputField(
                    validator: (string) =>
                        utils.emptyOrNullStringValidator(string),
                    hintText: "Ex: abc@gmail.com",
                    label: "Type email here",
                    textEditingController: _emailTEC,
                    textInputType: TextInputType.emailAddress,
                    icon: Icons.email),
                actions: [
                  TextButton(onPressed: () => _addMember(), child: Text('DONE'))
                ],
              ),
            );
          });
  }

  Future<void> _addMember() async {
    if (widget.chat.status != Status.unprivileged)
      await ChatProvider.addNewGroupMember(
              chat: widget.chat,
              documentId: widget.chat.docId,
              chatKey: widget.chatKey!,
              contactEmail: _emailTEC.text)
          .then((value) => utils.pop(context: context))
          .then((value) => _emailTEC.clear());
  }
}
