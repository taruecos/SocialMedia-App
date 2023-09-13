import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/screens/mainscreen.dart';
import 'package:social_media_app/services/post_service.dart';
import 'package:social_media_app/services/user_service.dart';
import 'package:social_media_app/utils/constants.dart';
import 'package:social_media_app/utils/firebase.dart';

class PostsViewModel extends ChangeNotifier {
  late final UserService userService;
  late final PostService postService;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;
  String? username;
  File? itemImg;
  File? invoiceImg;
  final pickerInvoice = ImagePicker();
  final pickerItem = ImagePicker();
  String? description;
  String? email;
  String? ownerId;
  String? userId;
  String? type;
  File? userDp;
  String? profilePicture;
  String? invoiceLink;
  String? itemLink;
  bool edit = false;
  String? id;

  TextEditingController locationTEC = TextEditingController();

  setEdit(bool val) {
    edit = val;
    notifyListeners();
  }

  setPost(PostModel? post) {
    if (post != null) {
      description = post.description;
      itemLink = post.itemImage;
      invoiceLink = post.invoiceImage;
      edit = true;
    } else {
      edit = false;
    }
    notifyListeners();
  }

  // Other setters...

  Future<void> pickImage({
    bool camera = false,
    BuildContext? context,
    bool isInvoice = false,
  }) async {
    loading = true;
    notifyListeners();

    PickedFile? pickedFile = await (isInvoice
        ? pickerInvoice.getImage(
            source: camera ? ImageSource.camera : ImageSource.gallery)
        : pickerItem.getImage(
            source: camera ? ImageSource.camera : ImageSource.gallery));

    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
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

      if (isInvoice) {
        invoiceImg = croppedFile != null ? File(croppedFile.path) : null;
      } else {
        itemImg = croppedFile != null ? File(croppedFile.path) : null;
      }
    }

    loading = false;
    notifyListeners();
  }

  Future<void> uploadPosts(BuildContext context) async {
    if (invoiceImg == null || itemImg == null) {
      showInSnackBar('Both images are required!', context);
      return;
    }

    try {
      print("Uploading invoiceImg to: $invoiceImg");
      print("Uploading itemImg to: $itemImg");
      loading = true;
      notifyListeners();

      await postService.uploadPost(invoiceImg!, itemImg!);

      resetPost(); // Move this line inside the try block
    } catch (e, s) {
      print(e);
      print('Upload error!' + s.toString());
    } finally {
      // Use a finally block to ensure loading and notification reset
      loading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfilePicture(BuildContext context) async {
    if (userDp == null) {
      showInSnackBar('Please select an image', context);
    } else {
      try {
        loading = true;
        notifyListeners();
        await postService.uploadProfilePicture(
            userDp!, firebaseAuth.currentUser!);
        loading = false;
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (_) => TabScreen()));
        notifyListeners();
      } catch (e) {
        print(e);
        loading = false;
        showInSnackBar('Upload error!', context);
        notifyListeners();
      }
    }
  }

  resetPost() {
    itemImg = null;
    invoiceImg = null;
    description = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext? context) {
    if (context != null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value)));
    }
  }
}



// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:social_media_app/models/post.dart';
// import 'package:social_media_app/screens/mainscreen.dart';
// import 'package:social_media_app/services/post_service.dart';
// import 'package:social_media_app/services/user_service.dart';
// import 'package:social_media_app/utils/constants.dart';
// import 'package:social_media_app/utils/firebase.dart';

// class PostsViewModel extends ChangeNotifier {
//   // Services
//   UserService userService = UserService();
//   PostService postService = PostService();

//   // Keys
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   // Variables
//   bool loading = false;
//   String? username;
//   File? itemImg;
//   File? invoiceImg;
//   final pickerInvoice = ImagePicker();
//   final pickerItem = ImagePicker();
//   Placemark? placemark;
//   String? description;
//   String? email;
//   String? ownerId;
//   String? userId;
//   String? type;
//   File? userDp;
//   String? profilePicture;
//   String? invoiceLink;
//   String? itemLink;
//   bool edit = false;
//   String? id;

//   // Controllers
//   TextEditingController locationTEC = TextEditingController();

//   // Setters
//   setEdit(bool val) {
//     edit = val;
//     notifyListeners();
//   }

//   setPost(PostModel post) {
//     if (post != null) {
//       description = post.description;
//       itemLink = post.itemImage;
//       invoiceLink = post.invoiceImage;
//       edit = true;
//       notifyListeners();
//     } else {
//       edit = false;
//       notifyListeners();
//     }
//   }

//   setUsername(String val) {
//     print('SetName $val');
//     username = val;
//     notifyListeners();
//   }

//   setDescription(String val) {
//     print('SetDescription $val');
//     description = val;
//     notifyListeners();
//   }

//   // Functions
//   pickImage(
//       {bool camera = false,
//       BuildContext? context,
//       bool isInvoice = false}) async {
//     loading = true;
//     notifyListeners();
//     try {
//       if (isInvoice) {
//         PickedFile? pickedFile = await pickerInvoice.getImage(
//           source: camera ? ImageSource.camera : ImageSource.gallery,
//         );
//         CroppedFile? croppedFile = await ImageCropper().cropImage(
//           sourcePath: pickedFile!.path,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ],
//           uiSettings: [
//             AndroidUiSettings(
//               toolbarTitle: 'Crop Image',
//               toolbarColor: Constants.lightAccent,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false,
//             ),
//             IOSUiSettings(
//               minimumAspectRatio: 1.0,
//             ),
//           ],
//         );
//         invoiceImg = File(croppedFile!.path);
//       } else {
//         PickedFile? pickedFile = await pickerItem.getImage(
//           source: camera ? ImageSource.camera : ImageSource.gallery,
//         );
//         CroppedFile? croppedFile = await ImageCropper().cropImage(
//           sourcePath: pickedFile!.path,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ],
//           uiSettings: [
//             AndroidUiSettings(
//               toolbarTitle: 'Crop Image',
//               toolbarColor: Constants.lightAccent,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false,
//             ),
//             IOSUiSettings(
//               minimumAspectRatio: 1.0,
//             ),
//           ],
//         );
//         itemImg = File(croppedFile!.path);
//       }

//       loading = false;
//       notifyListeners();
//     } catch (e) {
//       loading = false;
//       notifyListeners();
//       showInSnackBar('Cancelled', context);
//     }
//   }

//   uploadPosts(BuildContext context) async {
//     try {
//       loading = true;
//       notifyListeners();
//       if (itemImg == null || invoiceImg == null) {
//         throw Exception("Both item and invoice images are required.");
//       }
//       await postService.uploadPost(invoiceImg!, itemImg!, description!);
//       loading = false;
//       resetPost();
//       notifyListeners();
//     } catch (e) {
//       print(e);
//       loading = false;
//       resetPost();
//       showInSnackBar('Upload error!', context);
//       notifyListeners();
//     }
//   }

//   uploadProfilePicture(BuildContext context) async {
//     if (userDp == null) {
//       showInSnackBar('Please select an image', context);
//     } else {
//       try {
//         loading = true;
//         notifyListeners();
//         await postService.uploadProfilePicture(
//             userDp!, firebaseAuth.currentUser!);
//         loading = false;
//         Navigator.of(context)
//             .pushReplacement(CupertinoPageRoute(builder: (_) => TabScreen()));
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         loading = false;
//         showInSnackBar('Upload error!', context);
//         notifyListeners();
//       }
//     }
//   }

//   Future<String?> recognizeItem() async {
//     var file = itemImg; // assuming you named it itemImg
//     if (file == null) return null;

//     // TODO: Add your logic to send this image to your server for recognition
//     // and get back the recognizedImageUrl.
//     // Use this URL to save to Firestore.

//     return null; // Return null if nothing is recognized. Update this as per your actual implementation.
//   }

//   resetPost() {
//     itemImg = null;
//     invoiceImg = null;
//     description = null;
//     edit = false;
//     notifyListeners();
//   }

//   void showInSnackBar(String value, BuildContext? context) {
//     if (context != null) {
//       ScaffoldMessenger.of(context).removeCurrentSnackBar();
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(value)));
//     }
//   }
// }



// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:social_media_app/models/post.dart';
// import 'package:social_media_app/screens/mainscreen.dart';
// import 'package:social_media_app/services/post_service.dart';
// import 'package:social_media_app/services/user_service.dart';
// import 'package:social_media_app/utils/constants.dart';
// import 'package:social_media_app/utils/firebase.dart';

// class PostsViewModel extends ChangeNotifier {
//   //Services
//   UserService userService = UserService();
//   PostService postService = PostService();

//   //Keys
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   //Variables
//   bool loading = false;
//   String? recognizedImageUrl;
//   String? username;
//   File?
//       itemImg; // Assuming this will be uploaded and then link will be stored in itemImage
//   File? invoiceImg;
//   final picker = ImagePicker();
//   Placemark? placemark;
//   String? bio;
//   String? description;
//   String? email;
//   String? ownerId;
//   String? userId;
//   String? type;
//   File? userDp;
//   String? itemLink;
//   String? invoiceLink;
//   bool edit = false;
//   String? id;

//   //controllers
//   TextEditingController locationTEC = TextEditingController();

//   //Setters
//   setEdit(bool val) {
//     edit = val;
//     notifyListeners();
//   }

//   setPost(PostModel post) {
//     if (post != null) {
//       description = post.description;
//       itemLink = post.itemImage;
//       invoiceLink = post.invoiceImage;
//       edit = true;
//       edit = false;
//       notifyListeners();
//     } else {
//       edit = false;
//       notifyListeners();
//     }
//   }

//   setUsername(String val) {
//     print('SetName $val');
//     username = val;
//     notifyListeners();
//   }

//   setDescription(String val) {
//     print('SetDescription $val');
//     description = val;
//     notifyListeners();
//   }

//   //Functions
//   pickImage({bool camera = false, BuildContext? context}) async {
//     loading = true;
//     notifyListeners();
//     try {
//       PickedFile? pickedFile = await picker.getImage(
//         source: camera ? ImageSource.camera : ImageSource.gallery,
//       );
//       CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile!.path,
//         aspectRatioPresets: [
//           CropAspectRatioPreset.square,
//           CropAspectRatioPreset.ratio3x2,
//           CropAspectRatioPreset.original,
//           CropAspectRatioPreset.ratio4x3,
//           CropAspectRatioPreset.ratio16x9
//         ],
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: Constants.lightAccent,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//           ),
//           IOSUiSettings(
//             minimumAspectRatio: 1.0,
//           ),
//         ],
//       );
//       invoiceImg = File(croppedFile!.path);
//       loading = false;
//       notifyListeners();
//     } catch (e) {
//       loading = false;
//       notifyListeners();
//       showInSnackBar('Cancelled', context);
//     }
//   }

//   uploadPosts(BuildContext context) async {
//     try {
//       loading = true;
//       notifyListeners();
//       await postService.uploadPost(invoiceImg!, itemImg!, description!);
//       loading = false;
//       resetPost();
//       notifyListeners();
//     } catch (e) {
//       print(e);
//       loading = false;
//       resetPost();
//       showInSnackBar('Uploaded successfully!', context);
//       notifyListeners();
//     }
//   }

//   uploadProfilePicture(BuildContext context) async {
//     if (mediaUrl == null) {
//       showInSnackBar('Please select an image', context);
//     } else {
//       try {
//         loading = true;
//         notifyListeners();
//         await postService.uploadProfilePicture(
//             mediaUrl!, firebaseAuth.currentUser!);
//         loading = false;
//         Navigator.of(context)
//             .pushReplacement(CupertinoPageRoute(builder: (_) => TabScreen()));
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         loading = false;
//         showInSnackBar('Uploaded successfully!', context);
//         notifyListeners();
//       }
//     }
//   }

//   Future<String?> recognizeItem() async {
//     var file = itemImg; // assuming you named it itemImg
//     if (file == null) return null;

//     // TODO: Add your logic to send this image to your server for recognition
//     // and get back the recognizedImageUrl.
//     // Use this URL to save to Firestore.

//     return recognizedImageUrl; // Return the recognized URL
//   }

//   resetPost() {
//     mediaUrl = null;
//     description = null;
//     location = null;
//     edit = false;
//     notifyListeners();
//   }

//   void showInSnackBar(String value, context) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
//   }
// }
// //   uploadPost(BuildContext context) async {
// //     print("Item Image: ${itemImg?.path}"); // Debug log
// //     print("Invoice Image: ${invoiceImg?.path}"); // Debug log

// //     if (itemImg == null) {
// //       showInSnackBar('Required values missing!', context);
// //       return;
// //     } else if (invoiceImg == null) {
// //       showInSnackBar('Required values missing!', context);
// //       return;
// //     }
// //     try {
// //       loading = true;
// //       notifyListeners(); // Fetch the username before uploading
// //       await postService.uploadPost(
// //         invoiceImg!,
// //         itemImg!,
// //       );
// //       loading = false;
// //       resetPost();
// //       notifyListeners();
// //     } catch (e) {
// //       loading = false;
// //       resetPost();
// //       showInSnackBar('Upload error!', context);
// //       notifyListeners();
// //     }
// //   }

// // }