import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:playing_around/src/games/YahtzeeController.dart';
import 'package:sqflite/sqflite.dart';

import 'presets_manager.dart';
import 'index.dart';
import 'preset_video_games.dart';

yahtzeeControllerSpawnEntryPoint(Map<dynamic, dynamic> message) {}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  Database db;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    setDatabase();
    initNotifications();
    Isolate.spawn(yahtzeeControllerSpawnEntryPoint, {}).then((Isolate isolate) => YahtzeeController(showNotification, 2));
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
    db = await openDatabase('video_game_app.db', version: 1, onCreate: (Database database, int version) async {
      await database.execute('CREATE TABLE contact (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, phone_number TEXT)');
      await database.execute('CREATE TABLE video_game (id INTEGER PRIMARY KEY, name TEXT)');
      await database.execute('CREATE TABLE video_game_contact (id INTEGER PRIMARY KEY, video_game_id INTEGER, contact_id INTEGER)');
      await database.execute('CREATE TABLE scheduled_video_game (id INTEGER PRIMARY KEY, name TEXT, video_game_id INTEGER, time INTEGER, sunday INTEGER, monday INTEGER, tuesday INTEGER, wednesday INTEGER, thursday INTEGER, friday INTEGER, saturday INTEGER)');
    });
  }

  startPresetVideoGame() {
    _addPage((context) => PresetVideoGames(db));
  }

  startCustomVideoGame() {
    _addPage((context) => IndexPage(db, 'Custom Video Game'));
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

  initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    InitializationSettings initializationSettings = InitializationSettings(initializationSettingsAndroid, IOSInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  showNotification(String title, String report) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Video Game', 'Video Game', 'An app for video chatting and AI game playing.',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker'
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, IOSNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
      0, title, report, platformChannelSpecifics,
      payload: 'item x'
    );
  }
}