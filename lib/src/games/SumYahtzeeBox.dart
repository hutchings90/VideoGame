import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

abstract class SumYahtzeeBox extends YahtzeeBox {
  int get score => canUse(myDice) ? myDice.fold(0, (int sum, Die die) => sum + die.value) : 0;

  SumYahtzeeBox(name) : super(name);
}