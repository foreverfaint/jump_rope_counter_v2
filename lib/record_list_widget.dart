import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'record.dart';

class RecordListWidget extends StatefulWidget {
  @override
  _RecordListWidgetState createState() => new _RecordListWidgetState();
}

class _RecordListWidgetState extends State<RecordListWidget> {
  final _itemFont = const TextStyle(fontSize: 18.0);

  final _recordList = List<Record>();

  static const num totalDisplayItems = 10;

  RecordRepository _recordRepository;

  @override
  void initState() {
    super.initState();
    this._initRepository();
  }

  @override
  void dispose() {
    if (_recordRepository != null) {
      _recordRepository.close();
      _recordRepository = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  _initRepository() {
    _recordRepository = RecordRepository.open();
    _loadRecords(offset: 0, limit: totalDisplayItems);
  }

  _loadRecords({num offset, num limit}) async {
    var resultList = await _recordRepository.queryAll(offset: offset).toList();

    if (mounted) {
      setState(() {
        _recordList.clear();
        _recordList.addAll(resultList);
      });
    }
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          return _buildRow(_recordList[i]);
        },
        itemCount: math.min(totalDisplayItems, this._recordList.length));
  }

  Widget _buildRow(Record record) {
    return ListTile(
      title: Text(
        "${formatDate(record.createdAtUtc.toLocal(), [yyyy, "-", mm, "-", dd, " ", HH, ":", nn, ":", ss])}",
        style: _itemFont,
      ),
    );
  }
}