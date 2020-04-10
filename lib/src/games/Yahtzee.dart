import 'dart:async';

import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/NumberYahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeBottom.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeTop.dart';
import 'package:playing_around/src/games/YahtzeeYahtzeeBox.dart';

class Yahtzee {
  static const int BONUS_YAHTZEE_SCORE = 100;
  static const int ROLL_DELAY = 5;
  static const int TURN_DELAY = 2;
  static const int ROLLS_PER_TURN = 3;

  int _turnCount, _rollCount;
  YahtzeeTop _top = YahtzeeTop();
  YahtzeeBottom _bottom = YahtzeeBottom();
  List<Die> _diceToRoll = <Die>[Die(), Die(), Die(), Die(), Die()];
  List<Die> _diceToKeep = <Die>[];
  YahtzeeBox _pickedYahtzeeBox;
  Timer _turnTimer, _rollTimer;

  final Map<String, dynamic> player;
  final Function(Yahtzee) onYahtzee, onBonusYahtzee, onGameEnd;

  Yahtzee(this.player, {this.onYahtzee, this.onBonusYahtzee, this.onGameEnd});

  int get score => _top.score + _bottom.score + _bonusYahtzeeScore;

  YahtzeeBox get pickedYahtzeeBox => _pickedYahtzeeBox;
  bool get _rollSucceeded => _pickedYahtzeeBox.score > 0;
  bool get _turnOver => _rollCount >= ROLLS_PER_TURN || _diceToRoll.length < 1;
  List<YahtzeeBox> get _allBoxes => _top.boxes + _bottom.boxes;
  List<YahtzeeBox> get _unusedBoxes => _top.unusedBoxes + _bottom.unusedBoxes;
  int get _boxCount => _allBoxes.length;
  bool get gameOver => _turnCount >= _boxCount;
  int get _bonusYahtzeeCount => _allBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.isBonusYahtzee).toList().length;
  int get _bonusYahtzeeScore => _yahtzeeYahtzeeBox.score == 0 ? 0 : (BONUS_YAHTZEE_SCORE * _bonusYahtzeeCount);
  List<Die> get allDice => _diceToRoll + _diceToKeep;
  List<Die> get diceToRoll => _diceToRoll;
  List<Die> get diceToKeep => _diceToKeep;
  bool get _rolledYahtzee => allDice.every((Die die) => die.value == allDice.first.value);
  int get rollCount => _rollCount;
  YahtzeeBox get _yahtzeeYahtzeeBox => _bottom.yahtzeeYahtzeeBox;
  bool get usedYahtzee => _yahtzeeYahtzeeBox.used;
  bool get gotYahtzee => _yahtzeeYahtzeeBox.score > 0;
  YahtzeeBox get _throwAwayYahtzeeBox => _unusedBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => cur.diceScore(allDice) > prev.diceScore(allDice) ? cur : prev);

  YahtzeeBox get _mostValuableYahtzeeBox {
    List<YahtzeeBox> yahtzeeBoxes;

    if (_rolledYahtzee) {
      NumberYahtzeeBox numberYahtzeeBox;
      YahtzeeBox preferredBottomBox;

      if (!usedYahtzee) return _yahtzeeYahtzeeBox;

      numberYahtzeeBox = _top.boxOfValue(allDice.first.value);
      if (!numberYahtzeeBox.used) return numberYahtzeeBox;

      preferredBottomBox = _bottom.preferredWildcardBox;
      if (preferredBottomBox != null) return preferredBottomBox;

      return _top.leastValuableAvailableBox;
    }

    yahtzeeBoxes = _unusedBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.canUse(allDice)).toList();

    if (yahtzeeBoxes.length < 1) return null;
    return yahtzeeBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => cur.diceScore(allDice) > prev.diceScore(allDice) ? cur : prev);
  }

  YahtzeeBox get _diceSeparatorYahtzeeBox {
    int minRollCount;

    if (_rolledYahtzee) return _yahtzeeYahtzeeBox;

    minRollCount = allDice.length + 1;

    return _unusedBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) {
      int curRollCount = cur.diceToRoll(allDice).length;

      if (curRollCount < minRollCount) {
        minRollCount = curRollCount;
        return cur;
      }
      if (curRollCount == minRollCount && cur.diceScore(allDice) > prev.diceScore(allDice)) return cur;
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

  start() async {
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
    List<Die> dice = List.from(allDice);
    YahtzeeBox yahtzeeBox = _diceSeparatorYahtzeeBox;

    _diceToKeep = yahtzeeBox.diceToKeep(dice);
    _diceToRoll = yahtzeeBox.diceToRoll(dice);
  }

  _useYahtzeeBox() {
    _pickedYahtzeeBox = _mostValuableYahtzeeBox;

    if (_pickedYahtzeeBox == null) _pickedYahtzeeBox = _throwAwayYahtzeeBox;

    _pickedYahtzeeBox.use(allDice, asBonusYahtzee: _rolledYahtzee && usedYahtzee);
  }

  _endRoll() {
    _turnOver ? _processTurn() : _nextRoll();
  }

  _processTurn() {
    _reportTurn();
    _endTurn();
  }

  _reportTurn() {
    if (_rollSucceeded) {
      if (_pickedYahtzeeBox.runtimeType == YahtzeeYahtzeeBox) {
        if (onYahtzee != null) onYahtzee(this);
      }
      else if (_pickedYahtzeeBox.isBonusYahtzee) {
        if (onBonusYahtzee != null) onBonusYahtzee(this);
      }
    }
  }

  _endTurn() {
    gameOver ? _endGame() : _nextTurn();
  }

  _endGame() {
    if (onGameEnd != null) onGameEnd(this);
  }

  _nextTurn() {
    _turnTimer = Timer(Duration(seconds: TURN_DELAY), () => _takeTurn());
  }

  _nextRoll() {
    _rollTimer = Timer(Duration(seconds: ROLL_DELAY), () => _roll());
  }

  stop() {
    if (_turnTimer != null) _turnTimer.cancel();
    if (_rollTimer != null) _rollTimer.cancel();
  }
}