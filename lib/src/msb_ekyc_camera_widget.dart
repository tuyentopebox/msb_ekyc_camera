part of '../msb_ekyc_camera.dart';

///
/// FaceDetectWidget
///
/// Supported android and ios platform face detect
// ignore: must_be_immutable
class FaceDetectWidget extends StatefulWidget {
  ///
  /// Controller.
  FaceDetectController _faceDetectController;

  ///
  /// UnsupportedDescription
  String _unsupportedDescription;

  ///
  /// Constructor.
  FaceDetectWidget({
    @required FaceDetectController faceDetectController,
    String unsupportedDescription,
  }) {
    _faceDetectController = faceDetectController;
    _unsupportedDescription = unsupportedDescription;
  }

  @override
  State<StatefulWidget> createState() {
    return _FaceDetectWidgetState();
  }
}

///
/// _FaceDetectWidgetState
class _FaceDetectWidgetState
    extends State<FaceDetectWidget> {
    StreamSubscription<dynamic> _eventSubscription;

  @override
  void initState() {
    super.initState();
    //Create
    MSBEkycCameraFaceDetectPlatform.instance.addListener(_widgetCreatedListener);
    MSBEkycCameraFaceDetectPlatform.instance.unsupportedPlatformDescription =
        widget._unsupportedDescription;
  }

  ///
  /// CreatedListener.
  _widgetCreatedListener() {
    if (widget._faceDetectController != null) {
      if (widget._faceDetectController._faceDetectViewCreated != null) {
        widget._faceDetectController._faceDetectViewCreated();
      }
    }
    _eventSubscription =
        EventChannel('face_detect_view_event_channel')
            .receiveBroadcastStream()
            .listen(widget._faceDetectController._faceDetectEventHandler);
  }

  @override
  void dispose() {
    super.dispose();
    //Release
    MSBEkycCameraFaceDetectPlatform.instance.removeListener(_widgetCreatedListener);
    _eventSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MSBEkycCameraFaceDetectPlatform.instance.buildFaceDetectView(context);
  }
}

///
/// FaceDetectController
class FaceDetectController {
  ///
  /// Result
  Function(dynamic event) _faceDetectEventHandler;
  Function() _faceDetectViewCreated;

  ///
  /// Constructor.
  FaceDetectController({
    @required faceDetectEventHandler(dynamic event),
    faceDetectViewCreated(),
  }) {
    _faceDetectEventHandler = faceDetectEventHandler;
    _faceDetectViewCreated = faceDetectViewCreated;
  }

  Function() get faceDetectViewCreated => _faceDetectViewCreated;

  bool get isStartCamera => MSBEkycCameraFaceDetectPlatform.instance.isStartCamera;
  bool get isStartCameraPreview =>
      MSBEkycCameraFaceDetectPlatform.instance.isStartCameraPreview;

  bool get isOpenFlash => MSBEkycCameraFaceDetectPlatform.instance.isOpenFlash;

  ///
  /// Start camera without open face detect,this is just open camera.
  startCamera() {
    MSBEkycCameraFaceDetectPlatform.instance.startCamera();
  }

  ///
  /// Stop camera.
  stopCamera() async {
    MSBEkycCameraFaceDetectPlatform.instance.stopCamera();
  }

  ///
  /// Start camera preview with open Face detect,this is open code scanner.
  startCameraPreview() async {
    MSBEkycCameraFaceDetectPlatform.instance.startCameraPreview();
  }

  ///
  /// Stop camera preview.
  stopCameraPreview() async {
    MSBEkycCameraFaceDetectPlatform.instance.stopCameraPreview();
  }

  ///
  /// Open camera flash.
  openFlash() async {
    MSBEkycCameraFaceDetectPlatform.instance.openFlash();
  }

  ///
  /// Close camera flash.
  closeFlash() async {
    MSBEkycCameraFaceDetectPlatform.instance.closeFlash();
  }

  ///
  /// Toggle camera flash.
  toggleFlash() async {
    MSBEkycCameraFaceDetectPlatform.instance.toggleFlash();
  }
}
