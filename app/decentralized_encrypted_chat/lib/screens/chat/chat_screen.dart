import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/models/message.dart';
import 'package:decentralized_encrypted_chat/provider/message_provider.dart';
import 'package:decentralized_encrypted_chat/screens/chat/message_item.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final CurrentUser currentUser;
  final Chat chat;
  final String? chatKey;

  const ChatScreen(
      {Key? key,
      required this.currentUser,
      required this.chat,
      required this.chatKey})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _msgTEC;
  late final String? _chatKey;

  @override
  void initState() {
    super.initState();
    _msgTEC = TextEditingController();
    _chatKey = widget.chatKey;
  }

  @override
  void dispose() {
    _msgTEC.dispose();
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
                                    return MessageItem(
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
      title: Text(
        widget.chat.getReceiverId(widget.currentUser.email),
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
}
