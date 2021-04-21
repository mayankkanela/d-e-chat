import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final dh = ScreenConfig.blockSizeVertical;
    final dw = ScreenConfig.blockSizeHorizontal;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "D-E-CHAT",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: dh * 10),
        ),
      ),
    );
  }

  void _getUser() async {
    final isUserExist = await Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser();
    if (!isUserExist)
      await Navigator.of(context).pushReplacementNamed(Constants.ROUTE_SIGN_IN);
    else {}
    //todo: Home
  }
}
