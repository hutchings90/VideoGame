import 'package:playing_around/src/games/Die.dart';

abstract class YahtzeeBox {
  String name = '';
  List<Die> myDice = <Die>[];
  bool isBonusYahtzee = false;

  int diceScore(List<Die> dice);
  bool canUse(List<Die> dice);
  List<Die> diceToKeep(List<Die> dice);
  List<Die> diceToRoll(List<Die> dice);

  int get score => diceScore(myDice);
  bool get used => myDice.length > 0;

  YahtzeeBox(this.name);

  use(List<Die> dice, {bool asBonusYahtzee=false}) {
    myDice = dice.map((Die die) => Die.fromDie(die)).toList();
    isBonusYahtzee = asBonusYahtzee;
  }

  Map<String, List<Die>> diceFit(List<Die> dice) {
    return {
      'keep': diceToKeep(dice),
      'roll': diceToRoll(dice)
    };
  }

  @override
  String toString() {
    return name + ': ' + score.toString() + ' ' + myDice.toString();
  }
}