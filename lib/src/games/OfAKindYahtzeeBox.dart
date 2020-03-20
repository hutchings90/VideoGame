import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/SumYahtzeeBox.dart';

abstract class OfAKindYahtzeeBox extends SumYahtzeeBox {
  final int _min;
  final String _namePrefix;

  OfAKindYahtzeeBox(this._min, this._namePrefix) : super();

  String get name => _namePrefix + ' of a Kind';
  int get scorePotential => 6 * 5;

  bool canUse(List<Die> dice) {
    return null != dice.fold(Map<int, int>(), (Map<int, int> reduction, Die die) {
      reduction.update(
        die.value,
        (existingValue) => existingValue + 1,
        ifAbsent: () => 1
      );

      return reduction;
    }).values.firstWhere((int value) => value >= _min, orElse: () => null);
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

    List<Die> losers = <Die>[];
    List<Die> keepers = diceByValue.values.reduce((List<Die> prev, List<Die> cur) => cur.length > prev.length || (cur.length == prev.length && cur.first.value > prev.first.value) ? cur : prev);

    if (keepers.length < _min) losers.addAll(dice.where((Die die) => die.value > keepers.first.value));
    else keepers.addAll(dice.where((Die die) => die.value > keepers.first.value));

    losers.addAll(dice.where((Die die) => die.value < keepers.first.value));

    return returnKeepers ? keepers : losers;
  }
}