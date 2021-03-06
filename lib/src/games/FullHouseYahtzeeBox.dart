import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/Die.dart';

class FullHouseYahtzeeBox extends YahtzeeBox {
  static const int SCORE = 25;

  FullHouseYahtzeeBox() : super();

  String get name => 'Full House';
  int get scorePotential => SCORE;

  int diceScore(List<Die> dice) {
    return isBonusYahtzee || canUse(dice) ? SCORE : 0;
  }

  bool canUse(List<Die> dice) {
    List<int> values = dice.fold(Map<int, int>(), (Map<int, int> reduction, Die die) {
      reduction.update(
        die.value,
        (existingValue) => existingValue + 1,
        ifAbsent: () => 1
      );

      return reduction;
    }).values.toList();

    if (values.length != 2) return false;

    return (values.first == 2 && values[1] == 3) || (values.first == 3 || values[1] == 2);
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

    List<List<Die>> diceGroups = diceByValue.values.toList();
    List<List<Die>> validDiceGroups = diceGroups.where((List<Die> value) => value.length > 1).toList();
    List<List<Die>> otherDiceGroups = diceGroups.where((List<Die> value) => value.length < 2).toList();

    List<Die> losers = otherDiceGroups.expand((List<Die> others) => others).toList();
    List<Die> keepers = validDiceGroups.fold(<Die>[], (List<Die> diceSoFar, List<Die> diceOfValue) {
      if (diceOfValue.length <= 3) diceSoFar.addAll(diceOfValue);
      else {
        diceSoFar.addAll(diceOfValue.getRange(0, 3));
        losers.insertAll(0, diceOfValue.sublist(3));
      }

      return diceSoFar;
    });

    if (keepers.length < 1) keepers = <Die>[losers.removeLast(), losers.removeLast()];
    else if (validDiceGroups.length < 2 && diceGroups.length > 1) keepers.add(losers.removeLast());

    return returnKeepers ? keepers : losers;
  }
}