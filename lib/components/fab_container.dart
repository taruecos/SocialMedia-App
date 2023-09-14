import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/view_models/status/status_view_model.dart';
import '../posts/create_post.dart';
import '../widgets/camera_widget.dart';
import '../widgets/gallery_upload_button.dart';
import '../widgets/shutter_button.dart';
import '../widgets/status_indicator.dart';

class FabContainer extends StatelessWidget {
  // final Widget? page;
  // final IconData icon;
  // final bool mini;

  // FabContainer({this.page, required this.icon, this.mini = false});

  // @override
  // Widget build(BuildContext context) {
  //   StatusViewModel viewModel = Provider.of<StatusViewModel>(context);
  //   return OpenContainer(
  //     transitionType: ContainerTransitionType.fade,
  //     openBuilder: (BuildContext context, VoidCallback _) {
  //       return page!;
  //     },
  //     closedElevation: 4.0,
  //     closedShape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(56 / 2),
  //       ),
  //     ),
  //     closedColor: Theme.of(context).scaffoldBackgroundColor,
  //     closedBuilder: (BuildContext context, VoidCallback openContainer) {
  //       return FloatingActionButton(
  //         backgroundColor: Theme.of(context).primaryColor,
  //         child: Icon(icon, color: Color.fromARGB(255, 0, 0, 0)),
  //         onPressed: () {
  //           chooseUpload(context, viewModel);
  //         },
  //         mini: mini,
  //       );
  //     },
  //   );
  // }

  // chooseUpload(BuildContext context, StatusViewModel viewModel) {
  //   return showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 1,
  //         child: Stack(
  //           children: [
  //             // Camera now occupies the full screen
  //             Positioned.fill(child: CameraWidget()),

  //             // Just to see if this widget works, use a simple button
  //             Positioned(
  //               bottom: 10,
  //               child: FloatingActionButton(
  //                 onPressed: () {
  //                   // Implement functionality here
  //                 },
  //                 child: Icon(Icons.camera),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  final Widget? page;
  final IconData icon;
  final bool mini;

  FabContainer({this.page, required this.icon, this.mini = false});

  @override
  Widget build(BuildContext context) {
    StatusViewModel viewModel = Provider.of<StatusViewModel>(context);
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return page!;
      },
      closedElevation: 4.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(56 / 2),
        ),
      ),
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            icon,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () {
            chooseUpload(context, viewModel);
          },
          mini: mini,
        );
      },
    );
  }

  chooseUpload(BuildContext context, StatusViewModel viewModel) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Stack(
            children: [
              // Camera now occupies the full screen
              Positioned.fill(child: CameraWidget()),

              // Dimmed area at the top of the clear rectangle
              Positioned.fill(
                top: 0,
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.82,
                child: Container(color: Colors.white.withOpacity(0.5)),
              ),

// Dimmed area at the bottom of the clear rectangle
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.78,
                left: 0,
                right: 0,
                child: Container(color: Colors.white.withOpacity(0.5)),
              ),

// Dimmed area on the left side of the clear rectangle
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.18,
                left: 0,
                right: MediaQuery.of(context).size.width * 0.9,
                bottom: MediaQuery.of(context).size.height * 0.22,
                child: Container(color: Colors.white.withOpacity(0.5)),
              ),

// Dimmed area on the right side of the clear rectangle
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.18,
                left: MediaQuery.of(context).size.width * 0.9,
                bottom: MediaQuery.of(context).size.height * 0.22,
                child: Container(color: Colors.white.withOpacity(0.5)),
              ),
              // Clear frame remains the same
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.18, // Adjust the top to center it vertically more
                left: MediaQuery.of(context).size.width *
                    0.1, // Centering it horizontally
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 40% of screen width for a more rectangular look
                  height: MediaQuery.of(context).size.height *
                      0.6, // 60% of screen height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),

              // Title and buttons remain the same
              Positioned(
                top: 60.0, // Increased top padding for better visibility
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "Take a picture of the item",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),

              // Buttons and Status Indicators
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GalleryUploadButton(viewModel),
                            ShutterButton(viewModel),
                            SizedBox(
                                width:
                                    50) // You can adjust this padding as needed
                          ],
                        ),
                        SizedBox(
                            height: 10.0), // Spacing between buttons and status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatusIndicator(title: "Step 1", isActive: true),
                            StatusIndicator(
                                title: "Step 2",
                                isActive:
                                    false), // isActive as true for demonstration purposes
                            StatusIndicator(title: "Step 3", isActive: false)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
