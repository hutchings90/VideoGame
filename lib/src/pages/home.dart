import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:playing_around/src/games/Yahtzee.dart';
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
  List<Yahtzee> games;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    setDatabase();
    initNotifications();

    playYahtzee();

    super.initState();
  }

  playYahtzee() {
    String title = 'Welcome to Yahtzee!', body;

    games = <Yahtzee>[];

    for (int i = 1; i < 1000; i++) {
      games.add(yahtzeeGame('Player ' + i.toString()));
    }

    body = games.map((Yahtzee game) => game.playerName).join(', ');
    games.forEach((Yahtzee yahtzee) => yahtzee.play());

    print(title + ' ' + body);
    showNotification(title, body);
  }

  Yahtzee yahtzeeGame(String name) {
    return Yahtzee(
      name,
      // onRollSuccess: onRollSuccess,
      // onRollFail: onRollFail,
      // onRollAgain: onRollAgain,
      // onTurnSuccess: onTurnSuccess,
      // onTurnFail: onTurnFail,
      // onYahtzee: onYahtzee,
      onBonusYahtzee: onBonusYahtzee,
      onGameEnd: onGameEnd,
    );
  }

  onRollSuccess(Yahtzee yahtzee) {
    scoreSuccessReport(yahtzee, 'Roll Success: ');
  }

  onRollFail(Yahtzee yahtzee) {
    allDiceReport(yahtzee, 'Roll Failed: ');
  }

  onRollAgain(Yahtzee yahtzee) {
    gameReport(yahtzee, 'Roll Again, Keep ' + yahtzee.diceToKeep.toString() + ', Roll ' + yahtzee.diceToRoll.toString());
  }

  onTurnSuccess(Yahtzee yahtzee) {
    scoreSuccessReport(yahtzee, 'Turn Success: ', lineBreak: true);
  }

  onTurnFail(Yahtzee yahtzee) {
    allDiceReport(yahtzee, 'Turn Failed: ', lineBreak: true);
  }

  onYahtzee(Yahtzee yahtzee) {
    yahtzeeReport(yahtzee);
  }

  onBonusYahtzee(Yahtzee yahtzee) {
    yahtzeeReport(yahtzee, bonus: true);
  }

  yahtzeeReport(Yahtzee yahtzee, {bool bonus=false}) {
    gameReport(yahtzee, (bonus ? 'Bonus ' : '') + 'Yahtzee of ' + yahtzee.allDice.first.value.toString() + 's (' + (bonus ? yahtzee.pickedYahtzeeBox.name + ', ' : '') + ((bonus && yahtzee.gotYahtzee ? 100 : 0) + yahtzee.pickedYahtzeeBox.score).toString() + ' pts)!');
  }

  onGameEnd(Yahtzee yahtzee) {
    // gameReport(yahtzee, 'Game Over\n' + yahtzee.toString());

    if (games.where((Yahtzee game) => game.gameOver).length >= games.length) playYahtzee();
  }

  scoreSuccessReport(Yahtzee yahtzee, String prefix, {bool lineBreak: false}) {
    gameReport(yahtzee, prefix + yahtzee.pickedYahtzeeBox.toString());
  }

  allDiceReport(Yahtzee yahtzee, String prefix, {bool lineBreak: false}) {
    gameReport(yahtzee, prefix + yahtzee.allDice.toString());
  }

  gameReport(Yahtzee yahtzee, String report, {bool lineBreak: false}) {
    print(yahtzee.playerName + ': ' + report);

    if (lineBreak) print('');

    showNotification(yahtzee.playerName, report);
  }

  showNotification(String title, String report) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Video Game', 'Video Game', 'An app for video chatting and AI game playing.',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker'
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, title, report, platformChannelSpecifics,
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