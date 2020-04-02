import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class IndexPage extends StatefulWidget {
  final Database db;
  final String callName;
  final Function(String callName) onJoin;

  IndexPage(this.db, this.callName, this.onJoin, { Key key }) : super(key: key);

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
        onPressed: () => widget.onJoin(widget.callName),
        child: Text('Start'),
        color: Colors.blueAccent,
        textColor: Colors.white,
      ),
    );
  }
}
