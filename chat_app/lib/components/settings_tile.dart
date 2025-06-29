import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget action;

  const SettingsTile({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.only(top: 8.0, left: 30.0, right: 30.0),
      padding: const EdgeInsets.all(8.0),
      child: ListTile(title: Text(title), trailing: action),
    );
  }
}
