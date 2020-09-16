import 'package:msb_ekyc_camera/msb_ekyc_camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

String _label;
Function(dynamic event) _eventHandler;

///
/// AppMSBEkycFaceDetectWidget
class AppMSBEkycFaceDetectWidget extends StatefulWidget {
  ///
  ///
  AppMSBEkycFaceDetectWidget.defaultStyle({
    Function(dynamic event) eventHandler,
    String label = 'MSB Ekyc Camera: Face Detect',
  }) {
    _eventHandler = eventHandler ?? (String result) {};
    _label = label;
  }

  @override
  _AppMSBEkycCameraState createState() => _AppMSBEkycCameraState();
}

class _AppMSBEkycCameraState extends State<AppMSBEkycFaceDetectWidget> {
  @override
  Widget build(BuildContext context) {
    return _CameraPermissionWidget();
  }
}

class _CameraPermissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CameraPermissionWidgetState();
  }
}

class _CameraPermissionWidgetState extends State<_CameraPermissionWidget> {
  bool _isGranted = false;

  String _inputValue = "";

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  void _requestPermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _isGranted
              ? _MSBEkycCameraFaceDetectWidget()
              : Center(
                  child: OutlineButton(
                    onPressed: () {
                      _requestPermission();
                    },
                    child: Text("Request permission"),
                  ),
                ),
        ),
      ],
    );
  }
}

///FaceDetectWidget
class _MSBEkycCameraFaceDetectWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MSBEkycCameraFaceDetectWidgetState();
  }
}

class _MSBEkycCameraFaceDetectWidgetState extends State<_MSBEkycCameraFaceDetectWidget> {
  FaceDetectController _faceDetectController;

  @override
  void initState() {
    super.initState();

    _faceDetectController = FaceDetectController(context);
  }

  @override
  void dispose() {
    super.dispose();

    _faceDetectController.stopCameraPreview();
    _faceDetectController.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _getFaceDetectWidgetByPlatform(),
        )
      ],
    );
  }

  Widget _getFaceDetectWidgetByPlatform() {
    return FaceDetectWidget(
      faceDetectController: _faceDetectController,
    );
  }
}
