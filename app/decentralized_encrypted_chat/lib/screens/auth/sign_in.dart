import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final dh = ScreenConfig.blockSizeVertical;
    final dw = ScreenConfig.blockSizeHorizontal;
    return Scaffold(
      body: Center(
        child: Card(
          color: Colors.black,
          child: Column(
            children: [
              Text(
                "WELCOME",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: dh * 10,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
