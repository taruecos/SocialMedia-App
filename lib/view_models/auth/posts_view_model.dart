import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/screens/mainscreen.dart';
import 'package:social_media_app/services/post_service.dart';
import 'package:social_media_app/services/user_service.dart';
import 'package:social_media_app/utils/constants.dart';
import 'package:social_media_app/utils/firebase.dart';

class PostsViewModel extends ChangeNotifier {
  UserService userService = UserService();
  PostService postService = PostService(
    firebaseAuth: FirebaseAuth.instance,
    usersRef: FirebaseFirestore.instance.collection('users'),
    postRef: FirebaseFirestore.instance.collection('posts'),
  );

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;
  String? username;
  File? mediaUrl;
  final picker = ImagePicker();
  String? location;
  Position? position;
  Placemark? placemark;
  String? bio;
  String? description;
  String? email;
  String? ownerId;
  String? userId;
  String? type;
  File? userDp;
  String? imgLink;
  bool edit = false;
  String? id;

  TextEditingController locationTEC = TextEditingController();
  TextEditingController descriptionText = TextEditingController();

  setEdit(bool val) {
    edit = val;
    notifyListeners();
  }

  setPost(PostModel post) {
    // ignore: unnecessary_null_comparison
    if (post != null) {
      description = post.description;
      imgLink = post.mediaUrl;
      location = post.location;
      edit = true;
      edit = false;
      notifyListeners();
    } else {
      edit = false;
      notifyListeners();
    }
  }

  setUsername(String val) {
    username = val;
    notifyListeners();
  }

  setDescription(String val) {
    print('SetDescription $val');
    description = val;
    descriptionText.text = description!;
    notifyListeners();
  }

  setLocation(String val) {
    location = val;
    notifyListeners();
  }

  setBio(String val) {
    bio = val;
    notifyListeners();
  }

  setImgLink(String? val) {
    print('SetImgLink $val');
    imgLink = val;
    notifyListeners();
  }

  pickImage({bool camera = false, BuildContext? context}) async {
    loading = true;
    notifyListeners();
    try {
      PickedFile? pickedFile = await picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Constants.lightAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );
      mediaUrl = File(croppedFile!.path);
      setImgLink(croppedFile.path); // Call setImgLink to update imgLink
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancelled', context);
    }
  }

  getLocation() async {
    loading = true;
    notifyListeners();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission rPermission = await Geolocator.requestPermission();
      await getLocation();
      return;
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position == null) {
      loading = false;
      notifyListeners();
      return;
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    if (placemarks.isEmpty) {
      loading = false;
      notifyListeners();
      return;
    }

    placemark = placemarks[0];
    location = "${placemark?.locality}, ${placemark?.country}";
    locationTEC.text = location!;

    loading = false;
    notifyListeners();
  }

  uploadPosts(BuildContext context) async {
    // Check for null values before proceeding.
    if (mediaUrl == null || location == null || description == null) {
      showInSnackBar('Required values missing!', context);
      return;
    }

    try {
      loading = true;
      notifyListeners();
      await postService.uploadPost(mediaUrl!, location!, description!);
      loading = false;
      resetPost();
      notifyListeners();
    } catch (e) {
      print(e);
      loading = false;
      resetPost();
      showInSnackBar('Uploaded successfully!', context);
      notifyListeners();
    }
  }

  uploadProfilePicture(BuildContext context) async {
    if (mediaUrl == null) {
      showInSnackBar('Please select an image', context);
      return;
    }

    final user = firebaseAuth.currentUser;
    if (user == null) {
      showInSnackBar('User not available!', context);
      return;
    }

    try {
      loading = true;
      notifyListeners();
      await postService.uploadProfilePicture(mediaUrl!, user);
      loading = false;
      Navigator.of(context)
          .pushReplacement(CupertinoPageRoute(builder: (_) => TabScreen()));
      notifyListeners();
    } catch (e) {
      print(e);
      loading = false;
      showInSnackBar('Uploaded successfully!', context);
      notifyListeners();
    }
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    location = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
