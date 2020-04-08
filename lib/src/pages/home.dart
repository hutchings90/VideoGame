import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playing_around/src/pages/call.dart';
import 'package:sqflite/sqflite.dart';

import 'presets_manager.dart';
import 'index.dart';
import 'preset_video_games.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  Database db;

  @override
  initState() {
    setDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Game')
      ),
      body: Center(
        child: Column(
          children: <Widget>[RaisedButton(
            onPressed: startPresetVideoGame,
            child: Text('Start Preset Video Game')
          ), RaisedButton(
            onPressed: startCustomVideoGame,
            child: Text('Start Custom Video Game')
          )]
        )
      ),
      floatingActionButton: RaisedButton(
        onPressed: managePresets,
        child: Icon(Icons.settings)
      )
    );
  }

  setDatabase() async {
    String databaseName = 'video_game_app.db';

    // await deleteDatabase(databaseName);

    db = await openDatabase(databaseName, version: 1, onCreate: (Database database, int version) async {
      await database.execute('CREATE TABLE contact (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, phone_number TEXT)');
      await database.execute('CREATE TABLE video_game (id INTEGER PRIMARY KEY, name TEXT)');
      await database.execute('CREATE TABLE video_game_contact (id INTEGER PRIMARY KEY, video_game_id INTEGER, contact_id INTEGER)');
      await database.execute('CREATE TABLE scheduled_video_game (id INTEGER PRIMARY KEY, name TEXT, video_game_id INTEGER, time INTEGER, sunday INTEGER, monday INTEGER, tuesday INTEGER, wednesday INTEGER, thursday INTEGER, friday INTEGER, saturday INTEGER)');
    });
  }

  startPresetVideoGame() {
    _addPage((context) => PresetVideoGames(db, joinPresetVideoGame));
  }

  startCustomVideoGame() {
    _addPage((context) => IndexPage(db, 'Custom Video Game', joinCustomVideoGame));
  }

  managePresets() {
    _addPage((context) => PresetsManager(db));
  }

  _addPage(builder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }

  joinPresetVideoGame(Map<String, dynamic> videoGame) async {
    onJoin(videoGame['name'], (await _contactsForVideoGame(videoGame)).toList());
  }

  joinCustomVideoGame(String channelName, List<Map<String, dynamic>> contacts) {
    onJoin(channelName, contacts);
  }

  Future<void> onJoin(String channelName, List<Map<String, dynamic>> contacts) async {
    await _requestCallPermissions();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(channelName, contacts),
      ),
    );
  }

  Future<void> _requestCallPermissions() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone, PermissionGroup.sms],
    );
  }

  Future<List<Map<String, dynamic>>> _contactsForVideoGame(Map<String, dynamic> videoGame) async {
    List<Map<String, dynamic>> videoGameContacts = await _videoGameContacts(videoGame['id']);
    List<int> videoGameContactContactIds = videoGameContacts.map((Map<String, dynamic> videoGameContact) => videoGameContact['contact_id'] as int).toList();

    return db.query(
      'contact',
      where: 'id in (' + videoGameContactContactIds.join(',') + ')');
  }

  Future<List<Map<String, dynamic>>> _videoGameContacts(int videoGameId) {
    return db.query('video_game_contact', where: 'video_game_id=' + videoGameId.toString());
  }
}