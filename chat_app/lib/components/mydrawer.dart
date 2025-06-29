import 'package:chat_app/components/mydrawer_tile.dart';
import 'package:chat_app/pages/settingspage.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/pages/profilepage.dart';
import 'package:chat_app/pages/searchpage.dart';

class Mydrawer extends StatelessWidget {
  final _auth = AuthService();
  void logout() async {
    try {
      await _auth.logout();
    } catch (e) {
      print("Failed to logout: $e");
    }
  }

  Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90, bottom: 20),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: Theme.of(context).colorScheme.secondary,
              thickness: 8,
            ),
            const SizedBox(height: 20),
            MydrawerTile(
              title: "H O M E",
              icon: Icons.home,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            MydrawerTile(
              title: "P R O F I L E",
              icon: Icons.person,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profilepage(uid: _auth.userId()),
                  ),
                );
              },
            ),
            MydrawerTile(
              title: "S E A R C H",
              icon: Icons.search,
              onTap: () {
                Navigator.pop(context);
                // Navigate to search page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            MydrawerTile(
              title: "S E T T I N G S",
              icon: Icons.settings,
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settingspage()),
                );
              },
            ),
            Spacer(),
            MydrawerTile(
              title: "L O G O U T",
              icon: Icons.logout,
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
