import 'package:chat_app/components/navigation.dart';
import 'package:chat_app/components/posttile.dart';
import 'package:chat_app/services/database/databaseprovider.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/post.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/components/commenttile.dart';

class Postpage extends StatefulWidget {
  final Post post;
  const Postpage({super.key, required this.post});

  @override
  State<Postpage> createState() => _PostpageState();
}

class _PostpageState extends State<Postpage> {
  late final listeningprovider = Provider.of<Databaseprovider>(
    context,
    listen: true,
  );
  late final databaseprovider = Provider.of<Databaseprovider>(
    context,
    listen: false,
  );
  @override
  Widget build(BuildContext context) {
    final allcomments = listeningprovider.getComments(widget.post.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('C O M M E N T S'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          PostTile(
            post: widget.post,
            ontapUsername: () => gotoUserprofile(context, widget.post.uid),
            ontapPost: () {},
          ),
          allcomments.isEmpty
              ? const Center(
                  child: Text(
                    'No comments yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allcomments.length,
                  itemBuilder: (context, index) {
                    final comment = allcomments[index];
                    return Commenttile(
                      comment: comment,
                      ontapUsername: () =>
                          gotoUserprofile(context, comment.uid),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
