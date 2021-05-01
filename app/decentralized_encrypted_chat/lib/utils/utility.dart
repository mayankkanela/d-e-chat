import 'package:flutter/cupertino.dart';

bool isNullOrEmpty(String? string) {
  if (string == null || string.isEmpty)
    return true;
  else
    return false;
}

String? emptyOrNullStringValidator(String? value) {
  if (isNullOrEmpty(value)) {
    return "Cannot be empty!";
  } else
    return null;
}

String? confirmPasswordValidator(String? value1, String? value2) {
  final val = isNullOrEmpty(value1);
  if (val)
    return null;
  else if (value1 != value2) {
    return "Passwords do not match!";
  } else
    return null;
}

Future<void> pushNamedReplacement(
    {required BuildContext context, required String path}) async {
  await Navigator.of(context).pushReplacementNamed(path);
}

Future<void> pushNamed(
    {required BuildContext context, required String path}) async {
  await Navigator.of(context).pushNamed(path);
}
