import 'package:chat_app/components/loadingcircle.dart';
import 'package:chat_app/components/mybutton.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/database/database_service.dart';
import 'package:flutter/material.dart';

class Registerpage extends StatefulWidget {
  final void Function()? onTap;
  const Registerpage({super.key, required this.onTap});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController pwdcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController confirmcontroller = TextEditingController();
  final _auth = AuthService();
  final _db = DatabaseService();

  void register() async {
    if (pwdcontroller.text == confirmcontroller.text) {
      showloadingCircle(context);
      try {
        await _auth.registerWithEmailAndPassword(
          emailcontroller.text,
          pwdcontroller.text,
        );
        await _db.saveUserInfoInFirebase(
          name: namecontroller.text,
          email: emailcontroller.text,
        );
        if (mounted) {
          hideloadingCircle(context);
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          hideloadingCircle(context);
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Registration failed: $e")));
      }
    } else {
      if (mounted) {
        hideloadingCircle(context);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Icon(
                  Icons.lock_open_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 50),
                Text(
                  "Let's create your account",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 25),
                Mytextfield(
                  hintText: "Enter name..",
                  controller: namecontroller,
                ),
                const SizedBox(height: 10),
                Mytextfield(
                  hintText: "Enter email..",
                  controller: emailcontroller,
                ),
                const SizedBox(height: 10),
                Mytextfield(
                  hintText: "Enter password..",
                  obscureText: true,
                  controller: pwdcontroller,
                ),
                const SizedBox(height: 10),
                Mytextfield(
                  hintText: "Confirm password..",
                  obscureText: true,
                  controller: confirmcontroller,
                ),
                const SizedBox(height: 20),
                Mybutton(text: "SIGN-UP", onPressed: register),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Aldreay have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
