import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/Yahtzee.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class YahtzeeYahtzeeBox extends YahtzeeBox {
  static const SCORE = 50;

  int get score => canUse(myDice) ? SCORE : 0;

  bool canUse(List<Die> dice) {
    return Yahtzee.isYahtzee(dice);
  }
}