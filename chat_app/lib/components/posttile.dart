import 'package:chat_app/components/myinputalertbox.dart';
import 'package:chat_app/components/timestamphelp.dart';
import 'package:chat_app/models/post.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/database/databaseprovider.dart';
import 'package:provider/provider.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? ontapUsername;
  final void Function()? ontapPost;
  const PostTile({
    super.key,
    required this.post,
    required this.ontapUsername,
    required this.ontapPost,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final databaseProvider = Provider.of<Databaseprovider>(
    context,
    listen: false,
  );
  late final listeningProvider = Provider.of<Databaseprovider>(
    context,
    listen: true,
  );
  final String currentUserId = AuthService().userId();
  final commentcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadcomments();
  }

  void liketoggle() async {
    try {
      await databaseProvider.likePost(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addcomment() async {
    if (commentcontroller.text.trim().isEmpty) return;
    try {
      await databaseProvider.addComment(
        widget.post.id,
        commentcontroller.text.trim(),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadcomments() async {
    await databaseProvider.getCommentsForPost(widget.post.id);
  }

  void _opencommentbox() {
    showDialog(
      context: context,
      builder: (context) => Myinputalertbox(
        biocontroller: commentcontroller,
        hintText: "comment",
        onSubmit: () async {
          await _addcomment();
        },
        submittext: "post",
      ),
    );
  }

  void _showMoreOptions() {
    bool isCurrentUserPost = widget.post.uid == currentUserId;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isCurrentUserPost)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text(
                    'Delete Post',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: () {
                    // Handle delete post action
                    databaseProvider.deletePost(widget.post.id);
                    Navigator.pop(context);
                  },
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.flag),
                  title: Text(
                    'Report Post',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block),
                  title: Text(
                    'Block User',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text(
                  'cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  // Handle delete post action
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool likedbycurrentuser = listeningProvider.islikedbyuser(widget.post.id);
    int likecount = listeningProvider.getlikecount(widget.post.id);
    int commentcount = listeningProvider.getComments(widget.post.id).length;
    return GestureDetector(
      onTap: widget.ontapPost,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.ontapUsername,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '@${widget.post.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _showMoreOptions,
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(widget.post.message, style: TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: liketoggle,
                        child: (likedbycurrentuser)
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      Text(
                        likecount != 0 ? "$likecount" : " ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _opencommentbox,
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "  $commentcount",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  formatTimestamp(widget.post.timestamp),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
