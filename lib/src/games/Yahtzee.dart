import 'dart:async';

import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBottom.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeTop.dart';

class Yahtzee {
  static const int BONUS_YAHTZEE_SCORE = 100;
  static const int ROLL_DELAY = 0;
  static const int TURN_DELAY = 0;
  static const int ROLLS_PER_TURN = 3;

  int _turnCount, _rollCount;
  YahtzeeTop _top = YahtzeeTop();
  YahtzeeBottom _bottom = YahtzeeBottom();
  List<Die> _diceToRoll = <Die>[Die(), Die(), Die(), Die(), Die()];
  List<Die> _diceToKeep = <Die>[];
  YahtzeeBox _pickedYahtzeeBox;

  final Function(YahtzeeBox yahtzeeBox) onRollSuccess, onTurnSuccess, onYahtzee, onBonusYahtzee;
  final Function(List<Die> dice) onRollFail, onTurnFail;
  final Function(Yahtzee yahtzee) onGameEnd;

  Yahtzee({this.onRollSuccess, this.onTurnSuccess, this.onYahtzee, this.onBonusYahtzee, this.onRollFail, this.onTurnFail, this.onGameEnd});

  int get score => _top.score + _bottom.score;

  bool get _rollSucceeded => _pickedYahtzeeBox.score > 0;
  bool get _turnOver => _rollCount >= ROLLS_PER_TURN || _rollSucceeded;
  List<YahtzeeBox> get _allBoxes => _top.boxes + _bottom.boxes;
  int get _boxCount => _allBoxes.length;
  bool get _gameOver => _turnCount >= _boxCount;
  List<YahtzeeBox> get _bonusYahtzeeBoxes => _allBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.isBonusYahtzee).toList();
  List<int> get _bonusYahtzeeNumbers => _bonusYahtzeeBoxes.map((YahtzeeBox yahtzeeBox) => yahtzeeBox.myDice[0].value).toList();
  int get _bonusYahtzeeCount => _bonusYahtzeeBoxes.length;
  int get _bonusYahtzeeScore => BONUS_YAHTZEE_SCORE * _bonusYahtzeeCount;
  List<Die> get _pickedDice => _pickedYahtzeeBox.myDice;
  List<Die> get _allDice => _diceToRoll + _diceToKeep;
  bool get _shouldUsePickedYahtzeeBox => _turnOver || _pickedYahtzeeBox.diceScore(_allDice) > 0;

  YahtzeeBox get _mostValuableYahtzeeBox {
    return _yahtzeeBoxByScoreCompare(_top.mostValuableYahtzeeBox(_allDice), _bottom.mostValuableYahtzeeBox(_allDice), true);
  }

  YahtzeeBox get _throwAwayYahtzeeBox {
    return _yahtzeeBoxByScoreCompare(_top.throwAwayYahtzeeBox(_allDice), _bottom.throwAwayYahtzeeBox(_allDice), false);
  }

  YahtzeeBox _yahtzeeBoxByScoreCompare(YahtzeeBox topYahtzeeBox, YahtzeeBox bottomYahtzeeBox, bool greaterThan) {
    if (topYahtzeeBox == null) return bottomYahtzeeBox;
    if (bottomYahtzeeBox == null) return topYahtzeeBox;
    return (greaterThan == topYahtzeeBox.diceScore(_allDice) > bottomYahtzeeBox.diceScore(_allDice)) ? topYahtzeeBox : bottomYahtzeeBox;
  }

  play() async {
    _initPlay();
    _takeTurn();
  }

  _initPlay() {
    _turnCount = 0;
  }

  _takeTurn() {
    _initTurn();
    _roll();
  }

  _initTurn() {
    _turnCount++;
    _rollCount = 0;
  }

  _roll() {
    _rollDice();
    _pickYahtzeeBox();
    _reportRoll();
    _endRoll();
  }

  _rollDice() {
    _rollCount++;
    _diceToRoll.forEach((Die die) => die.roll());
  }

  _pickYahtzeeBox() {
    _pickedYahtzeeBox = _mostValuableYahtzeeBox;

    if (_pickedYahtzeeBox == null) _pickedYahtzeeBox = _throwAwayYahtzeeBox;

    if (_shouldUsePickedYahtzeeBox) _pickedYahtzeeBox.use(_allDice);
  }

  _reportRoll() {
    _report(onRollSuccess, onRollFail);
  }

  _endRoll() {
    _turnOver ? _processTurn() : _nextRoll();
  }

  _nextRoll() {
    Timer(Duration(seconds: ROLL_DELAY), () => _roll());
  }

  _processTurn() {
    _reportTurn();
    _endTurn();
  }

  _reportTurn() {
    _report(onTurnSuccess, onTurnFail);
  }

  _report(Function onSuccess, Function onFail) {
    if (_rollSucceeded) {
      if (onSuccess != null) onSuccess(_pickedYahtzeeBox);
    }
    else if (onFail != null) onFail(_pickedDice);
  }

  _endTurn() {
    _gameOver ? _endGame() : _nextTurn();
  }

  _endGame() {
    if (onGameEnd != null) onGameEnd(this);
  }

  _nextTurn() {
    Timer(Duration(seconds: TURN_DELAY), () => _takeTurn());
  }

  @override
  String toString() {
    return <String>[
      _top.toString(),
      _bottom.toString(),
      'Bonus Yahtzees: ' + _bonusYahtzeeScore.toString() + ' ' + _bonusYahtzeeNumbers.toString(),
      'Total of Lower Section: ' + _bottom.score.toString(),
      'Total of Upper Section: ' + _top.score.toString(),
      'Grand Total: ' + score.toString()
    ].join('\n');
  }

  test() {
    testTop();
    testBottom();
  }

  testTop() {
    // None gotten
    _top.boxes[0].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    _top.boxes[1].use(<Die>[Die(value: 5), Die(value: 1), Die(value: 6), Die(value: 5), Die(value: 4)]);
    _top.boxes[2].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _top.boxes[3].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 1)]);
    _top.boxes[4].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _top.boxes[5].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 1), Die(value: 5), Die(value: 4)]);

    print('_top - none');
    print(_top);

    // Gotten, no bonus
    _top.boxes[0].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _top.boxes[1].use(<Die>[Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 2), Die(value: 4)]);
    _top.boxes[2].use(<Die>[Die(value: 3), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _top.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 6), Die(value: 4), Die(value: 1)]);
    _top.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    _top.boxes[5].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('_top - no bonus');
    print(_top);

    // Gotten, bonus
    _top.boxes[0].use(<Die>[Die(value: 1), Die(value: 1), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _top.boxes[1].use(<Die>[Die(value: 2), Die(value: 2), Die(value: 6), Die(value: 2), Die(value: 4)]);
    _top.boxes[2].use(<Die>[Die(value: 3), Die(value: 3), Die(value: 3), Die(value: 1), Die(value: 4)]);
    _top.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 4), Die(value: 4), Die(value: 1)]);
    _top.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 5), Die(value: 5), Die(value: 4)]);
    _top.boxes[5].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );

    print('_top - with bonus');
    print(_top);
  }

  testBottom() {
    // None gotten
    _bottom.boxes[0].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _bottom.boxes[1].use(<Die>[Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 2), Die(value: 4)]);
    _bottom.boxes[2].use(<Die>[Die(value: 3), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _bottom.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 6), Die(value: 4), Die(value: 1)]);
    _bottom.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    _bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('_bottom - none');
    print(_bottom);

    // Gotten
    _bottom.boxes[0].use(<Die>[Die(value: 1), Die(value: 1), Die(value: 6), Die(value: 1), Die(value: 4)]);
    _bottom.boxes[1].use(<Die>[Die(value: 2), Die(value: 2), Die(value: 2), Die(value: 2), Die(value: 4)]);
    _bottom.boxes[2].use(<Die>[Die(value: 3), Die(value: 3), Die(value: 3), Die(value: 4), Die(value: 4)]);
    _bottom.boxes[3].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 3), Die(value: 4), Die(value: 3)]);
    _bottom.boxes[4].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 3), Die(value: 4), Die(value: 5)]);
    _bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)]);
    _bottom.boxes[6].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('_bottom - all');
    print(_bottom);

    // Gotten
    _bottom.boxes[0].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    _bottom.boxes[1].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    _bottom.boxes[2].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    _bottom.boxes[3].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    _bottom.boxes[4].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    _bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)]);
    _bottom.boxes[6].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );

    print('_bottom - all yahtzees');
    print(_bottom);
  }
}