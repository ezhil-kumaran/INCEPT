import 'package:flutter/material.dart';

void showloadingCircle(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(child: CircularProgressIndicator()),
    ),
  );
}

void hideloadingCircle(BuildContext context) {
  Navigator.pop(context);
}
