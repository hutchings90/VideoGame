import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class NumberYahtzeeBox extends YahtzeeBox {
  final int value;

  NumberYahtzeeBox(this.value, name) : super(name);

  int diceScore(List<Die> dice) {
    return dice.fold(0, (int sum, Die die) => sum + (value == die.value ? die.value : 0));
  }

  bool canUse(List<Die> dice) {
    return null != dice.firstWhere((Die die) => die.value == value, orElse: () => null);
  }

  List<Die> diceToKeep(List<Die> dice) {
    return dice.where((Die die) => value == die.value).toList();
  }

  List<Die> diceToRoll(List<Die> dice) {
    return dice.where((Die die) => value != die.value).toList();
  }
}