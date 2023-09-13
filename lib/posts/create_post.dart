import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/view_models/auth/posts_view_model.dart';
import 'package:social_media_app/widgets/indicators.dart';

import '../components/custom_image.dart';
import '../models/user.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  int currentStep = 1;

  String currentUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        await viewModel.resetPost();
        return true;
      },
      child: LoadingOverlay(
        progressIndicator: circularProgress(context),
        isLoading: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Ionicons.close_outline),
              onPressed: () {
                viewModel.resetPost();
                Navigator.pop(context);
              },
            ),
            title: Text('LA PENDERIE'.toUpperCase()),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () async {
                  await viewModel.uploadPosts(context);
                  Navigator.pop(context);
                  viewModel.resetPost();
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Post'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            children: [
              SizedBox(height: 15.0),
              StreamBuilder(
                stream: usersRef.doc(currentUserId()).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>,
                    );
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user.photoUrl!),
                      ),
                      title: Text(
                        user.username!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        user.email!,
                      ),
                    );
                  }
                  return Container();
                },
              ),
              _buildSteps(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSteps(PostsViewModel viewModel) {
    List<Widget> steps = [_buildStep1(viewModel)];

    if (currentStep > 1) {
      steps.add(_buildStep2(viewModel));
    }

    // Add this if you want to implement a third step in the future.
    // if (currentStep > 2) {
    //   steps.add(_buildStep3(viewModel));
    // }

    return Column(children: steps);
  }

  // Updated _buildStep1
  Widget _buildStep1(PostsViewModel viewModel) {
    return InkWell(
        onTap: () async {
          try {
            await viewModel.pickImage(context: context, isInvoice: true);

            if (viewModel.invoiceImg != null) {
              viewModel.invoiceLink = null; // Reset previous link
              currentStep = 2; // Move to the next step
            }
          } catch (e) {
            print('Error picking invoice image: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error picking invoice image')),
            );
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: viewModel.invoiceLink != null
              ? CustomImage(
                  imageUrl: viewModel.invoiceLink,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - 30,
                  fit: BoxFit.cover,
                )
              : viewModel.invoiceImg == null
                  ? Center(
                      child: Text(
                        'Upload INVOICE',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  : Image.file(
                      viewModel.invoiceImg!,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width - 30,
                      fit: BoxFit.cover,
                    ),
        ));
  }

// Updated _buildStep2
  Widget _buildStep2(PostsViewModel viewModel) {
    return InkWell(
        onTap: () async {
          try {
            await showImageChoices(context, viewModel, isInvoice: false);
          } catch (e) {
            print('Error showing image choices: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error showing image choices')),
            );
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: viewModel.itemLink != null
              ? CustomImage(
                  imageUrl: viewModel.itemLink,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - 30,
                  fit: BoxFit.cover,
                )
              : viewModel.itemImg == null
                  ? Center(
                      child: Text(
                        'Upload ITEM',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  : Image.file(
                      viewModel.itemImg!,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width - 30,
                      fit: BoxFit.cover,
                    ),
        ));
  }

// Updated showImageChoices
  showImageChoices(BuildContext context, PostsViewModel viewModel,
      {bool isInvoice = false}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select Image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Ionicons.camera_outline),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(
                      camera: true,
                      isInvoice: isInvoice); // Pass isInvoice parameter
                },
              ),
              ListTile(
                leading: Icon(Ionicons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(
                      isInvoice: isInvoice); // Pass isInvoice parameter
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:provider/provider.dart';

// import '../view_models/auth/posts_view_model.dart';
// import '../widgets/indicators.dart';

// class CreatePost extends StatefulWidget {
//   @override
//   _CreatePostState createState() => _CreatePostState();
// }

// class _CreatePostState extends State<CreatePost> {
//   final picker = ImagePicker();
//   int currentStep = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<PostsViewModel>(
//         builder: (context, viewModel, child) {
//           return WillPopScope(
//             onWillPop: () async {
//               await viewModel.resetPost();
//               return true;
//             },
//             child: LoadingOverlay(
//               progressIndicator: circularProgress(context),
//               isLoading: viewModel.loading,
//               child: Scaffold(
//                 key: viewModel.scaffoldKey,
//                 appBar: AppBar(
//                   leading: IconButton(
//                     icon: Icon(Ionicons.close_outline),
//                     onPressed: () {
//                       viewModel.resetPost();
//                       Navigator.pop(context);
//                     },
//                   ),
//                   title: Text('LA PENDERIE'.toUpperCase()),
//                   centerTitle: true,
//                   actions: [
//                     GestureDetector(
//                       onTap: () async {
//                         await viewModel.uploadPost(context);
//                         Navigator.pop(context);
//                         viewModel.resetPost();
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Text(
//                           'Post'.toUpperCase(),
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15.0,
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 body: SingleChildScrollView(
//                   child: _buildSteps(viewModel),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSteps(PostsViewModel viewModel) {
//     return Column(
//       children: [
//         _buildStep1(viewModel),
//         _buildStep2(viewModel),
//         // _buildStep3(viewModel),
//       ],
//     );
//   }

//   Widget _buildStep1(PostsViewModel viewModel) {
//     return Column(
//       children: [
//         _buildAccordion(
//           title: 'Upload Invoice Image',
//           onPressed: () async {
//             await viewModel.pickImage(context: context, isInvoice: true);
//             if (viewModel.invoiceImg != null) {
//               setState(() {
//                 var currentStep = 2;
//               });
//             }
//           },
//           image: viewModel.invoiceImg,
//           viewModel: viewModel,
//           camera: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildStep2(PostsViewModel viewModel) {
//     return Column(
//       children: [
//         _buildAccordion(
//           title: 'Upload Item Image',
//           onPressed: () async {
//             await viewModel.pickImage(context: context);
//           },
//           image: viewModel.itemImg,
//           viewModel: viewModel,
//           camera: true,
//         ),
//         ElevatedButton(
//           onPressed: () async {},
//           child: Text("Recognize my item"),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             await viewModel.uploadPost(context);
//             if (viewModel.itemImg != null) {
//               setState(() {
//                 currentStep = 3;
//               });
//             }
//           },
//           child: Text("Upload my item"),
//         ),
//       ],
//     );
//   }

//   Widget _buildStep3(PostsViewModel viewModel) {
//     return Column(
//       children: [
//         DropdownButton<String>(
//           items: <String>['Brand1', 'Brand2', 'Brand3'].map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           onChanged: (_) {},
//           hint: Text("Select Brand"),
//         ),
//         DropdownButton<String>(
//           items: <String>['Clothing1', 'Clothing2', 'Clothing3']
//               .map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           onChanged: (_) {},
//           hint: Text("Select Clothing Type"),
//         ),
//       ],
//     );
//   }

//   Widget _buildAccordion({
//     required String title,
//     required VoidCallback onPressed,
//     required File? image,
//     required PostsViewModel viewModel,
//     required bool camera,
//   }) {
//     return ExpansionTile(
//       title: Text(title),
//       children: <Widget>[
//         ListTile(
//           title: Text('Capture Image'),
//           leading: Icon(Icons.camera_alt),
//           onTap: onPressed,
//         ),
//         ListTile(
//           title: Text('Select from Gallery'),
//           leading: Icon(Icons.image),
//           onTap: onPressed,
//         ),
//         if (image != null)
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: 300,
//             child: Image.file(
//               image,
//               fit: BoxFit.cover,
//             ),
//           ),
//       ],
//     );
//   }
// }