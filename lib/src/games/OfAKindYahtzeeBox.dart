import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/SumYahtzeeBox.dart';

abstract class OfAKindYahtzeeBox extends SumYahtzeeBox {
  final int min;

  OfAKindYahtzeeBox(this.min, name) : super(name + ' of a Kind');

  // TODO: This does not seem to be working.
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
}