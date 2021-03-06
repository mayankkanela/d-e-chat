import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as util;
import 'package:decentralized_encrypted_chat/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//todo: show loading indicator on the signIn button after signIn.
class SignIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final dh = ScreenConfig.blockSizeVertical;
    final dw = ScreenConfig.blockSizeHorizontal;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome",
            style: TextStyle(
                color: Colors.black,
                fontSize: dh * 8,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: dw * 5),
            padding: EdgeInsets.symmetric(horizontal: dw * 2, vertical: dh * 3),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(dh * 1)),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  InputField(
                    validator: (string) =>
                        util.emptyOrNullStringValidator(string),
                    hintText: "Enter your email",
                    label: "Email",
                    icon: Icons.email,
                    textInputType: TextInputType.text,
                    textEditingController: _emailController,
                  ),
                  SizedBox(
                    height: dh * 1,
                  ),
                  InputField(
                      validator: (string) =>
                          util.passwordLengthValidator(string),
                      hintText: "Enter your password",
                      textEditingController: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                      textInputType: TextInputType.text)
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _signIn(context),
            icon: Icon(Icons.arrow_forward_ios_rounded),
            label: Text(
              'LogIn',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: dh * 2.4),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
          Column(
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: dh * 3),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(Constants.ROUTE_SIGN_UP);
                  },
                  child: Text(
                    'Sign Up!',
                    style: TextStyle(fontSize: dh * 2.5, color: Colors.blue),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  _signIn(BuildContext context) async {
    bool val = _formKey.currentState!.validate();
    if (val) {
      final signedIn = await Provider.of<UserProvider>(context, listen: false)
          .signInWithEmailPassword(
              _emailController.text, _passwordController.text);
      if (signedIn)
        util.pushNamed(context: context, path: Constants.ROUTE_HOME);
    } else {
      // todo: show some message regarding failure to signIn.
    }
  }
}
