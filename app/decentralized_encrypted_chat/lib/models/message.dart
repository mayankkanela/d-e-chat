import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final Timestamp timestamp;
  Message(this.message, this.timestamp);
}
