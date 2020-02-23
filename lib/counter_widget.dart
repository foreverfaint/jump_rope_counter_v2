import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

import 'camera_preview_widget.dart';
import 'bounding_box.dart';
import 'recognition_found_notifier.dart';

class CounterWidget extends StatefulWidget {
  final CameraDescription camera;

  final RecognitionFoundNotifier foundNotifier = RecognitionFoundNotifier();

  CounterWidget(this.camera);

  @override
  _CounterWidgetState createState() => new _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  var _personRecognitionResult;

  @override
  initState() {
    print("_CounterWidgetState -> initState");

    super.initState();

    widget.foundNotifier.addListener(this._handleRecognitionFound);

    _loadModels();
  }

  @override
  void dispose() {
    super.dispose();
    print("_CounterWidgetState -> dispose");
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: _personRecognitionResult != null ? [
          CameraPreviewWidget(widget.camera, widget.foundNotifier),
          CustomPaint(painter: BoundingBox(_personRecognitionResult), size: screen)
        ] : [
          CameraPreviewWidget(widget.camera, widget.foundNotifier),
        ],
      ),
    );
  }

  void _handleRecognitionFound() {
    if (widget.foundNotifier.value == null) {
      if(mounted) {
        setState(() {
          _personRecognitionResult = null;
        });
      }
      return;
    }

    final recognitions = widget.foundNotifier.value.found;
    if (recognitions != null && recognitions.isNotEmpty) {
      try {
        // If there isn't a matched result, then exception is raised.
        var filteredRecognition = recognitions.firstWhere((e) => e['detectedClass'] == 'person' && e['confidenceInClass'] > 0.6);
        filteredRecognition["cost"] = widget.foundNotifier.value.cost;

        if (mounted) {
          setState(() {
            _personRecognitionResult = filteredRecognition;
          });
        }
      } catch (e) {
        if(mounted) {
          setState(() {
            _personRecognitionResult = null;
          });
        }
      }
    }
  }

  _loadModels() async {
    Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt"
    );
  }
}
