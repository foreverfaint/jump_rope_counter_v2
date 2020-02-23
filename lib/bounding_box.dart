import 'package:flutter/material.dart';
import 'dart:math' as math;

class _RecognitionResult {
  final double x;

  final double y;

  final double w;

  final double h;

  final double score;

  final String label;

  final num cost;

  _RecognitionResult(dynamic result)
      : x = result['rect']['x'],
        y = result['rect']['y'],
        w = result['rect']['w'],
        h = result['rect']['h'],
        score = result['confidenceInClass'],
        label = result['detectedClass'],
        cost = result['cost'];
}

class _RecognitionBox {
  final _RecognitionResult result;

  final Size screenSize;

  _RecognitionBox(this.result, this.screenSize);

  Offset get topLeft => Offset(result.x * this.screenSize.width, result.y * this.screenSize.height);

  Offset get topRight => Offset((result.x + result.w) * this.screenSize.width, result.y * this.screenSize.height);

  Offset get bottomLeft => Offset(result.x * this.screenSize.width, (result.y + result.h) * this.screenSize.height);

  Offset get bottomRight => Offset((result.x + result.w) * this.screenSize.width, (result.y + result.h) * this.screenSize.height);

  Offset get center => (this.topLeft + this.bottomRight) * 0.5;

  double get width => result.w * this.screenSize.width;

  double get height => result.h * this.screenSize.height;
}

class BoundingBox extends CustomPainter {
  final _RecognitionResult result;

  static final _borderColor = Color.fromRGBO(32, 213, 253, 1.0);

  static final _borderPaint = Paint()
    ..color = _borderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  static final _fillPaint = Paint()
    ..color = _borderColor
    ..style = PaintingStyle.fill;

  static final _textPainter = TextPainter(
    textAlign: TextAlign.left,
    textDirection: TextDirection.rtl,
  );

  static final _textStyle = TextStyle(
      color: _borderColor,
      fontFamily: 'Times New Roman',
      fontSize: 10.0,
      fontWeight: FontWeight.bold
  );

  BoundingBox(dynamic recognition)
      : this.result = _RecognitionResult(recognition);

  @override
  void paint(Canvas canvas, Size size) {
    final box = _RecognitionBox(this.result, size);
    
    canvas.drawLine(box.topLeft, box.topLeft + Offset(10.0, 0.0), _borderPaint);
    canvas.drawLine(box.topLeft, box.topLeft + Offset(0.0, 10.0), _borderPaint);

    canvas.drawLine(box.topRight, box.topRight + Offset(-10.0, 0.0), _borderPaint);
    canvas.drawLine(box.topRight, box.topRight + Offset(0.0, 10.0), _borderPaint);

    canvas.drawLine(box.bottomLeft, box.bottomLeft + Offset(10.0, 0.0), _borderPaint);
    canvas.drawLine(box.bottomLeft, box.bottomLeft + Offset(0.0, -10.0), _borderPaint);

    canvas.drawLine(box.bottomRight, box.bottomRight + Offset(-10.0, 0.0), _borderPaint);
    canvas.drawLine(box.bottomRight, box.bottomRight + Offset(0.0, -10.0), _borderPaint);

    // set the radius along the box width
    canvas.drawCircle(box.center, math.max(1, box.width / 10), _fillPaint);

    _textPainter.text = new TextSpan(
      text: "${this.result.label}",
      children: [
        TextSpan(text: "\n${(this.result.score * 1000).toInt() / 1000.0}", style: _textStyle),
        TextSpan(text: "\n${this.result.cost} secs", style: _textStyle),
      ],
      style: _textStyle,
    );
    _textPainter.layout(maxWidth: box.width * 1.0);
    _textPainter.paint(canvas, box.topLeft + Offset(10, 10));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this.result != null;
  }
}