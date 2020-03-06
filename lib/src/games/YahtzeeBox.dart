import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/Yahtzee.dart';

abstract class YahtzeeBox {
  List<Die> myDice = <Die>[];
  bool isBonusYahtzee = false;

  int get score;
  bool canUse(List<Die> dice);

  bool get used => myDice.length == Yahtzee.DICE_COUNT;

  use(List<Die> dice, {bool asBonusYahtzee=false}) {
    myDice = List.from(dice);
    isBonusYahtzee = asBonusYahtzee;
  }

  @override
  String toString() {
    return score.toString();
  }
}