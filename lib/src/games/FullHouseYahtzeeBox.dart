import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/Die.dart';

class FullHouseYahtzeeBox extends YahtzeeBox {
  static const SCORE = 25;

  int get score => isBonusYahtzee || canUse(myDice) ? SCORE : 0;

  bool canUse(List<Die> dice) {
    List<int> values = myDice.fold(Map<int, int>(), (Map<int, int> reduction, Die die) {
      reduction.update(
        die.value,
        (existingValue) => existingValue + 1,
        ifAbsent: () => 1
      );

      return reduction;
    }).values.toList();

    if (values.length != 2) return false;

    return (values[0] == 2 && values[1] == 3) || (values[0] == 3 || values[1] == 2);
  }
}