import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String postId;
  String uid;
  String username;
  String name;
  String message;
  Timestamp timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.uid,
    required this.username,
    required this.name,
    required this.message,
    required this.timestamp,
  });
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      postId: doc['postId'],
      uid: doc['uid'],
      username: doc['username'],
      name: doc['name'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'uid': uid,
      'username': username,
      'name': name,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
