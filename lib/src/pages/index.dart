import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  final Database db;
  final String callName;

  IndexPage(this.db, this.callName, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Flutter QuickStart'),
      ),
      body: RaisedButton(
        onPressed: onJoin,
        child: Text('Start'),
        color: Colors.blueAccent,
        textColor: Colors.white,
      ),
    );
  }

  Future<void> onJoin() async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: widget.callName,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
