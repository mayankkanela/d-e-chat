import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:decentralized_encrypted_chat/utils/screen_config.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as Util;
import 'package:decentralized_encrypted_chat/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _confirmController = new TextEditingController();
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
                          Util.emptyOrNullStringValidator(string),
                      hintText: "Ex: abc@gmail.com",
                      label: "Type your email",
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      icon: Icons.email),
                  SizedBox(
                    height: dh * 1,
                  ),
                  InputField(
                    validator: (string) =>
                        Util.emptyOrNullStringValidator(string),
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
                      validator: (string) => Util.confirmPasswordValidator(
                          string, _passwordController.text),
                      hintText: "********",
                      textEditingController: _confirmController,
                      label: "Re-type your password",
                      obscureText: true,
                      textInputType: TextInputType.text,
                      icon: Icons.lock),
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

  _signUp(BuildContext context) {
    bool val = _formKey.currentState!.validate();
    if (val) {
      Provider.of<UserProvider>(context, listen: false).signUpWithEmailPassword(
          _emailController.text, _passwordController.text);
    }
  }
}
