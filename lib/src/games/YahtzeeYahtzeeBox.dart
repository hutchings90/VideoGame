import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/Yahtzee.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class YahtzeeYahtzeeBox extends YahtzeeBox {
  static const SCORE = 50;

  int get score => canUse(myDice) ? SCORE : 0;

  YahtzeeYahtzeeBox() : super('Yahtzee');

  bool canUse(List<Die> dice) {
    return Yahtzee.isYahtzee(dice);
  }

  List<Die> diceToKeep(List<Die> dice) {
    // TODO: Implement
    return dice;
  }

  List<Die> diceToRoll(List<Die> dice) {
    // TODO: Implement
    return dice;
  }
}