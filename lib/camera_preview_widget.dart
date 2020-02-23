import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

import 'recognition_found_notifier.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;

  final RecognitionFoundNotifier notifier;

  CameraPreviewWidget(this.camera, this.notifier);

  @override
  _CameraPreviewWidgetState createState() => new _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  CameraController _controller;

  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    _controller = new CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _controller.initialize().then((_) {
      if (!this.mounted) {
        /// It is an error to call [setState] unless [mounted] is true.
        return;
      }

      setState(() {});

      _controller.startImageStream((CameraImage img) {
        if (isDetecting) {
          return;
        }

        isDetecting = true;
        int startTime = new DateTime.now().millisecondsSinceEpoch;

        Tflite.detectObjectOnFrame(
          bytesList: img.planes.map((plane) => plane.bytes).toList(),
          imageHeight: img.height,
          imageWidth: img.width,
          numResultsPerClass: 1,
        ).then((recognitions) {
          int endTime = new DateTime.now().millisecondsSinceEpoch;
          widget.notifier.value = RecognitionFound(recognitions, endTime - startTime);
          isDetecting = false;
        });
      });
    });
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller?.dispose();
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    }

    var screenSize = MediaQuery.of(context).size;
    var screenH = math.max(screenSize.height, screenSize.width);
    var screenW = math.min(screenSize.height, screenSize.width);
    var screenRatio = screenH / screenW;

    var previewSize = _controller.value.previewSize;
    var previewH = math.max(previewSize.height, previewSize.width);
    var previewW = math.min(previewSize.height, previewSize.width);
    var previewRatio = previewH / previewW;

    if (screenRatio > previewRatio) {
      return OverflowBox(
        maxHeight: screenH, maxWidth: screenH / previewRatio,
        child: CameraPreview(_controller),
      );
    } else {
      return OverflowBox(
        maxHeight: screenW * previewRatio, maxWidth: screenW,
        child: CameraPreview(_controller),
      );
    }
  }
}