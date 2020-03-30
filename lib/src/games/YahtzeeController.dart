import 'dart:async';

import 'package:playing_around/src/games/Yahtzee.dart';

class YahtzeeController {
  List<Yahtzee> games;
  int round = 1;
  int endedGameCount;

  final int playerCount;
  final Function showNotification;

  YahtzeeController(this.showNotification, this.playerCount) {
    start();
  }

  start() {
    String title = 'Welcome to Yahtzee!', body;

    games = <Yahtzee>[];
    endedGameCount = 0;

    for (int i = 1; i <= playerCount; i++) {
      games.add(yahtzeeGame('Player ' + i.toString() + ' (Round ' + round.toString() + ')'));
    }

    body = games.map((Yahtzee game) => game.playerName).join(', ');

    print(title + ' ' + body);
    showNotification(title, body);

    Timer(Duration(seconds: 5), () => games.forEach((Yahtzee yahtzee) => yahtzee.play()));
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

    if (++endedGameCount >= games.length) {
      int i = 0;

      showNotification('Game Over!', 'All games have ended. Scores will be reported shortly.');

      games.forEach((Yahtzee yahtzee) => Timer(Duration(seconds: 3 * ++i), () => gameReport(yahtzee, yahtzee.score.toString())));

      round++;

      Timer(Duration(seconds: 5 + (3 * i)), start);
    }
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