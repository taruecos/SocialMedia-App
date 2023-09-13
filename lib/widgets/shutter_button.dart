import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../view_models/status/status_view_model.dart';

class ShutterButton extends StatelessWidget {
  final StatusViewModel viewModel;

  ShutterButton(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        viewModel.pickImage(camera: true, context: context);
      },
      backgroundColor: Colors.white,
      child: Icon(Icons.camera_alt, color: Colors.black),
    );
  }
}
