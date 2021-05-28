import 'dart:developer';

import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
import 'package:decentralized_encrypted_chat/screens/home/chat_model.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as utils;
import 'package:decentralized_encrypted_chat/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _appKeyTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();

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
    ChatModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final dh = ScreenConfig.blockSizeVertical;
    final dw = ScreenConfig.blockSizeHorizontal;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _loadData == true ? _buildBody() : Text("Key Missing"),
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

  Widget _buildBody() {
    ChatModel.getAllChats(
        Provider.of<UserProvider>(context, listen: false).currentUser.email);
    return StreamProvider<List<Chat?>?>(
      create: (_) => ChatModel.stream,
      initialData: null,
      child: Builder(
        builder: (context) {
          final data = context.watch<List<Chat?>?>();
          if (data != null && data.length > 0) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) => Text("${data[i]?.members[1]}"));
          } else
            return Text("No Chats");
        },
      ),
      catchError: (e, fun) {
        log("${e.toString()}");
      },
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
    // todo: get chat data
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(dh * 2))),
            actionsPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            title: Text(
              "Enter email to add a contact.",
              style: TextStyle(color: Colors.black, fontSize: dh * 3),
            ),
            content: InputField(
                validator: (string) => utils.emptyOrNullStringValidator(string),
                hintText: "Ex: abc@gmail.com",
                label: "Type your email",
                textEditingController: _emailTEC,
                textInputType: TextInputType.emailAddress,
                icon: Icons.email),
            actions: [
              TextButton(onPressed: () => _addNewUser(), child: Text('DONE'))
            ],
          );
        });
  }

  void _addNewUser() {
    try {
      ChatModel.addNewContact(
              currentUser:
                  Provider.of<UserProvider>(context, listen: false).currentUser,
              contactEmail: _emailTEC.text,
              appKey: Provider.of<UserProvider>(context, listen: false).appKey!)
          .then((value) => utils.pop(context: context));
    } catch (e) {
      log("addnewuser: ${e.toString()}");
    }
  }
}
