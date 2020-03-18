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
  final Function(List<Die> diceToKeep, List<Die> diceToRoll) onRollAgain;
  final Function(Yahtzee yahtzee) onGameEnd;

  Yahtzee({this.onRollSuccess, this.onTurnSuccess, this.onYahtzee, this.onBonusYahtzee, this.onRollFail, this.onTurnFail, this.onRollAgain, this.onGameEnd});

  int get score => _top.score + _bottom.score;

  bool get _rollSucceeded => _pickedYahtzeeBox.score > 0;
  bool get _turnOver => _rollCount >= ROLLS_PER_TURN || _diceToRoll.length < 1;
  List<YahtzeeBox> get _allBoxes => _top.boxes + _bottom.boxes;
  List<YahtzeeBox> get _allUsableBoxes => _top.usableBoxes + _bottom.usableBoxes;
  int get _boxCount => _allBoxes.length;
  bool get _gameOver => _turnCount >= _boxCount;
  List<YahtzeeBox> get _bonusYahtzeeBoxes => _allBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.isBonusYahtzee).toList();
  List<int> get _bonusYahtzeeNumbers => _bonusYahtzeeBoxes.map((YahtzeeBox yahtzeeBox) => yahtzeeBox.myDice[0].value).toList();
  int get _bonusYahtzeeCount => _bonusYahtzeeBoxes.length;
  int get _bonusYahtzeeScore => BONUS_YAHTZEE_SCORE * _bonusYahtzeeCount;
  List<Die> get _allDice => _diceToRoll + _diceToKeep;
  YahtzeeBox get _mostValuableYahtzeeBox => _yahtzeeBoxByScoreCompare(_allUsableBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.canUse(_allDice)).toList(), true);
  YahtzeeBox get _throwAwayYahtzeeBox => _yahtzeeBoxByScoreCompare(_allUsableBoxes, false);

  YahtzeeBox _yahtzeeBoxByScoreCompare(List<YahtzeeBox> yahtzeeBoxes, bool greaterThan) {
    YahtzeeBox yahtzeeBox;

    if (yahtzeeBoxes.length > 0) yahtzeeBox = yahtzeeBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => (greaterThan == cur.diceScore(_allDice) > prev.diceScore(_allDice)) ? cur : prev);

    return yahtzeeBox;
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
    _diceToRoll.addAll(_diceToKeep);
    _diceToKeep = <Die>[];
  }

  _roll() {
    _rollDice();
    _processRoll();
    _reportRoll();
    _endRoll();
  }

  _rollDice() {
    _rollCount++;
    _diceToRoll.forEach((Die die) => die.roll());
  }

  _processRoll(){
    _separateDice();

    if (_turnOver) _useYahtzeeBox();
  }

  _separateDice() {
    YahtzeeBox yahtzeeBox;
    List<Die> dice = List.from(_allDice);
    int minDieCount = dice.length + 1;
    List<YahtzeeBox> yahtzeeBoxes = _allUsableBoxes.fold(<YahtzeeBox>[], (List<YahtzeeBox> yahtzeeBoxes, YahtzeeBox yahtzeeBox) {
      int dieCount = yahtzeeBox.diceToRoll(dice).length;

      if (dieCount <= minDieCount) {
        if (dieCount < minDieCount) {
          yahtzeeBoxes = <YahtzeeBox>[];
          minDieCount = dieCount;
        }

        yahtzeeBoxes.add(yahtzeeBox);
      }

      return yahtzeeBoxes;
    }).toList();

    if (minDieCount == 0) yahtzeeBox = yahtzeeBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => cur.diceScore(dice) > prev.diceScore(dice) ? cur : prev);
    else yahtzeeBox = yahtzeeBoxes.last; // TODO: Pick one, considering score potential and probability ???

    _diceToKeep = yahtzeeBox.diceToKeep(dice);
    _diceToRoll = yahtzeeBox.diceToRoll(dice);

    if (_allDice.length != 5) print('separated by:\t' + yahtzeeBox.toString());
  }

  _useYahtzeeBox() {
    _pickedYahtzeeBox = _mostValuableYahtzeeBox;

    if (_pickedYahtzeeBox == null) _pickedYahtzeeBox = _throwAwayYahtzeeBox;

    _pickedYahtzeeBox.use(_allDice);
  }

  _reportRoll() {
    if (!_turnOver) {
      if (onRollAgain != null) onRollAgain(_diceToKeep, _diceToRoll);
    }
    else if (_rollSucceeded) {
      if (onRollSuccess != null) onRollSuccess(_pickedYahtzeeBox);
    }
    else if (onRollFail != null) onRollFail(_allDice);
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
    if (_rollSucceeded) {
      if (onTurnSuccess != null) onTurnSuccess(_pickedYahtzeeBox);
    }
    else if (onTurnFail != null) onTurnFail(_allDice);
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