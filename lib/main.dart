import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home.dart';
import 'locales.dart';
import 'json_localizations_delegate.dart';

List<CameraDescription> cameras;

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      localizationsDelegates: [
        const JsonLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: getSupportedLocales(),
      home: HomePage(cameras),
    );
  }
}