import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:flutter/material.dart';

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

  void _getUser() {}
}
