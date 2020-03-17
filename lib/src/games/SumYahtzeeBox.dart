import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

abstract class SumYahtzeeBox extends YahtzeeBox {
  SumYahtzeeBox(name) : super(name);

  int diceScore(List<Die> dice) {
    return canUse(dice) ? dice.fold(0, (int sum, Die die) => sum + die.value) : 0;
  }
}