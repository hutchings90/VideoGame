import 'dart:async';

import 'package:playing_around/src/games/Yahtzee.dart';

class YahtzeeController {
  List<Yahtzee> _games;
  int _endedGameCount;
  Timer _startTimer;
  List<Timer> _gameReportTimers = <Timer>[];

  final int playerCount;
  final Function showNotification;

  YahtzeeController(this.showNotification, this.playerCount);

  start() {
    String title = 'Welcome to Yahtzee!', body;

    _games = <Yahtzee>[];
    _endedGameCount = 0;

    for (int i = 1; i <= playerCount; i++) {
      _games.add(yahtzeeGame('Player ' + i.toString()));
    }

    body = _games.map((Yahtzee game) => game.playerName).join(', ');

    print(title + ' ' + body);
    showNotification(title, body);

    _startTimer = Timer(Duration(seconds: 5), () => _games.forEach((Yahtzee yahtzee) => yahtzee.start()));
  }

  stop() {
    if (_startTimer != null) _startTimer.cancel();

    _gameReportTimers.forEach((Timer timer) => timer.cancel());

    _games.forEach((Yahtzee game) => game.stop());
  }

  Yahtzee yahtzeeGame(String name) {
    return Yahtzee(
      name,
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
    print(yahtzee.playerName + ': ' + 'Game Over\n' + yahtzee.toString());

    if (++_endedGameCount >= _games.length) {
      int i = 0;

      showNotification('Game Over!', 'All games have ended. Scores will be reported shortly.');

      _gameReportTimers = <Timer>[];

      _games.forEach((Yahtzee yahtzee) => _gameReportTimers.add(Timer(Duration(seconds: 3 * ++i), () => endGameReport(yahtzee))));
    }
  }

  endGameReport(Yahtzee yahtzee) {
    gameReport(yahtzee, yahtzee.score.toString());
  }

  scoreSuccessReport(Yahtzee yahtzee, String prefix, {bool lineBreak: false}) {
    gameReport(yahtzee, prefix + yahtzee.pickedYahtzeeBox.name + ' (' + yahtzee.pickedYahtzeeBox.score.toString() + ' pts)');
  }

  allDiceReport(Yahtzee yahtzee, String prefix, {bool lineBreak: false}) {
    gameReport(yahtzee, prefix + yahtzee.allDice.toString());
  }

  gameReport(Yahtzee yahtzee, String report, {bool lineBreak: false}) {
    print(yahtzee.playerName + ': ' + report);

    if (lineBreak) print('');

    showNotification(yahtzee.playerName, report);
  }
}