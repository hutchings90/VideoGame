import 'dart:async';

import 'package:playing_around/src/games/Yahtzee.dart';

class YahtzeeController {
  List<Yahtzee> _games;
  int _endedGameCount;
  Timer _startTimer;
  List<Timer> _gameReportTimers = <Timer>[];

  final List<Map<String, dynamic>> players;
  final Function(String, String) notify;
  final Function() onGamesOver;

  YahtzeeController(this.players, this.notify, this.onGamesOver);

  double get averageScore => _games.map((Yahtzee yahtzee) => yahtzee.score).reduce((int sum, int cur) => sum + cur) / _games.length;

  int get lowScore {
    _sortGamesByScore();

    return _games.first.score;
  }

  int get highScore {
    _sortGamesByScore();

    return _games.last.score;
  }

  _sortGamesByScore() {
    _games.sort((Yahtzee a, Yahtzee b) => a.score - b.score);
  }

  start() {
    _initStart();
    _notifyStart();
    _timerStart();
  }

  _initStart() {
    _endedGameCount = 0;
    _games = players.map((Map<String, dynamic> player) => yahtzeeGame(player)).toList();
  }

  _notifyStart() {
    String playersString = '';

    if (_games.length > 1) {
      if (_games.length > 2) playersString = _games.sublist(0, _games.length - 1).map((Yahtzee game) => game.player['first_name']).join(', ') + ' and ' + _games.last.player['first_name'];
      else if (_games.length > 1) playersString = _games[0].player['first_name'] + ' and ' + _games[1].player['first_name'];

      playersString += ' are';
    }
    else if (_games.length > 0) playersString = _games[0].player['first_name'] + ' is';

    notify('Welcome to Yahtzee!', playersString + ' playing.');
  }

  _timerStart() {
    _startTimer = Timer(Duration(seconds: 5), () => _games.forEach((Yahtzee yahtzee) => yahtzee.start()));
  }

  stop() {
    if (_startTimer != null) _startTimer.cancel();

    _gameReportTimers.forEach((Timer timer) => timer.cancel());

    _games.forEach((Yahtzee game) => game.stop());
  }

  Yahtzee yahtzeeGame(Map<String, dynamic> player) {
    return Yahtzee(
      player,
      onYahtzee: onYahtzee,
      onBonusYahtzee: onBonusYahtzee,
      onGameEnd: onGameEnd,
    );
  }

  onYahtzee(Yahtzee yahtzee) {
    _yahtzeeReport(yahtzee);
  }

  onBonusYahtzee(Yahtzee yahtzee) {
    _yahtzeeReport(yahtzee, bonus: true);
  }

  _yahtzeeReport(Yahtzee yahtzee, {bool bonus=false}) {
    String report = (bonus ? 'Bonus ' : '') + 'Yahtzee of ' + yahtzee.allDice.first.value.toString() + 's (' + (bonus ? yahtzee.pickedYahtzeeBox.name + ', ' : '') + ((bonus && yahtzee.gotYahtzee ? 100 : 0) + yahtzee.pickedYahtzeeBox.score).toString() + ' points)!';

    notify(yahtzee.player['first_name'], report);
  }

  onGameEnd(Yahtzee yahtzee) {
    if (++_endedGameCount < _games.length) return;

    _endGameReportNotifications();
  }

  _endGameReportNotifications() {
    int i = 0;

    notify('Game Over!', 'All games have ended.');
    onGamesOver();

    _gameReportTimers = <Timer>[];

    _games.forEach((Yahtzee yahtzee) => _gameReportTimers.add(Timer(Duration(seconds: 3 * ++i), () => notify('Yahtzee score for ' + yahtzee.player['first_name'], _yahtzeeScoreReport(yahtzee)))));
  }

  _yahtzeeScoreReport(Yahtzee yahtzee) {
    int exclamationMarkCount = yahtzee.score ~/ 100;

    return yahtzee.player['first_name'] + ' scored ' + yahtzee.score.toString() + ' points' + (exclamationMarkCount > 0 ? ''.padLeft(exclamationMarkCount, '!') : '.');
  }
}