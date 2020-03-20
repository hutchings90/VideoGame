import 'package:playing_around/src/games/Die.dart';

abstract class YahtzeeBox {
  List<Die> _myDice = <Die>[];
  bool _isBonusYahtzee = false;

  String get name;
  int get scorePotential;

  int diceScore(List<Die> dice);
  bool canUse(List<Die> dice);
  List<Die> diceToKeep(List<Die> dice);
  List<Die> diceToRoll(List<Die> dice);

  int get score => diceScore(_myDice);
  bool get used => _myDice.length > 0;
  bool get isBonusYahtzee => _isBonusYahtzee;

  YahtzeeBox();

  use(List<Die> dice, {bool asBonusYahtzee=false}) {
    _myDice = dice.map((Die die) => Die.fromDie(die)).toList();
    _isBonusYahtzee = asBonusYahtzee;
  }

  @override
  String toString() {
    return name + ': ' + score.toString() + ' ' + _myDice.toString() + (_isBonusYahtzee ? ' (Bonus Yahtzee)' : '');
  }
}