import 'package:chat_app/components/mydrawer.dart';
import 'package:chat_app/components/myinputalertbox.dart';
import 'package:chat_app/components/navigation.dart';
import 'package:chat_app/components/posttile.dart';
import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/database/databaseprovider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final listeningprovider = Provider.of<Databaseprovider>(
    context,
    listen: true,
  );
  late final databaseprovider = Provider.of<Databaseprovider>(
    context,
    listen: false,
  );

  final TextEditingController _msgcontroller = TextEditingController();

  void postmsg(String message) async {
    if (message.isNotEmpty) {
      await databaseprovider.postmessage(
        message,
      ); // Close the dialog after posting
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Message cannot be empty')));
    }
  }

  void _openpostmessage() {
    showDialog(
      context: context,
      builder: (context) => Myinputalertbox(
        biocontroller: _msgcontroller,
        hintText: "What's on your mind?",
        onSubmit: () => postmsg(_msgcontroller.text),
        submittext: "Post",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadallposts();
  }

  Future<void> loadallposts() async {
    await databaseprovider.getallposts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: Mydrawer(),
        appBar: AppBar(
          title: const Text('H O M E'),
          foregroundColor: Theme.of(context).colorScheme.primary,
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
              Tab(text: 'For you'),
              Tab(text: 'Following'),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _openpostmessage,
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            _buildpostslist(listeningprovider.allposts),
            _buildpostslist(listeningprovider.follwingposts),
          ],
        ),
      ),
    );
  }

  Widget _buildpostslist(List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text("No posts yet!"));
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostTile(
          post: post,
          ontapUsername: () => gotoUserprofile(context, post.uid),
          ontapPost: () => gotoPostpage(context, post),
        );
      },
    );
  }
}
