import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class NumberYahtzeeBox extends YahtzeeBox {
  final int value;

  NumberYahtzeeBox(this.value, name) : super(name);

  int get score => myDice.fold(0, (int sum, Die die) => sum + (value == die.value ? die.value : 0));

  bool canUse(List<Die> dice) {
    return null != dice.firstWhere((Die die) => die.value == value, orElse: () => null);
  }
}