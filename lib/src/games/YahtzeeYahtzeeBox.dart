import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class YahtzeeYahtzeeBox extends YahtzeeBox {
  static const int SCORE = 50;

  String get name => 'Yahtzee';
  int get scorePotential => SCORE;

  int diceScore(List<Die> dice) {
    return canUse(dice) ? SCORE : 0;
  }

  bool canUse(List<Die> dice) {
    return dice.length > 1 && dice.every((Die die) => die.value == dice.first.value);
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
    Map<int, int> valueFrequencies = Map<int, int>();

    return dice.fold(null, (int frequentValue, Die die) {
      int highestFrequency = valueFrequencies[frequentValue];
      int dieFrequency = valueFrequencies.update(
        die.value,
        (int existing) => existing + 1,
        ifAbsent: () => 1
      );

      return null == highestFrequency || dieFrequency > highestFrequency ? die.value : frequentValue;
    });
  }
}