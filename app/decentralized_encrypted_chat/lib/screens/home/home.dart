import 'dart:developer';

import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/provider/chat_provider.dart';
import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
import 'package:decentralized_encrypted_chat/screens/home/chat_item.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as utils;
import 'package:decentralized_encrypted_chat/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum CreateChannel { single, group }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _appKeyTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _groupNameTEC = TextEditingController();
  CreateChannel _createChannel = CreateChannel.single;
  late bool _loadData;

  @override
  void initState() {
    super.initState();
    _loadData = false;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    WidgetsFlutterBinding.ensureInitialized();
    Future.delayed(Duration.zero, () {
      _checkAppKey();
    });
  }

  @override
  void dispose() {
    _appKeyTEC.dispose();
    _emailTEC.dispose();
    context.watch<UserProvider>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final dh = ScreenConfig.blockSizeVertical;
    final dw = ScreenConfig.blockSizeHorizontal;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _loadData == true ? _buildBody(dh, dw) : Text("Key Missing"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addUser(dw, dh);
        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody(double dh, double dw) {
    return Provider<ChatProvider>(
      create: (_) => ChatProvider(
          email: Provider.of<UserProvider>(context, listen: false)
              .currentUser
              .email),
      child: Builder(
        builder: (ctx) {
          return StreamProvider<List<Chat>?>(
            create: (_) => ctx.watch<ChatProvider>().stream,
            initialData: null,
            child: Builder(
              builder: (context) {
                final data = context.watch<List<Chat>?>();
                if (data != null && data.length > 0) {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (_, i) => ChatItem(
                          dh: dh,
                          dw: dw,
                          data: data[i],
                          currentUser:
                              Provider.of<UserProvider>(context, listen: false)
                                  .currentUser));
                } else
                  return Center(child: Text("No Chats"));
              },
            ),
            catchError: (e, fun) {
              log("${e.toString()}");
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      brightness: Brightness.dark,
      title: Text(
        "D-E CHAT",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: kToolbarHeight / 2.5),
      ),
    );
  }

  _checkAppKey() async {
    if (Provider.of<UserProvider>(context, listen: false).appKey == null) {
      _getAppKey();
    } else {
      _getData();
    }
  }

  _getAppKey() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            title: Text(
              "Enter your secret key",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your secret key used to encrypt and decrypt messages",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.justify,
                ),
                InputField(
                    hintText: "********",
                    validator: (value) =>
                        utils.emptyOrNullStringValidator(value),
                    textEditingController: _appKeyTEC,
                    label: "Secret Key",
                    textInputType: TextInputType.text,
                    obscureText: true,
                    icon: Icons.vpn_key),
              ],
            ),
            actions: [
              TextButton(onPressed: () => _getKey(), child: Text("GET"))
            ],
            actionsPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
          );
        });
  }

  _getData() async {
    setState(() {
      _loadData = true;
    });
  }

  void _getKey() {
    if (_appKeyTEC.text.isNotEmpty) {
      final val = Provider.of<UserProvider>(context, listen: false)
          .decryptAppKey(key: _appKeyTEC.text);
      if (val) {
        _getData();
        utils.pop(context: context);
      }
    }
  }

  void _addUser(double dw, double dh) async {
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
                _createChannel == CreateChannel.single
                    ? "Enter email to add a contact."
                    : "Enter name of the group",
                style: TextStyle(color: Colors.black, fontSize: dh * 3),
              ),
              content: InputField(
                  validator: (string) =>
                      utils.emptyOrNullStringValidator(string),
                  hintText: _createChannel == CreateChannel.single
                      ? "Ex: abc@gmail.com"
                      : "Ex: flutter ",
                  label: _createChannel == CreateChannel.single
                      ? "Type email here"
                      : "Group name here",
                  textEditingController: _createChannel == CreateChannel.single
                      ? _emailTEC
                      : _groupNameTEC,
                  textInputType: TextInputType.emailAddress,
                  icon: _createChannel == CreateChannel.single
                      ? Icons.email
                      : Icons.group),
              actions: [
                TextButton(
                    onPressed: () {
                      log(_createChannel.index.toString());
                      if (_createChannel == CreateChannel.single) {
                        setState(() {
                          _createChannel = CreateChannel.group;
                        });
                      } else {
                        setState(() {
                          _createChannel = CreateChannel.single;
                        });
                      }
                    },
                    child: Text(_createChannel == CreateChannel.single
                        ? "NEW GROUP"
                        : "ADD A CONTACT")),
                TextButton(
                    onPressed: () =>  _handleCreateChannel(),
                    child: Text('DONE'))
              ],
            ),
          );
        }).then((value) => _resetCreateChannel());
  }

  void _handleCreateChannel() async {
    try {
      switch (_createChannel) {
        case CreateChannel.single:
         await ChatProvider.addNewContact(
                  currentUser: Provider.of<UserProvider>(context, listen: false)
                      .currentUser,
                  contactEmail: _emailTEC.text,
                  appKey:
                      Provider.of<UserProvider>(context, listen: false).appKey!)
              .then((value) => utils.pop(context: context))
              .then((value) => _emailTEC.clear());
          break;
        case CreateChannel.group:
         await ChatProvider.createGroup(
                  currentUser: Provider.of<UserProvider>(context, listen: false)
                      .currentUser,
                  appKey:
                      Provider.of<UserProvider>(context, listen: false).appKey!,
                  groupName: _groupNameTEC.text)
              .then((value) => utils.pop(context: context))
              .then((value) => _groupNameTEC.clear());
          break;
      }
    } catch (e) {
      log("addnewuser: ${e.toString()}");
    }
  }

  void _resetCreateChannel() {
    _createChannel = CreateChannel.single;
  }
}
