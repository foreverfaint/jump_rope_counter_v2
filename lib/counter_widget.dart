import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'camera_preview_widget.dart';
import 'bounding_box.dart';
import 'recognition_found_notifier.dart';

class CounterWidget extends StatefulWidget {
  final _log = Logger('CounterWidget');

  final CameraDescription camera;

  final RecognitionFoundNotifier foundNotifier = RecognitionFoundNotifier();

  CounterWidget(this.camera) : super(key: GlobalKey());

  @override
  _CounterWidgetState createState() {
    _log.log(Level.INFO, '${this.key}.createState');
    return new _CounterWidgetState();
  }
}

class _CounterWidgetState extends State<CounterWidget> {
  final _log = Logger('_CounterWidgetState');

  var _personRecognitionResult;

  var _cameraPreviewWidget;

  @override
  initState() {
    _log.log(Level.INFO, '${this.widget.key}.initState');
    super.initState();
    _cameraPreviewWidget = CameraPreviewWidget(widget.camera, widget.foundNotifier);
    widget.foundNotifier.addListener(this._handleRecognitionFound);
  }

  @override
  void dispose() {
    _log.log(Level.INFO, '${this.widget.key}.dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _log.log(Level.INFO, '${this.widget.key}.build');

    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: _personRecognitionResult != null ? [
          _cameraPreviewWidget,
          CustomPaint(painter: BoundingBox(_personRecognitionResult), size: screen)
        ] : [
          _cameraPreviewWidget,
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
}
