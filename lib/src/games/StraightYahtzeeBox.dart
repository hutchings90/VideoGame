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
    // TODO: Implement
    return dice;
  }

  List<Die> diceToRoll(List<Die> dice) {
    // TODO: Implement
    return dice;
  }
}