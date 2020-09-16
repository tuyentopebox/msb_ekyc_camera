part of '../../msb_ekyc_camera.dart';

///
/// FaceDetectController
class FaceDetectController extends ValueNotifier<FaceDetectControllerValue> {
  ///
  /// Event
  Function(dynamic event) _faceDetectEventHandler;
  Function() _faceDetectViewCreated;

  BuildContext _context;
  StreamSubscription<dynamic> _eventSubscription;

  String _viewId;

  ///
  /// Constructor.
  FaceDetectController(BuildContext context, {
    faceDetectEventHandler(dynamic event),
    faceDetectViewCreated(),
  }) : super(const FaceDetectControllerValue.uninitialized()) {
    _context = context;
    _faceDetectEventHandler = faceDetectEventHandler??eventHandler;
    _faceDetectViewCreated = faceDetectViewCreated??viewCreated;
  }

  Function() get faceDetectViewCreated => _faceDetectViewCreated;

  bool get isStartCamera => MSBEkycCameraFaceDetectPlatform.instance.isStartCamera;
  bool get isStartCameraPreview =>
      MSBEkycCameraFaceDetectPlatform.instance.isStartCameraPreview;

  bool get isOpenFlash => MSBEkycCameraFaceDetectPlatform.instance.isOpenFlash;

  eventHandler (dynamic event) {
    final Map<dynamic, dynamic> map = event;
    print('face_detect_view_event_channel event receive: ' + event.toString());
    switch (map['eventType']) {
      case 'initSuccess':
        value = value.copyWith(
            gestures: map["eventData"] != null ?
            List<Gesture>.from(
                json.decode(map["eventData"]).map((x) =>
                    Gesture.fromJson(x))) : null,
            currentGestureIndex: map["eventData"] != null ? 0 : -1
        );
        TargetPlatform platform = Theme
            .of(_context)
            .platform;
        if (TargetPlatform.iOS == platform) {
          Future.delayed(Duration(seconds: 2), () {
            startCamera();
            startCameraPreview();
          });
        } else {
          startCamera();
          startCameraPreview();
        }
        break;
    }
  }

  viewCreated () {
    print ('Dart FaceDetectController: View created!!!');
    initCamera();
  }

  dispose() {
    super.dispose();
    _eventSubscription.cancel();
  }

  ///
  /// Init camera without open face detect.
  initCamera() async {
    _viewId = await MSBEkycCameraFaceDetectPlatform.instance.initCamera();
    print('Dart Face Detect Controller InitCamera respsone: ${_viewId}');
    if (_viewId.isNotEmpty) {
      _eventSubscription =
          EventChannel('face_detect_view_event_channel_$_viewId')
              .receiveBroadcastStream()
              .listen(_faceDetectEventHandler);
    }
  }

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

/// The state of a [FaceDetectController].
class FaceDetectControllerValue {
  const FaceDetectControllerValue({
    this.isInitialized,
    this.errorDescription,
    this.previewSize,
    this.gestures,
    this.currentGestureIndex,
  });

  const FaceDetectControllerValue.uninitialized()
      : this(
    isInitialized: false,
    gestures: null,
    currentGestureIndex: -1,
  );

  /// True after [FaceDetectController.initialize] has completed successfully.
  final bool isInitialized;

  final String errorDescription;

  /// The size of the preview in pixels.
  ///
  /// Is `null` until  [isInitialized] is `true`.
  final Size previewSize;

  /// Convenience getter for `previewSize.height / previewSize.width`.
  ///
  /// Can only be called when [initialize] is done.
  double get aspectRatio => previewSize.height / previewSize.width;

  bool get hasError => errorDescription != null;

  final List <Gesture> gestures;
  final int currentGestureIndex;

  FaceDetectControllerValue copyWith({
    bool isInitialized,
    String errorDescription,
    Size previewSize,
    List <Gesture> gestures,
    int currentGestureIndex,
  }) {
    return FaceDetectControllerValue(
      isInitialized: isInitialized ?? this.isInitialized,
      errorDescription: errorDescription,
      previewSize: previewSize ?? this.previewSize,
      gestures: gestures ?? this.gestures,
      currentGestureIndex: currentGestureIndex ?? this.currentGestureIndex,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'isInitialized: $isInitialized, '
        'errorDescription: $errorDescription, '
        'previewSize: $previewSize, '
        'gestures: $gestures,'
        'currentGestureIndex: $currentGestureIndex)';
  }
}

class Gesture {
  Gesture({
    this.endTime,
    this.name,
    this.startTime,
    this.status,
    this.time,
  });

  int endTime;
  String name;
  int startTime;
  bool status;
  int time;

  Gesture copyWith({
    int endTime,
    String name,
    int startTime,
    bool status,
    int time,
  }) =>
      Gesture(
        endTime: endTime ?? this.endTime,
        name: name ?? this.name,
        startTime: startTime ?? this.startTime,
        status: status ?? this.status,
        time: time ?? this.time,
      );

  factory Gesture.fromRawJson(String str) => Gesture.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Gesture.fromJson(Map<String, dynamic> json) => Gesture(
    endTime: json["end_time"] == null ? null : json["end_time"],
    name: json["name"] == null ? null : json["name"],
    startTime: json["start_time"] == null ? null : json["start_time"],
    status: json["status"] == null ? null : json["status"],
    time: json["time"] == null ? null : json["time"],
  );

  Map<String, dynamic> toJson() => {
    "end_time": endTime == null ? null : endTime,
    "name": name == null ? null : name,
    "start_time": startTime == null ? null : startTime,
    "status": status == null ? null : status,
    "time": time == null ? null : time,
  };
}