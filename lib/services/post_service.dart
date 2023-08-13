import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/services/services.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:uuid/uuid.dart';

class PostService extends Service {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _usersRef;
  final CollectionReference _postRef;

  String postId = Uuid().v4();

  PostService({
    required FirebaseAuth firebaseAuth,
    required CollectionReference usersRef,
    required CollectionReference postRef,
    // required CollectionReference notificationRef,
  })  : _firebaseAuth = firebaseAuth,
        _usersRef = usersRef,
        _postRef = postRef;

  Future<UserModel?> _getCurrentUser() async {
    try {
      DocumentSnapshot doc =
          await _usersRef.doc(_firebaseAuth.currentUser?.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }

  /// Uploads profile picture to the users collection
  Future<void> uploadProfilePicture(File image, User user) async {
    try {
      String link = await uploadImage(profilePic, image);
      var ref = _usersRef.doc(_firebaseAuth.currentUser?.uid);
      await ref.update({"photoUrl": link});
    } catch (e) {
      print("Error uploading profile picture: $e");
    }
  }

  /// Uploads post to the post collection
  Future<void> uploadPost(
      File image, String location, String description) async {
    try {
      String link = await uploadImage(posts, image);
      UserModel? user = await _getCurrentUser();
      if (user != null) {
        var ref = _postRef.doc();
        await ref.set({
          "id": ref.id,
          "postId": ref.id,
          "username": user.username,
          "ownerId": _firebaseAuth.currentUser?.uid,
          "mediaUrl": link,
          "description": description,
          "location": location,
          "timestamp": Timestamp.now(),
        });
      }
    } catch (e) {
      print("Error uploading post: $e");
    }
  }
}
