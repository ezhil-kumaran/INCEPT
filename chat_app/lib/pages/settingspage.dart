import 'package:chat_app/components/settings_tile.dart';
import 'package:chat_app/theme/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settingspage extends StatelessWidget {
  const Settingspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          SettingsTile(
            title: "DARK MODE",
            action: CupertinoSwitch(
              onChanged: (value) => Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(),
              value: Provider.of<ThemeProvider>(context, listen: false).isDark,
            ),
          ),
        ],
      ),
    );
  }
}
