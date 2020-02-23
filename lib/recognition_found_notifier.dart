import 'package:flutter/material.dart';

class RecognitionFound {
  final List<dynamic> found;

  final num cost;

  RecognitionFound(this.found, this.cost);
}

class RecognitionFoundNotifier extends ValueNotifier<RecognitionFound> {
  RecognitionFoundNotifier() : super(null);
}