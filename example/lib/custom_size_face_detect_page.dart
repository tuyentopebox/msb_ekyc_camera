import 'package:msb_ekyc_camera_example/app_msb_ekyc_camera_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// CustomSizeFaceDetectPage
class CustomSizeFaceDetectPage extends StatefulWidget {
  @override
  _CustomSizeFaceDetectPageState createState() => _CustomSizeFaceDetectPageState();
}

class _CustomSizeFaceDetectPageState extends State<CustomSizeFaceDetectPage> {
  String _code = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_code),
            ],
          ),
          Expanded(
            child: AppMSBEkycFaceDetectWidget.defaultStyle(
              eventHandler: (dynamic event) {

              },
            ),
          ),
        ],
      ),
    );
  }
}
