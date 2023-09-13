import 'package:flutter/material.dart';

import '../view_models/status/status_view_model.dart';

class GalleryUploadButton extends StatelessWidget {
  final StatusViewModel viewModel;

  GalleryUploadButton(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.upload_file, color: Colors.white),
      onPressed: () {
        viewModel.pickImage(camera: false, context: context);
      },
    );
  }
}
