import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'contacts_manager.dart';
import 'video_games_manager.dart';
import 'schedule_manager.dart';

class PresetsManager extends StatefulWidget {
  final Database db;

  PresetsManager(this.db, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PresetsManagerState();
}

class PresetsManagerState extends State<PresetsManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),
      body: Center(
        child: Column(
          children: <Widget>[RaisedButton(
            onPressed: manageContacts,
            child: Text('Contacts')
          ), RaisedButton(
            onPressed: manageVideoGames,
            child: Text('Video Games')
          ), RaisedButton(
            onPressed: manageSchedule,
            child: Text('Scheduled Video Games')
          )]
        )
      )
    );
  }

  manageContacts() {
    _addPage((context) => ContactsManager(widget.db));
  }

  manageVideoGames() {
    _addPage((context) => VideoGamesManager(widget.db));
  }

  manageSchedule() {
    _addPage((context) => ScheduleManager(widget.db));
  }

  _addPage(builder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }
}