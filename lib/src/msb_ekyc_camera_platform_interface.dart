import 'package:flutter/services.dart';

///
/// Channel
const MethodChannel _methodChannelFaceDetect =
    MethodChannel("face_detect_view_method_channel");

const EventChannel _eventChannelFaceDetect =
      EventChannel("face_detect_view_event_channel");

/// View id of face detect widget
const String _viewIdOfFaceDetect= "face_detect_view";


///MSBEkycCameraPlatform
///
abstract class MSBEkycCameraPlatform {
  ///
  /// MethodChannel
  static MethodChannel get methodChannelFaceDetect => _methodChannelFaceDetect;
  static EventChannel get eventChannelFaceDetect => _eventChannelFaceDetect;

  ///
  /// ViewId of face detect widget
  static String get viewIdOfFaceDetect => _viewIdOfFaceDetect;
}
