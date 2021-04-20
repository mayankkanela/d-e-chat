import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

User? getUser() {
  return _auth.currentUser;
}
