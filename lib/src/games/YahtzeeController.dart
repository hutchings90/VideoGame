import 'dart:async';

import 'package:playing_around/src/games/Yahtzee.dart';

class YahtzeeController {
  List<Yahtzee> _games;
  int _endedGameCount;
  Timer _startTimer;
  List<Timer> _gameReportTimers = <Timer>[];

  final List<Map<String, dynamic>> players;
  final Future<void> Function(String, String) showNotification;
  final Function(String, List<Map<String, dynamic>>) sendText;

  YahtzeeController(this.players, this.showNotification, this.sendText);

  start() {
    _endedGameCount = 0;
    _games = players.map((Map<String, dynamic> player) => yahtzeeGame(player)).toList();

    showNotification('Welcome to Yahtzee!', _games.map((Yahtzee game) => game.player['first_name']).join(', '));
    _textAllUsers('Welcome to Yahtzee!' + '\n' + _games.map((Yahtzee game) => game.player['first_name']).join(', '));

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

    showNotification(yahtzee.player['first_name'], report);
    _textUser(report, yahtzee.player);
  }

  onGameEnd(Yahtzee yahtzee) {
    if (++_endedGameCount < _games.length) return;

    _endGameReportNotifications();
    _endGameReportTexts();
  }

  _endGameReportNotifications() {
    int i = 0;

    showNotification('Game Over!', 'All games have ended. Scores will be reported shortly.');

    _gameReportTimers = <Timer>[];

    _games.forEach((Yahtzee yahtzee) => _gameReportTimers.add(Timer(Duration(seconds: 3 * ++i), () => showNotification(yahtzee.player['first_name'], _yahtzeeScoreReport(yahtzee)))));
  }

  _endGameReportTexts() {
    _games.forEach((Yahtzee yahtzee) => _textUser('Game over!\n' + _yahtzeeScoreReport(yahtzee), yahtzee.player));
  }

  _yahtzeeScoreReport(Yahtzee yahtzee) {
    int exclamationMarkCount = yahtzee.score ~/ 100;

    return 'You scored ' + yahtzee.score.toString() + ' points' + (exclamationMarkCount > 0 ? ''.padLeft(exclamationMarkCount, '!') : '.');
  }

  _textAllUsers(String message) {
    _textUsers(message, _games.map((Yahtzee game) => game.player).toList());
  }

  _textUser(String message, Map<String, dynamic> contact) {
    _textUsers(message, <Map<String, dynamic>>[ contact ]);
  }

  _textUsers(String message, List<Map<String, dynamic>> contacts) {
    sendText(message, contacts);
  }
}