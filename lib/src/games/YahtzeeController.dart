import 'dart:async';

import 'package:playing_around/src/games/Yahtzee.dart';

class YahtzeeController {
  List<Yahtzee> _games;
  int _endedGameCount;
  Timer _startTimer;
  List<Timer> _gameReportTimers = <Timer>[];

  final List<Map<String, dynamic>> players;
  final Function showNotification;

  YahtzeeController(this.showNotification, this.players);

  start() {
    _endedGameCount = 0;
    _games = players.map((Map<String, dynamic> player) => yahtzeeGame(player));

    showNotification('Welcome to Yahtzee!', _games.map((Yahtzee game) => game.player['first_name']).join(', '));

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
      // onRollSuccess: onRollSuccess,
      // onRollFail: onRollFail,
      // onRollAgain: onRollAgain,
      // onTurnSuccess: onTurnSuccess,
      // onTurnFail: onTurnFail,
      onYahtzee: onYahtzee,
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
    scoreSuccessReport(yahtzee, 'Turn Success: ');
  }

  onTurnFail(Yahtzee yahtzee) {
    allDiceReport(yahtzee, 'Turn Failed: ');
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
    if (++_endedGameCount < _games.length) return;

    int i = 0;

    showNotification('Game Over!', 'All games have ended. Scores will be reported shortly.');

    _gameReportTimers = <Timer>[];

    _games.forEach((Yahtzee yahtzee) => _gameReportTimers.add(Timer(Duration(seconds: 3 * ++i), () => endGameReport(yahtzee))));
  }

  endGameReport(Yahtzee yahtzee) {
    gameReport(yahtzee, yahtzee.score.toString());
  }

  scoreSuccessReport(Yahtzee yahtzee, String prefix) {
    gameReport(yahtzee, prefix + yahtzee.pickedYahtzeeBox.name + ' (' + yahtzee.pickedYahtzeeBox.score.toString() + ' pts)');
  }

  allDiceReport(Yahtzee yahtzee, String prefix) {
    gameReport(yahtzee, prefix + yahtzee.allDice.toString());
  }

  gameReport(Yahtzee yahtzee, String report) {
    showNotification(yahtzee.player['first_name'], report);
  }
}