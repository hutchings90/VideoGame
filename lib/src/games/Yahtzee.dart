import 'dart:async';

import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBottom.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeTop.dart';

class Yahtzee {
  static const DICE_COUNT = 5;
  static const int BONUS_YAHTZEE_SCORE = 100;

  int turnCount, rollCount;
  bool turnDone;
  YahtzeeTop top = YahtzeeTop();
  YahtzeeBottom bottom = YahtzeeBottom();
  List<Die> dice = <Die>[Die(), Die(), Die(), Die(), Die()];

  final Function(YahtzeeBox yahtzeeBox) onRollSuccess, onTurnSuccess, onYahtzee, onBonusYahtzee;
  final Function(List<Die> dice) onRollFail, onTurnFail;
  final Function(Yahtzee yahtzee) onGameEnd;

  Yahtzee({this.onRollSuccess, this.onTurnSuccess, this.onYahtzee, this.onBonusYahtzee, this.onRollFail, this.onTurnFail, this.onGameEnd});

  int get score => top.score + bottom.score;
  int get _buttonCount => top.boxes.length + bottom.boxes.length;
  List<Die> get _rollableDice => dice.where((Die die) => !die.picked).toList();
  List<Die> get reportDice => List.from(dice);

  List<YahtzeeBox> get allBoxes {
    List<YahtzeeBox> combined = <YahtzeeBox>[];

    combined.addAll(top.boxes);
    combined.addAll(bottom.boxes);

    return combined;
  }

  List<YahtzeeBox> get bonusYahtzeeBoxes => allBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.isBonusYahtzee).toList();
  List<int> get bonusYahtzeeNumbers => bonusYahtzeeBoxes.map((YahtzeeBox yahtzeeBox) => yahtzeeBox.myDice[0].value).toList();
  int get bonusYahtzeeCount => bonusYahtzeeBoxes.length;
  int get bonusYahtzeeScore => BONUS_YAHTZEE_SCORE * bonusYahtzeeCount;

  static bool isYahtzee(List<Die> dice) {
    return dice.length == DICE_COUNT && dice.every((Die die) => die.value == dice[0].value);
  }

  play() async {
    turnCount = 1;

    _takeTurn();
  }

  _takeTurn() async {
    rollCount = 1;
    turnDone = false;

    _roll();
  }

  _roll() async {
    _rollableDice.forEach((Die die) => die.roll());

    _endRoll(_chooseYahtzeeBox());
  }

  // TODO: Make this intelligent.
  YahtzeeBox _chooseYahtzeeBox() {
    YahtzeeBox yahtzeeBox = top.useDice(dice);

    if (yahtzeeBox == null) return bottom.useDice(dice);

    return yahtzeeBox;
  }

  _endRoll(YahtzeeBox yahtzeeBox) async {
    if (yahtzeeBox == null) {
      if (onRollFail != null) onRollFail(reportDice);
    }
    else {
      turnDone = true;

      if (onRollSuccess != null) onRollSuccess(yahtzeeBox);
    }

    if (++rollCount > 3 || turnDone) _endTurn(yahtzeeBox);
    else _nextRoll();
  }

  _nextRoll() async {
    Timer(Duration(seconds: 3), () => _roll());
  }

  _endTurn(YahtzeeBox yahtzeeBox) async {
    if (yahtzeeBox == null) {
      if (onTurnFail != null) onTurnFail(reportDice);
    }
    else if (onTurnSuccess != null) onTurnSuccess(yahtzeeBox);

    if (turnCount++ < _buttonCount) _nextTurn();
    else _endGame();
  }

  _nextTurn() async {
    Timer(Duration(seconds: 2), () => _takeTurn());
  }

  _endGame() async {
    if (onGameEnd != null) onGameEnd(this);
  }

  @override
  String toString() {
    return <String>[
      top.toString(),
      bottom.toString(),
      'Bonus Yahtzees: ' + bonusYahtzeeScore.toString() + ' ' + bonusYahtzeeNumbers.toString(),
      'Total of Lower Section: ' + bottom.score.toString(),
      'Total of Upper Section: ' + top.score.toString(),
      'Grand Total: ' + score.toString()
    ].join('\n');
  }

  test() {
    testTop();
    testBottom();
  }

  testTop() {
    // None gotten
    top.boxes[0].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    top.boxes[1].use(<Die>[Die(value: 5), Die(value: 1), Die(value: 6), Die(value: 5), Die(value: 4)]);
    top.boxes[2].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[3].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 1)]);
    top.boxes[4].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[5].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 1), Die(value: 5), Die(value: 4)]);

    print('top - none');
    print(top);

    // Gotten, no bonus
    top.boxes[0].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[1].use(<Die>[Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 2), Die(value: 4)]);
    top.boxes[2].use(<Die>[Die(value: 3), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 6), Die(value: 4), Die(value: 1)]);
    top.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    top.boxes[5].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('top - no bonus');
    print(top);

    // Gotten, bonus
    top.boxes[0].use(<Die>[Die(value: 1), Die(value: 1), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[1].use(<Die>[Die(value: 2), Die(value: 2), Die(value: 6), Die(value: 2), Die(value: 4)]);
    top.boxes[2].use(<Die>[Die(value: 3), Die(value: 3), Die(value: 3), Die(value: 1), Die(value: 4)]);
    top.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 4), Die(value: 4), Die(value: 1)]);
    top.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 5), Die(value: 5), Die(value: 4)]);
    top.boxes[5].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );

    print('top - with bonus');
    print(top);
  }

  testBottom() {
    // None gotten
    bottom.boxes[0].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    bottom.boxes[1].use(<Die>[Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 2), Die(value: 4)]);
    bottom.boxes[2].use(<Die>[Die(value: 3), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    bottom.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 6), Die(value: 4), Die(value: 1)]);
    bottom.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('bottom - none');
    print(bottom);

    // Gotten
    bottom.boxes[0].use(<Die>[Die(value: 1), Die(value: 1), Die(value: 6), Die(value: 1), Die(value: 4)]);
    bottom.boxes[1].use(<Die>[Die(value: 2), Die(value: 2), Die(value: 2), Die(value: 2), Die(value: 4)]);
    bottom.boxes[2].use(<Die>[Die(value: 3), Die(value: 3), Die(value: 3), Die(value: 4), Die(value: 4)]);
    bottom.boxes[3].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 3), Die(value: 4), Die(value: 3)]);
    bottom.boxes[4].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 3), Die(value: 4), Die(value: 5)]);
    bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)]);
    bottom.boxes[6].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('bottom - all');
    print(bottom);

    // Gotten
    bottom.boxes[0].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[1].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[2].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[3].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[4].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)]);
    bottom.boxes[6].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );

    print('bottom - all yahtzees');
    print(bottom);
  }
}