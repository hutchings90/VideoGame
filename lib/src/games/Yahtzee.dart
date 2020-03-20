import 'dart:async';

import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/NumberYahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeBottom.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeTop.dart';
import 'package:playing_around/src/games/YahtzeeYahtzeeBox.dart';

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

  int get score => _top.score + _bottom.score + _bonusYahtzeeScore;

  bool get _rollSucceeded => _pickedYahtzeeBox.score > 0;
  bool get _turnOver => _rollCount >= ROLLS_PER_TURN || _diceToRoll.length < 1;
  List<YahtzeeBox> get _allBoxes => _top.boxes + _bottom.boxes;
  List<YahtzeeBox> get _unusedBoxes => _top.unusedBoxes + _bottom.unusedBoxes;
  int get _boxCount => _allBoxes.length;
  bool get _gameOver => _turnCount >= _boxCount;
  int get _bonusYahtzeeCount => _allBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.isBonusYahtzee).toList().length;
  int get _bonusYahtzeeScore => BONUS_YAHTZEE_SCORE * _bonusYahtzeeCount;
  List<Die> get _allDice => _diceToRoll + _diceToKeep;
  bool get _rolledYahtzee => _allDice.every((Die die) => die.value == _allDice.first.value);
  bool get _alreadyScoredYahtzee => _bottom.scoredYahtzee;
  bool get _checkBonusYahtzee => _rolledYahtzee && _alreadyScoredYahtzee;
  YahtzeeBox get _throwAwayYahtzeeBox => _unusedBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => cur.diceScore(_allDice) > prev.diceScore(_allDice) ? cur : prev);

  YahtzeeBox get _mostValuableYahtzeeBox {
    List<YahtzeeBox> yahtzeeBoxes;

    if (_rolledYahtzee) {
      NumberYahtzeeBox numberYahtzeeBox = _top.boxOfValue(_allDice.first.value);

      if (!_alreadyScoredYahtzee) return _bottom.yahtzeeYahtzeeBox;
      if (!numberYahtzeeBox.used) return numberYahtzeeBox;
    }

    yahtzeeBoxes = _unusedBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.canUse(_allDice)).toList();

    if (yahtzeeBoxes.length < 1) return null;
    return yahtzeeBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => cur.diceScore(_allDice) > prev.diceScore(_allDice) ? cur : prev);
  }

  YahtzeeBox get _diceSeparatorYahtzeeBox {
    int minRollCount = _allDice.length + 1;

    if (_checkBonusYahtzee) return _bottom.yahtzeeYahtzeeBox;

    return _unusedBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) {
      int curRollCount = cur.diceToRoll(_allDice).length;

      if (curRollCount < minRollCount) {
        minRollCount = curRollCount;
        return cur;
      }
      if (curRollCount == minRollCount && cur.diceScore(_allDice) > prev.diceScore(_allDice)) return cur;
      return prev;
    });
  }

  @override
  String toString() {
    return <String>[
      _top.toString(),
      _bottom.toString(),
      'Bonus Yahtzees: ' + _bonusYahtzeeScore.toString(),
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
    List<Die> dice = List.from(_allDice);
    YahtzeeBox yahtzeeBox = _diceSeparatorYahtzeeBox;

    _diceToKeep = yahtzeeBox.diceToKeep(dice);
    _diceToRoll = yahtzeeBox.diceToRoll(dice);
  }

  _useYahtzeeBox() {
    bool asBonusYahtzee = false;
    _pickedYahtzeeBox = _mostValuableYahtzeeBox;

    if (_pickedYahtzeeBox == null) _pickedYahtzeeBox = _throwAwayYahtzeeBox;
    else if (_checkBonusYahtzee && _pickedYahtzeeBox.runtimeType == NumberYahtzeeBox && _allDice.first.value == (_pickedYahtzeeBox as NumberYahtzeeBox).value) asBonusYahtzee = true;

    _pickedYahtzeeBox.use(_allDice, asBonusYahtzee: asBonusYahtzee);
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

      if (_pickedYahtzeeBox.runtimeType == YahtzeeYahtzeeBox) {
        if (onYahtzee != null) onYahtzee(_pickedYahtzeeBox);
      }
      else if (_pickedYahtzeeBox.isBonusYahtzee) {
        if (onBonusYahtzee != null) onBonusYahtzee(_pickedYahtzeeBox);
      }
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
}