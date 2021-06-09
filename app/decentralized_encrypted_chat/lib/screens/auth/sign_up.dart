import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as util;
import 'package:decentralized_encrypted_chat/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//todo: show loading indicator on the signIn button after signUp.
class SignUp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _pvtKeyController = TextEditingController();

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
                      hintText: "Ex: abc@gmail.com",
                      label: "Type your email",
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      icon: Icons.email),
                  SizedBox(
                    height: dh * 1,
                  ),
                  InputField(
                    validator: (string) => util.passwordLengthValidator(string),
                    hintText: "********",
                    textEditingController: _passwordController,
                    label: "Type your password",
                    textInputType: TextInputType.text,
                    obscureText: true,
                    icon: Icons.lock,
                  ),
                  SizedBox(
                    height: dh * 1,
                  ),
                  InputField(
                      validator: (string) => util.confirmPasswordValidator(
                          string, _passwordController.text),
                      hintText: "********",
                      textEditingController: _confirmController,
                      label: "Re-type your password",
                      obscureText: true,
                      textInputType: TextInputType.text,
                      icon: Icons.lock),
                  SizedBox(
                    height: dh * 1,
                  ),
                  InputField(
                      validator: (string) =>
                          util.emptyOrNullStringValidator(string),
                      hintText: "********",
                      textEditingController: _pvtKeyController,
                      label: "Enter a secret encryption key",
                      obscureText: true,
                      textInputType: TextInputType.text,
                      icon: Icons.vpn_key),
                  SizedBox(
                    height: dh * 2,
                  ),
                  GestureDetector(
                    onTap: () => _showDialog(context, dh),
                    child: Text(
                      "What is secret encryption key?",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _signUp(context),
            icon: Icon(Icons.arrow_forward_ios_rounded),
            label: Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: dh * 2.4),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
          Column(
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(fontSize: dh * 3),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(Constants.ROUTE_SIGN_IN);
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: dh * 2.5, color: Colors.blue),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context, double dh) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(dh * 2))),
            actionsPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            title: Text(
              "Secret Encryption Key",
              style: TextStyle(color: Colors.black, fontSize: dh * 3),
            ),
            content: Text(
              "This is a user set key which is used for encryption of messages is this application" +
                  ", this key is not stored anywhere and the user should remember and keep the key safe.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  _signUp(BuildContext context) async {
    final bool val = _formKey.currentState!.validate();
    if (val) {
      final bool signedUp =
          await Provider.of<UserProvider>(context, listen: false)
              .signUpWithEmailPassword(_emailController.text,
                  _passwordController.text, _pvtKeyController.text);
      if (signedUp) {
        util.pushNamedReplacement(context: context, path: Constants.ROUTE_HOME);
      } else {
        // todo: show some message regarding failing to signup
      }
    }
  }
}
