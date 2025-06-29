import 'package:chat_app/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/pages/registerpage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool isLogin = true;

  void toggleView() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Loginpage(onTap: toggleView);
    } else {
      return Registerpage(onTap: toggleView);
    }
  }
}
