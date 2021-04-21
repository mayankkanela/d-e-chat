import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final Function(String?) validator;
  final String label;
  final TextInputType textInputType;
  final TextEditingController textEditingController;

  final bool obscureText;

  final IconData icon;

  const InputField(
      {Key? key,
      required this.hintText,
      required this.validator,
      required this.textEditingController,
      required this.label,
      required this.textInputType,
      this.obscureText = false,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: hintText,
          contentPadding: EdgeInsets.zero,
          suffixIcon: Icon(icon),
          labelText: label),
      validator: (string) => validator(string),
      controller: textEditingController,
      textInputAction: TextInputAction.next,
      keyboardType: textInputType,
      obscureText: obscureText,
    );
  }
}
