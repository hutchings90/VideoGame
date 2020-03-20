import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

class NumberYahtzeeBox extends YahtzeeBox {
  final int _value;
  final String _displayName;

  NumberYahtzeeBox(this._value, this._displayName);

  String get name => _displayName;
  int get scorePotential => _value * 5;
  int get value => _value;

  int diceScore(List<Die> dice) {
    return dice.fold(0, (int sum, Die die) => sum + (_value == die.value ? die.value : 0));
  }

  bool canUse(List<Die> dice) {
    return null != dice.firstWhere((Die die) => die.value == _value, orElse: () => null);
  }

  List<Die> diceToKeep(List<Die> dice) {
    return dice.where((Die die) => _value == die.value).toList();
  }

  List<Die> diceToRoll(List<Die> dice) {
    return dice.where((Die die) => _value != die.value).toList();
  }
}