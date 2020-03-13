import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class StraightYahtzeeBox extends YahtzeeBox {
  final int min, potentialScore;

  StraightYahtzeeBox(this.min, this.potentialScore, name) : super(name + ' Straight');

  int get score => isBonusYahtzee || canUse(myDice) ? potentialScore : 0;

  bool canUse(List<Die> dice) {
    Map<int, bool> usedValues = Map<int, bool>();
    List<int> values = dice.fold(List<int>(), (List<int> total, Die die) {
      int value = die.value;

      if (!usedValues.containsKey(value)) {
        total.add(value);
        usedValues[value] = true;
      }

      return total;
    });

    values.sort();

    for (int i = 0; i < values.length - min + 1;) {
      List<int> range = values.getRange(i, i + min).toList();
      int breakIndex = _sequenceBreakIndex(range);

      if (breakIndex == range.length) return true;

      i = i + breakIndex;
    }

    return false;
  }

  int _sequenceBreakIndex(List<int> values) {
    if (values.length > 0) {
      int firstValue = values[0];

      for (int i = 1; i < values.length; i++) {
        if (values[i] != firstValue + i) return i;
      }
    }

    return values.length;
  }

  List<Die> diceToKeep(List<Die> dice) {
    return _processDiceFit(dice, true);
  }

  List<Die> diceToRoll(List<Die> dice) {
    return _processDiceFit(dice, false);
  }

  List<Die> _processDiceFit(List<Die> dice, bool returnKeepers) {
    int outerLoopEnd = dice.length - min;
    List<Die> bestKeepers = <Die>[];
    List<Die> bestLosers = <Die>[];
    List<Die> keepers = <Die>[];
    List<Die> losers = <Die>[];

    dice.sort();

    for (int i = 0; i <= outerLoopEnd && i < dice.length; i++) {
      Die die = dice[i];
      int prevValue = die.value;
      int limit = die.value + min - 1;
      int innerLoopEnd = limit;

      keepers.add(die);

      if (i > 0) losers.addAll(dice.getRange(0, i));

      for (int j = i + 1; j < innerLoopEnd && j < dice.length; j++) {
        Die die = dice[j];

        if (die.value == prevValue) {
          innerLoopEnd++;
          outerLoopEnd++;
          losers.add(die);
        }
        else if (die.value > limit) losers.add(die);
        else keepers.add(die);

        prevValue = die.value;
      }

      if (innerLoopEnd < dice.length) losers.addAll(dice.sublist(innerLoopEnd));

      if (keepers.length > bestKeepers.length) {
        bestKeepers = keepers;
        bestLosers = losers;
      }

      keepers = <Die>[];
      losers = <Die>[];
    }

    if (bestKeepers.length >= min) {
      bestKeepers = dice;
      bestLosers = <Die>[];
    }

    return returnKeepers ? bestKeepers : bestLosers;
  }
}