import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/view_image.dart';
import 'package:social_media_app/services/services.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:uuid/uuid.dart';

class PostService extends Service {
  String postId = Uuid().v4();

  // Uploads profile picture to the users collection
  Future<void> uploadProfilePicture(File image, User user) async {
    try {
      String link = await uploadImage(profilePic, image);
      var ref = usersRef.doc(user.uid);
      await ref.update({"photoUrl": link});
    } catch (e) {
      print('Error uploading profile picture: $e');
      throw e; // Rethrow the error for caller to handle
    }
  }

  // Uploads post to the post collection
  Future<void> uploadPost(File invoiceImg, File itemImg) async {
    try {
      String invoiceLink = await uploadImage(posts, invoiceImg);
      String itemLink = await uploadImage(posts, itemImg);
      DocumentSnapshot doc =
          await usersRef.doc(firebaseAuth.currentUser!.uid).get();
      user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

      var ref = postRef.doc();
      await ref.set({
        "id": ref.id,
        "postId": ref.id,
        "username": user!.username,
        "ownerId": firebaseAuth.currentUser!.uid,
        "itemImage": itemLink,
        "invoiceImage": invoiceLink,
        "timestamp": Timestamp.now(),
      });
    } catch (e) {
      print('Error uploading post: $e');
      throw e; // Rethrow the error for caller to handle
    }
  }
}
