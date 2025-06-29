import 'package:chat_app/models/comment.dart';
import 'package:chat_app/models/post.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth/auth_service.dart';

class Databaseprovider extends ChangeNotifier {
  final _db = DatabaseService();

  Future<userProfile?> userprofile(String uid) =>
      _db.getUserInfoFromFirebase(uid);

  Future<void> savebio(String bio) => _db.updatebioinfirebase(bio);

  List<Post> _allposts = [];
  List<Post> _followingposts = [];
  List<Post> get allposts => _allposts;
  List<Post> get follwingposts => _followingposts;
  Future<void> postmessage(String messages) async {
    await _db.postmessageinfirebase(message: messages);

    await getallposts(); // Refresh posts after posting
  }

  Future<void> getallposts() async {
    final allposts = await _db.getAllPostsfromFirebase();
    _allposts = allposts;
    getfollowingposts();
    initializelikemap(); // Initialize like counts and liked posts
    notifyListeners();
  }

  List<Post> filterUserposts(String uid) {
    return _allposts.where((post) => post.uid == uid).toList();
  }

  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);
    await getallposts(); // Refresh posts after deletion
  }

  Future<void> getfollowingposts() async {
    final currentUserId = AuthService().userId();
    final followingPosts = await _db.getfollowingFirebase(currentUserId);
    _followingposts = _allposts
        .where((post) => followingPosts.contains(post.uid))
        .toList();
    notifyListeners();
  }

  Map<String, int> _likecounts = {};
  List<String> likedposts = [];
  bool islikedbyuser(String postId) {
    return likedposts.contains(postId);
  }

  int getlikecount(String postId) {
    return _likecounts[postId] ?? 0;
  }

  void initializelikemap() {
    _likecounts.clear();
    likedposts.clear();
    final currentUserId = AuthService().userId();

    for (var post in _allposts) {
      _likecounts[post.id] = post.likecount;
      if (post.likesList.contains(currentUserId)) {
        likedposts.add(post.id);
      }
    }
  }

  Future<void> likePost(String postId) async {
    final origiallikecount = _likecounts;
    final originallikedposts = likedposts;

    if (likedposts.contains(postId)) {
      likedposts.remove(postId);
      _likecounts[postId] = (_likecounts[postId] ?? 1) - 1;
    } else {
      likedposts.add(postId);
      _likecounts[postId] = (_likecounts[postId] ?? 0) + 1;
    }
    notifyListeners();
    try {
      await _db.likePost(postId);
    } catch (e) {
      // Rollback changes if the like operation fails
      _likecounts = origiallikecount;
      likedposts = originallikedposts;
      notifyListeners();
    }
  }

  final Map<String, List<Comment>> _comments = {};
  List<Comment> getComments(String postId) {
    return _comments[postId] ?? [];
  }

  Future<void> getCommentsForPost(String postId) async {
    final allcomments = await _db.getCommentsForPost(postId);
    _comments[postId] = allcomments;
    notifyListeners();
  }

  Future<void> addComment(String postId, message) async {
    await _db.addcommentinfirebase(postId: postId, message: message);
    await getCommentsForPost(postId);
  }

  Future<void> deleteComment(String commentId, postid) async {
    await _db.deleteCommentinfirebase(commentId);
    await getCommentsForPost(postid);
  }

  final Map<String, List<String>> _followerslist = {};
  final Map<String, List<String>> _followinglist = {};
  final Map<String, int> _followerscount = {};
  final Map<String, int> _followingcount = {};

  int getfollowerscount(String uid) {
    return _followerscount[uid] ?? 0;
  }

  int getfollowingcount(String uid) {
    return _followingcount[uid] ?? 0;
  }

  Future<void> getfollowers(String uid) async {
    final followers = await _db.getfollowersFirebase(uid);
    _followerslist[uid] = followers;
    _followerscount[uid] = followers.length;
    notifyListeners();
  }

  Future<void> getfollowing(String uid) async {
    final following = await _db.getfollowingFirebase(uid);
    _followinglist[uid] = following;
    _followingcount[uid] = following.length;
    notifyListeners();
  }

  Future<void> followUnfollowUser(String targetuid) async {
    final currentUserId = AuthService().userId();

    _followerslist.putIfAbsent(targetuid, () => []);
    _followinglist.putIfAbsent(currentUserId, () => []);
    if (_followinglist[currentUserId]?.contains(targetuid) ?? false) {
      _followerslist[targetuid]?.remove(currentUserId);
      _followerscount[targetuid] = (_followerscount[targetuid] ?? 1) - 1;
      // Already following, unfollow
      _followinglist[currentUserId]?.remove(targetuid);
      _followingcount[currentUserId] =
          (_followingcount[currentUserId] ?? 1) - 1;
      notifyListeners();
      try {
        await _db.unfollowUserfirebase(targetuid);
        await getfollowers(currentUserId);
        await getfollowing(currentUserId);
      } catch (e) {
        // Handle error if unfollow fails
        _followerslist[targetuid]?.add(currentUserId);
        _followerscount[targetuid] = (_followerscount[targetuid] ?? 0) + 1;
        _followinglist[currentUserId]?.add(targetuid);
        _followingcount[currentUserId] =
            (_followingcount[currentUserId] ?? 0) + 1;
        notifyListeners();
      }
    } else {
      _followerslist[targetuid]?.add(currentUserId);
      _followerscount[targetuid] = (_followerscount[targetuid] ?? 0) + 1;
      // Not following, follow
      _followinglist[currentUserId]?.add(targetuid);
      _followingcount[currentUserId] =
          (_followingcount[currentUserId] ?? 0) + 1;
      notifyListeners();
      try {
        await _db.followUserfirebase(targetuid);
        await getfollowers(currentUserId);
        await getfollowing(currentUserId);
      } catch (e) {
        // Handle error if follow fails
        _followerslist[targetuid]?.remove(currentUserId);
        _followerscount[targetuid] = (_followerscount[targetuid] ?? 1) - 1;
        _followinglist[currentUserId]?.remove(targetuid);
        _followingcount[currentUserId] =
            (_followingcount[currentUserId] ?? 1) - 1;
        notifyListeners();
      }
    }
  }

  bool isFollowing(String targetuid) {
    final currentUserId = AuthService().userId();
    return _followerslist[targetuid]?.contains(currentUserId) ?? false;
  }

  final Map<String, List<userProfile>> followerprofile = {};
  final Map<String, List<userProfile>> followingprofile = {};

  List<userProfile> getfollowersprofile(String uid) {
    return followerprofile[uid] ?? [];
  }

  List<userProfile> getfollowingprofile(String uid) {
    return followingprofile[uid] ?? [];
  }

  Future<void> getfollowersprofilefromfirebase(String uid) async {
    final followers = await _db.getfollowersFirebase(uid);
    List<userProfile> followersprofiles = [];
    for (String followerUid in followers) {
      final profile = await userprofile(followerUid);
      if (profile != null) {
        followersprofiles.add(profile);
      }
    }
    followerprofile[uid] = followersprofiles;
    notifyListeners();
  }

  Future<void> getfollowingprofilefromfirebase(String uid) async {
    final following = await _db.getfollowingFirebase(uid);
    List<userProfile> followingprofiles = [];
    for (String followingUid in following) {
      final profile = await userprofile(followingUid);
      if (profile != null) {
        followingprofiles.add(profile);
      }
    }
    followingprofile[uid] = followingprofiles;
    notifyListeners();
  }

  List<userProfile> _searchresults = [];
  List<userProfile> get searchresults => _searchresults;
  Future<void> searchuserfromfirebase(String query) async {
    final results = await _db.searchuserfromfirebase(query);
    _searchresults = results;
    notifyListeners();
  }
}
