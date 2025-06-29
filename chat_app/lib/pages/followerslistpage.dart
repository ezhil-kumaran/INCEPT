import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/database/databaseprovider.dart';
import 'package:chat_app/pages/profilepage.dart';

class Followerslistpage extends StatefulWidget {
  final String uid;
  const Followerslistpage({super.key, required this.uid});

  @override
  State<Followerslistpage> createState() => _FollowerslistpageState();
}

class _FollowerslistpageState extends State<Followerslistpage> {
  late final databaseprovider = Provider.of<Databaseprovider>(
    context,
    listen: false,
  );
  late final listeningprovider = Provider.of<Databaseprovider>(
    context,
    listen: true,
  );
  @override
  void initState() {
    super.initState();
    loadfollowers();
    loadfollowing();
    // You can initialize any data here if needed
  }

  Future<void> loadfollowers() async {
    // You can load any data here if needed
    await databaseprovider.getfollowersprofilefromfirebase(widget.uid);
  }

  Future<void> loadfollowing() async {
    // You can load any data here if needed
    await databaseprovider.getfollowingprofilefromfirebase(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followerslist = listeningprovider.getfollowersprofile(widget.uid);
    final followinglist = listeningprovider.getfollowingprofile(widget.uid);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(followerslist, 'No followers found'),
            _buildList(followinglist, 'not yet followed anyone'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _buildList(List<userProfile> userslist, String message) {
    if (userslist.isEmpty) {
      return Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: userslist.length,
        itemBuilder: (context, index) {
          final user = userslist[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                user.name,
                style: TextStyle(
                  fontSize: 21,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              subtitle: Text(
                '@${user.username}',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              leading: Icon(Icons.person),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profilepage(uid: user.uid),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
