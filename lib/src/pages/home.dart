import 'package:flutter/material.dart';
import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/LargeStraightYahtzeeBox.dart';
import 'package:playing_around/src/games/Yahtzee.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/SmallStraightYahtzeeBox.dart';
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
  void initState() {
    setDatabase();

    startYahtzeeGame('Player 1');
    // startYahtzeeGame('Player 2');
    // startYahtzeeGame('Player 3');
    // startYahtzeeGame('Player 4');
    // startYahtzeeGame('Player 5');

    super.initState();
  }

  startYahtzeeGame(String name) {
    Yahtzee(
      onRollSuccess: (YahtzeeBox yahtzeeBox) => onRollSuccess(name, yahtzeeBox),
      onTurnSuccess: (YahtzeeBox yahtzeeBox) => onTurnSuccess(name, yahtzeeBox),
      onYahtzee: (YahtzeeBox yahtzeeBox) => onYahtzee(name, yahtzeeBox),
      onBonusYahtzee: (YahtzeeBox yahtzeeBox) => onBonusYahtzee(name, yahtzeeBox),
      onRollFail: (List<Die> dice) => onRollFail(name, dice),
      onTurnFail: (List<Die> dice) => onTurnFail(name, dice),
      onGameEnd: (Yahtzee yahtzee) => onGameEnd(name, yahtzee),
    ).play();
  }

  onRollSuccess(String name, YahtzeeBox yahtzeeBox) {
    turnReport(name, 'Roll Success: ' + yahtzeeBox.toString());
  }

  onTurnSuccess(String name, YahtzeeBox yahtzeeBox) {
    turnReport(name, 'Turn Success: ' + yahtzeeBox.toString());
  }

  onYahtzee(String name, YahtzeeBox yahtzeeBox) {
    turnReport(name, 'Yahtzee: ' + yahtzeeBox.toString());
  }

  onBonusYahtzee(String name, YahtzeeBox yahtzeeBox) {
    turnReport(name, 'Bonus Yahtzee: ' + yahtzeeBox.toString());
  }

  onRollFail(String name, List<Die> dice) {
    turnReport(name, 'Roll Failed: ' + dice.toString());
  }

  onTurnFail(String name, List<Die> dice) {
    turnReport(name, 'Turn Failed: ' + dice.toString());
  }

  onGameEnd(String name, Yahtzee yahtzee) {
    turnReport(name, 'Game Over: \n' + yahtzee.toString());
  }

  turnReport(String name, String report) {
    print(name + ': ' + report);
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
}