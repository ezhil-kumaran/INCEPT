import 'package:chat_app/models/post.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/comment.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserInfoInFirebase({
    required String name,
    required String email,
  }) async {
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];

    userProfile user = userProfile(
      uid: uid,
      email: email,
      name: name,
      username: username,
      bio: '',
    );
    final userMap = user.toMap();
    await _firestore.collection('users').doc(uid).set(userMap);
  }

  Future<userProfile?> getUserInfoFromFirebase(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      return userProfile.fromDocumentSnapshot(doc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updatebioinfirebase(String bio) async {
    String uid = AuthService().userId();
    try {
      await _firestore.collection('users').doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
      throw Exception("Failed to update bio: $e");
    }
  }

  Future<void> postmessageinfirebase({required String message}) async {
    try {
      String uid = _auth.currentUser!.uid;

      userProfile? user = await getUserInfoFromFirebase(uid);

      Post post = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likecount: 0,
        likesList: [],
      );
      Map<String, dynamic> postMap = post.toMap();
      await _firestore.collection('posts').add(postMap);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Post>> getAllPostsfromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> likePost(String postId) async {
    String uid = _auth.currentUser!.uid;
    try {
      DocumentReference postDoc = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);
        List<String> likesList = List<String>.from(
          postSnapshot['likesList'] ?? [],
        );
        int currentlikeCount = postSnapshot['likecount'];
        if (!likesList.contains(uid)) {
          likesList.add(uid);
          currentlikeCount++;
        } else {
          likesList.remove(uid);
          currentlikeCount--;
        }

        transaction.update(postDoc, {
          'likesList': likesList,
          'likecount': currentlikeCount,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addcommentinfirebase({
    required String postId,
    required String message,
  }) async {
    try {
      String uid = _auth.currentUser!.uid;
      userProfile? user = await getUserInfoFromFirebase(uid);

      Comment comment = Comment(
        id: '',
        postId: postId,
        uid: uid,
        username: user!.username,
        name: user.name,
        message: message,
        timestamp: Timestamp.now(),
      );
      Map<String, dynamic> commentMap = comment.toMap();
      await _firestore.collection('comments').add(commentMap);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Comment>> getCommentsForPost(String postId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .get();
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteCommentinfirebase(String commentId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> followUserfirebase(String uid) async {
    String currentUserId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(uid)
        .set({});
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(currentUserId)
        .set({});
  }

  Future<void> unfollowUserfirebase(String uid) async {
    String currentUserId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(uid)
        .delete();
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(currentUserId)
        .delete();
  }

  Future<List<String>> getfollowersFirebase(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('followers')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> getfollowingFirebase(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<userProfile>> searchuserfromfirebase(String query) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      return snapshot.docs
          .map((doc) => userProfile.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
