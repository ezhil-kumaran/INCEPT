import 'package:flutter/material.dart';

class Myfollowbutton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing; // Placeholder for actual following logic

  const Myfollowbutton({super.key, this.onPressed, required this.isFollowing});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        onPressed: onPressed,
        color: (isFollowing)
            ? Theme.of(context).colorScheme.primary
            : Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: (isFollowing)
            ? Text("Un-follow", style: TextStyle(fontSize: 20))
            : Text(
                "Follow",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
      ),
    );
  }
}
