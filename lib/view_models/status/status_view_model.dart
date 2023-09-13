import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/status.dart';
import 'package:social_media_app/posts/story/confrim_status.dart';
import 'package:social_media_app/services/post_service.dart';
import 'package:social_media_app/services/status_services.dart';
import 'package:social_media_app/services/user_service.dart';
import 'package:social_media_app/utils/constants.dart';

class StatusViewModel extends ChangeNotifier {
  //Services
  late final UserService userService;
  late final PostService postService;
  late final StatusService statusService;
  //Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Variables
  bool loading = false;
  String? username;
  File? mediaUrl;
  final picker = ImagePicker();
  String? description;
  String? email;
  String? userDp;
  String? userId;
  String? imgLink;
  bool edit = false;
  String? id;

  //integers
  int pageIndex = 0;

  setDescription(String val) {
    print('SetDescription $val');
    description = val;
    notifyListeners();
  }

  void handleCapturedImage(String filePath, BuildContext context) {
    mediaUrl = File(filePath);
    loading = false;
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => ConfirmStatus(),
      ),
    );
    notifyListeners();
  }

  //Functions
  //Functions
  Future<void> pickImage({
    CameraController? cameraController,
    bool camera = false,
    BuildContext? context,
  }) async {
    loading = true;
    notifyListeners();

    try {
      print("Pick Image called with camera as $camera");
      if (camera && cameraController != null) {
        final XFile file = await cameraController.takePicture();
        processImage(file.path, context);
      } else {
        PickedFile? pickedFile =
            await picker.getImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          processImage(pickedFile.path, context);
        }
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancelled', context);
    }
  }

  Future<void> processImage(String path, BuildContext? context) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
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
      if (croppedFile != null) {
        mediaUrl = File(croppedFile.path);
        loading = false;
        Navigator.of(context!).push(
          CupertinoPageRoute(
            builder: (_) => ConfirmStatus(),
          ),
        );
        notifyListeners();
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Error processing image', context);
    }
  }

  //send message
  sendStatus(String chatId, StatusModel message) {
    statusService.sendStatus(
      message,
      chatId,
    );
  }

  //send the first message
  Future<String> sendFirstStatus(StatusModel message) async {
    String newChatId = await statusService.sendFirstStatus(
      message,
    );

    return newChatId;
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
