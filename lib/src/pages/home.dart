import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/Yahtzee.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    setDatabase();
    initNotifications();

    for (int i = 1; i < 2; i++) {
      yahtzeeGame('Player ' + i.toString());
    }

    super.initState();
  }

  yahtzeeGame(String name) {
    Yahtzee(
      // onRollSuccess: (YahtzeeBox yahtzeeBox) => onRollSuccess(name, yahtzeeBox),
      // onTurnSuccess: (YahtzeeBox yahtzeeBox) => onTurnSuccess(name, yahtzeeBox),
      // onYahtzee: (YahtzeeBox yahtzeeBox) => onYahtzee(name, yahtzeeBox),
      // onBonusYahtzee: (YahtzeeBox yahtzeeBox) => onBonusYahtzee(name, yahtzeeBox),
      // onRollFail: (List<Die> dice) => onRollFail(name, dice),
      // onTurnFail: (List<Die> dice) => onTurnFail(name, dice),
      // onRollAgain: (List<Die> diceToKeep, List<Die> diceToRoll) => onRollAgain(name, diceToKeep, diceToRoll),
      onGameEnd: (Yahtzee yahtzee) => onGameEnd(name, yahtzee),
    ).play();
  }

  onRollSuccess(String name, YahtzeeBox yahtzeeBox) {
    yahtzeeReport(name, 'Roll Success: ' + yahtzeeBox.toString());
  }

  onTurnSuccess(String name, YahtzeeBox yahtzeeBox) {
    yahtzeeReport(name, 'Turn Success: ' + yahtzeeBox.toString(), lineBreak: true);
  }

  onYahtzee(String name, YahtzeeBox yahtzeeBox) {
    yahtzeeReport(name, 'Yahtzee: ' + yahtzeeBox.toString());
  }

  onBonusYahtzee(String name, YahtzeeBox yahtzeeBox) {
    yahtzeeReport(name, 'Bonus Yahtzee: ' + yahtzeeBox.toString());
  }

  onRollFail(String name, List<Die> dice) {
    yahtzeeReport(name, 'Roll Failed: ' + dice.toString());
  }

  onTurnFail(String name, List<Die> dice) {
    yahtzeeReport(name, 'Turn Failed: ' + dice.toString(), lineBreak: true);
  }

  onRollAgain(String name, List<Die> diceToKeep, List<Die> diceToRoll) {
    yahtzeeReport(name, 'Roll Again, Keep ' + diceToKeep.toString() + ', Roll ' + diceToRoll.toString());
  }

  onGameEnd(String name, Yahtzee yahtzee) {
    yahtzeeReport(name, 'Game Over\n' + yahtzee.toString());
  }

  yahtzeeReport(String name, String report, {bool lineBreak: false}) async {
    print(name + ': ' + report);

    if (lineBreak) print('');

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Video Game', 'Video Game', 'An app for video chatting and AI game playing.',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker'
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, name, report, platformChannelSpecifics,
      payload: 'item x'
    );
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

  initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
}