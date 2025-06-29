import 'package:flutter/material.dart';
import 'package:chat_app/models/comment.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/database/databaseprovider.dart';
import 'package:provider/provider.dart';

class Commenttile extends StatelessWidget {
  final Comment comment;
  final void Function()? ontapUsername;

  const Commenttile({
    super.key,
    required this.comment,
    required this.ontapUsername,
  });
  void _showMoreOptions(BuildContext context) {
    final String currentUserId = AuthService().userId();
    bool isCurrentUserComment = comment.uid == currentUserId;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isCurrentUserComment)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text(
                    'Delete Comment',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: () async {
                    // Handle delete post action
                    await Provider.of<Databaseprovider>(
                      context,
                      listen: false,
                    ).deleteComment(comment.id, comment.postId);
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: ontapUsername,
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 3),
                Text(
                  comment.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '@${comment.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => _showMoreOptions(context),
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(comment.message, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
