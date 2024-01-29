import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rewear/model/post.dart';
import 'package:rewear/resources/storage_image.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String title, String description, int price,
      Uint8List file, String uid, String username) async {
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file);
      String postId = const Uuid().v1();
      Post post = Post(
        title: title,
        description: description,
        price: price,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        saves: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> savePost(String postId, String uid, List saves) async {
    String res = "Some error occurred";
    try {
      if (saves.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> getSavedPosts(String userId) async {
    List<Map<String, dynamic>> savedPosts = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').where('saves', arrayContains: userId).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> post = documentSnapshot.data() as Map<String, dynamic>;
        savedPosts.add(post);
      }
    } catch (err) {
      print('Error fetching saved posts: $err');
    }

    return savedPosts;
  }




  Future<String> postComment(
      String postId, String text, String uid, String name) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Add rating
  Future<String> addRating(
      String raterUid, String ratedUid, int ratingValue) async {
    String res = "Some error occurred";
    try {
      Map<String, dynamic> rating = {
        'raterUid': raterUid,
        'rating': ratingValue,
      };

      // Add the rating to the 'ratings' array of the rated user
      await _firestore.collection('users').doc(ratedUid).update({
        'ratings': FieldValue.arrayUnion([rating])
      });

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
