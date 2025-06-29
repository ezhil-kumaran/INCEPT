import 'package:chat_app/components/biobox.dart';
import 'package:chat_app/components/myfollowbutton.dart';
import 'package:chat_app/components/myinputalertbox.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/database/databaseprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/components/posttile.dart';
import 'package:chat_app/components/navigation.dart';
import 'package:chat_app/components/profilestats.dart';
import 'package:chat_app/pages/followerslistpage.dart';

class Profilepage extends StatefulWidget {
  final String uid;
  const Profilepage({super.key, required this.uid});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late final databaseprovider = Provider.of<Databaseprovider>(
    context,
    listen: false,
  );
  late final listeningprovider = Provider.of<Databaseprovider>(
    context,
    listen: true,
  );
  userProfile? user;
  String userid = AuthService().userId();
  final TextEditingController biocontroller = TextEditingController();

  bool isLoading = true;
  bool _isfollowing = false;
  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    user = await databaseprovider.userprofile(widget.uid);
    _isfollowing = databaseprovider.isFollowing(widget.uid);
    databaseprovider.getfollowers(widget.uid);
    databaseprovider.getfollowing(widget.uid);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> savebioindb() async {
    setState(() {
      isLoading = true;
    });
    await databaseprovider.savebio(biocontroller.text);

    await loadUserProfile();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alluserposts = listeningprovider.filterUserposts(widget.uid);
    _isfollowing = listeningprovider.isFollowing(widget.uid);
    void showeditbiobox() {
      showDialog(
        context: context,
        builder: (context) {
          return Myinputalertbox(
            biocontroller: biocontroller,
            hintText: "Edit bio..",
            onSubmit: savebioindb,
            submittext: "Save",
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          isLoading ? "" : user!.name,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            gohomepage(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              isLoading ? "" : '@${user!.username}',
              style: TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: EdgeInsets.all(20),
              child: Icon(Icons.person, size: 70),
            ),
          ),
          const SizedBox(height: 20),
          Profilestats(
            postcount: alluserposts.length,
            followersCount: listeningprovider.getfollowerscount(widget.uid),
            followingCount: listeningprovider.getfollowingcount(widget.uid),
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Followerslistpage(uid: widget.uid),
              ),
            ),
          ),
          if (user != null && user!.uid != userid)
            Myfollowbutton(
              onPressed: () async {
                await databaseprovider.followUnfollowUser(widget.uid);
                await loadUserProfile();
                setState(() {
                  _isfollowing = !_isfollowing;
                });
              },
              isFollowing: _isfollowing,
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              "bio",
              style: TextStyle(
                fontSize: 16.5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Stack(
            children: [
              Biobox(bio: isLoading ? "..." : user!.bio),
              if (user != null && user!.uid == userid)
                Positioned(
                  bottom: 12,
                  right: 22,
                  child: GestureDetector(
                    onTap: showeditbiobox,
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              "Posts",
              style: TextStyle(
                fontSize: 16.5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          alluserposts.isEmpty
              ? const Center(child: Text("No posts yet!"))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: alluserposts.length,
                  itemBuilder: (context, index) {
                    final post = alluserposts[index];
                    return PostTile(
                      post: post,
                      ontapUsername: () {},
                      ontapPost: () {
                        gotoPostpage(context, post);
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}
