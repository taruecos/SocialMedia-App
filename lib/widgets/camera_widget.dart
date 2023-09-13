import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  final ValueChanged<CameraController?>? onControllerInitialized;

  CameraWidget({this.onControllerInitialized});
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  _initializeCamera() async {
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        return;
      }
      cameras = await availableCameras();
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);
      _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        if (widget.onControllerInitialized != null) {
          widget.onControllerInitialized!(_cameraController);
        }
      });
    } catch (e) {
      print('Error initializing the camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController!); // Remove Expanded
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
