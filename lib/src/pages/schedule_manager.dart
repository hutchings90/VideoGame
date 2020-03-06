import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleManager extends StatefulWidget {
  final Database db;

  ScheduleManager(this.db, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleManagerState();
}

class ScheduleManagerState extends State<ScheduleManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Video Games')
      )
    );
  }
}