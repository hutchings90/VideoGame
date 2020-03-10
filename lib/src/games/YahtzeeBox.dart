import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/Yahtzee.dart';

abstract class YahtzeeBox {
  String name = '';
  List<Die> myDice = <Die>[];
  bool isBonusYahtzee = false;

  int get score;
  bool canUse(List<Die> dice);
  List<Die> diceToKeep(List<Die> dice);
  List<Die> diceToRoll(List<Die> dice);

  bool get used => myDice.length == Yahtzee.DICE_COUNT;

  YahtzeeBox(this.name);

  use(List<Die> dice, {bool asBonusYahtzee=false}) {
    myDice = dice.map((Die die) => Die.fromDie(die)).toList();
    isBonusYahtzee = asBonusYahtzee;
  }

  Map<String, List<Die>> diceFit(List<Die> dice) {
    return {
      'keep': diceToKeep(dice),
      'remove': diceToRoll(dice)
    };
  }

  @override
  String toString() {
    return name + ': ' + score.toString() + ' ' + myDice.toString();
  }
}