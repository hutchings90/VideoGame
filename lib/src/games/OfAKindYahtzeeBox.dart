import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/SumYahtzeeBox.dart';

abstract class OfAKindYahtzeeBox extends SumYahtzeeBox {
  final int min;

  OfAKindYahtzeeBox(this.min, name) : super(name + ' of a Kind');

  bool canUse(List<Die> dice) {
    return null != dice.fold(Map<int, int>(), (Map<int, int> reduction, Die die) {
      reduction.update(
        die.value,
        (existingValue) => existingValue + 1,
        ifAbsent: () => 1
      );

      return reduction;
    }).values.firstWhere((int value) => value >= min, orElse: () => null);
  }

  List<Die> diceToKeep(List<Die> dice) {
    return _processDiceFit(dice, true);
  }

  List<Die> diceToRoll(List<Die> dice) {
    return _processDiceFit(dice, false);
  }

  List<Die> _processDiceFit(List<Die> dice, bool returnKeepers) {
    Map<int, List<Die>> diceByValue = dice.fold({}, (Map<int, List<Die>> diceSoFar, Die die) {
      diceSoFar.update(
        die.value,
        (List<Die> existingDice) {
          existingDice.add(die);

          return existingDice;
        },
        ifAbsent: () => <Die>[die]
      );

      return diceSoFar;
    });

    int maxLength = 0;
    int keepersKey;
    List<Die> keepers = <Die>[];
    List<Die> losers = <Die>[];

    diceByValue.values.forEach((List<Die> diceGroup) {
      if (diceGroup.length > maxLength || (diceGroup.length == maxLength && diceGroup[0].value > keepers[0].value)) {
        maxLength = diceGroup.length;
        keepersKey = diceGroup[0].value;
        keepers = diceGroup;
      }
    });

    if (keepers.length < min) losers.addAll(dice.where((Die die) => die.value > keepersKey));
    else keepers.addAll(dice.where((Die die) => die.value > keepersKey));

    losers.addAll(dice.where((Die die) => die.value < keepersKey));

    // This is a good enough approach for version 1.0, but
    // here are some other thoughts about choosing which
    // dice to keep and which to roll again.

    // Instead of using the current way of determining which
    // dice to add to the keepers and losers, keep the dice
    // that are more likely to decrease if rolled again and
    // roll dice that are more likely to increase if rolled
    // again.

    // Another thought it to roll all dice that could increase,
    // and keeping dice with the highest value that occurs
    // frequently.

    return returnKeepers ? keepers : losers;
  }
}