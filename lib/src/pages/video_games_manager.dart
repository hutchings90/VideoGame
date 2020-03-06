import 'package:flutter/material.dart';
import 'package:playing_around/src/video_game.dart';
import 'package:sqflite/sqflite.dart';

import 'video_game_editor.dart';

class VideoGamesManager extends StatefulWidget {
  final Database db;

  VideoGamesManager(this.db, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => VideoGamesManagerState();
}

class VideoGamesManagerState extends State<VideoGamesManager> {
  final String tableName = 'video_game';
  List<Widget> videoGameWidgets = List<Widget>();

  @override
  void initState() {
    queryVideoGames();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Games')
      ),
      body: ListView(
        children: videoGameWidgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addVideoGame,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      )
    );
  }
  
  queryVideoGames() {
    widget.db.query(tableName).then(setVideoGamesWidgets);
  }

  setVideoGamesWidgets(List<Map<String, dynamic>> videoGames) {
    setState(() => videoGameWidgets = videoGames.map((Map<String, dynamic> videoGame) => VideoGameWidget(
      videoGame,
      onPressed: _addEditVideoGamePage
    )).toList());
  }

  addVideoGame() {
    _addEditVideoGamePage({
      'name': 'New Video Game'
    });
  }

  _addEditVideoGamePage(Map<String, dynamic> videoGame) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoGameEditor(videoGame, widget.db, saveVideoGame),
      ),
    );
  }

  saveVideoGame(Map<String, dynamic> videoGame, Map<String, dynamic> values) {
    widget.db.transaction((Transaction transaction) async {
      Map<String, dynamic> videoGameValues = values['videoGame'];

      if (videoGame.containsKey('id')) transaction.update(tableName, videoGameValues, where: 'id=' + videoGame['id'].toString()).then((int id) => videoGameSaved(id, values));
      else transaction.insert(tableName, videoGameValues).then((int id) => videoGameSaved(id, values));
    });
  }

  videoGameSaved(int id, Map<String, dynamic> values) {
    Batch batch = widget.db.batch();

    batch.delete('video_game_contact', where: 'video_game_id=' + id.toString());

    values['contacts'].forEach((Map<String, dynamic> contact) => batch.insert('video_game_contact', {
      'video_game_id': id,
      'contact_id': contact['id']
    }));

    batch.commit(noResult: true).then((dynamic result) => queryVideoGames());
  }
}