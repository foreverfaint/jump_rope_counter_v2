import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'record_list_widget.dart';
import 'counter_widget.dart';

enum Route {
  listViewPage,
  counterPage
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          onPressed: () => this.setState(() { _route = Route.counterPage; }),
          tooltip: "Start",
          child: const Icon(Icons.play_arrow),
        );
      case Route.counterPage:
        return FloatingActionButton(
          onPressed: () => this.setState(() { _route = Route.listViewPage; }),
          tooltip: "Stop",
          child: const Icon(Icons.stop),
        );
      default:
        return FloatingActionButton(
          onPressed: () => this.setState(() { _route = Route.counterPage; }),
          tooltip: "Start",
          child: const Icon(Icons.add),
        );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildWidget()
      ),
      floatingActionButton: _buildFloatingButton(),
    );
  }
}