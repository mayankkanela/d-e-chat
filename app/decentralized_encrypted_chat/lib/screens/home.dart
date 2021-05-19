import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
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

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final dh = ScreenConfig.blockSizeVertical;
    final dw = ScreenConfig.blockSizeHorizontal;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // todo: add new user to chat with
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
    return Center(
      child: Text('Home'),
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
}
