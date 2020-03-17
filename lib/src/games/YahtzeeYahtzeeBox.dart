import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class YahtzeeYahtzeeBox extends YahtzeeBox {
  static const SCORE = 50;

  YahtzeeYahtzeeBox() : super('Yahtzee');

  int diceScore(List<Die> dice) {
    return canUse(dice) ? SCORE : 0;
  }

  bool canUse(List<Die> dice) {
    return dice.length > 1 && dice.every((Die die) => die.value == dice[0].value);
  }

  List<Die> diceToKeep(List<Die> dice) {
    int mostFrequentValue = _mostFrequentDieValue(dice);

    return dice.where((Die die) => die.value == mostFrequentValue).toList();
  }

  List<Die> diceToRoll(List<Die> dice) {
    int mostFrequentValue = _mostFrequentDieValue(dice);

    return dice.where((Die die) => die.value != mostFrequentValue).toList();
  }

  _mostFrequentDieValue(List<Die> dice) {
    int mostFrequentValue = 0;
    Map<int, int> frequencies = Map<int, int>();

    dice.forEach((Die die) {
      frequencies.update(
        die.value,
        (int existing) => existing + 1,
        ifAbsent: () => 1
      );

      if (null == frequencies[mostFrequentValue] || frequencies[die.value] > frequencies[mostFrequentValue]) mostFrequentValue = die.value;
    });

    return mostFrequentValue;
  }
}