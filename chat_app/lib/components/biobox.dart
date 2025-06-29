import "package:flutter/material.dart";

class Biobox extends StatelessWidget {
  final String bio;
  const Biobox({super.key, required this.bio});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      width: 400,
      padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        bio.isEmpty ? "hello, I am new here!" : bio,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
