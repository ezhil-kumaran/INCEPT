import 'package:chat_app/models/post.dart';
import "package:flutter/material.dart";
import 'package:chat_app/pages/profilepage.dart';
import 'package:chat_app/pages/postpage.dart';
import 'package:chat_app/pages/homepage.dart';

void gotoUserprofile(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Profilepage(uid: uid)),
  );
}

void gotoPostpage(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Postpage(post: post)),
  );
}

void gohomepage(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Homepage()),
    (route) => route.isFirst,
  );
}
