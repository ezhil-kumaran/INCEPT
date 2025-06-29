import "package:cloud_firestore/cloud_firestore.dart";

class userProfile {
  final String uid;
  final String email;
  final String name;
  final String username;
  final String bio;

  userProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.username,
    required this.bio,
  });

  factory userProfile.fromDocumentSnapshot(DocumentSnapshot doc) {
    return userProfile(
      uid: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      username: doc['username'],
      bio: doc['bio'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
    };
  }
}
