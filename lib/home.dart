import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

import 'record_list_widget.dart';
import 'counter_widget.dart';
import 'json_localizations.dart';

enum Route {
  listViewPage,
  counterPage
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras) : super(key: GlobalKey());

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _log = Logger('_HomePageState');

  Route _route = Route.listViewPage;

  Widget _buildWidget() {
    switch (_route) {
      case Route.listViewPage:
        return RecordListWidget();
      case Route.counterPage:
        return CounterWidget(widget.cameras[0]);
      default:
        return RecordListWidget();
    }
  }

  Widget _buildFloatingButton() {
    switch (_route) {
      case Route.listViewPage:
        return FloatingActionButton(
          onPressed: this._startCounter,
          tooltip: JsonLocalizations.of(context).text('start'),
          child: const Icon(Icons.play_arrow),
        );
      case Route.counterPage:
        return FloatingActionButton(
          onPressed: this._stopCounter,
          tooltip: JsonLocalizations.of(context).text('stop'),
          child: const Icon(Icons.stop),
        );
      default:
        return FloatingActionButton(
          onPressed: this._startCounter,
          tooltip: JsonLocalizations.of(context).text('start'),
          child: const Icon(Icons.add),
        );
    }
  }

  @override
  void initState() {
    _log.log(Level.INFO, '${this.widget.key}.initState');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadModels();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      if (this._route == Route.counterPage) {
        this._stopCounter();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _log.log(Level.INFO, '${this.widget.key}.dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(JsonLocalizations.of(context).text('title')),
      ),
      body: Center(
        child: _buildWidget()
      ),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  _stopCounter() {
    _log.log(Level.INFO, '${this.widget.key}._stopCounter');
    this.setState(() { _route = Route.listViewPage; });
  }

  _startCounter() {
    _log.log(Level.INFO, '${this.widget.key}._startCounter');
    this.setState(() { _route = Route.counterPage; });
  }

  _loadModels() async {
    _log.log(Level.INFO, '${this.widget.key}._loadModels');
    Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt"
    );
  }
}