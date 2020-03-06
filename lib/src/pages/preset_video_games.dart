import 'package:flutter/material.dart';
import 'package:playing_around/src/video_game.dart';
import 'package:sqflite/sqflite.dart';

class PresetVideoGames extends StatefulWidget {
  final Database db;

  PresetVideoGames(this.db, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PresetVideoGamesState();
}

class PresetVideoGamesState extends State<PresetVideoGames> {
  final String tableName = 'video_game';
  List<Widget> videoGameWidgets = List<Widget>();

  @override
  void initState() {
    queryContacts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preset Video Games')
      ),
      body: ListView(
        children: videoGameWidgets,
      ),
    );
  }

  queryContacts() {
    widget.db.query(tableName).then(setVideoGamesWidgets);
  }

  setVideoGamesWidgets(List<Map<String, dynamic>> videoGames) {
    setState(() => videoGameWidgets = videoGames.map((Map<String, dynamic> videoGame) => VideoGameWidget(
      videoGame,
      onPressed: _startVideoGame
    )).toList());
  }

  _startVideoGame(Map<String, dynamic> videoGame) {}
}