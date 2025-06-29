import 'package:flutter/material.dart';

class Myinputalertbox extends StatelessWidget {
  final TextEditingController biocontroller;
  final String hintText;
  final Function()? onSubmit;
  final String submittext;

  const Myinputalertbox({
    super.key,
    required this.biocontroller,
    required this.hintText,
    required this.onSubmit,
    required this.submittext,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: TextField(
        controller: biocontroller,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        maxLength: 300,
        maxLines: 4,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            biocontroller.clear();
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onSubmit!();
            biocontroller.clear();
          },
          child: Text(
            submittext,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
