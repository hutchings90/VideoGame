import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/SumYahtzeeBox.dart';

class ChanceYahtzeeBox extends SumYahtzeeBox {
  static const int KEEP_THRESHOLD = 4;

  String get name => 'Chance';
  int get scorePotential => 6 * 5;

  bool canUse(List<Die> dice) {
    return true;
  }
  
  List<Die> diceToKeep(List<Die> dice) {
    return dice.where((Die die) => die.value >= KEEP_THRESHOLD).toList();
  }
  
  List<Die> diceToRoll(List<Die> dice) {
    return dice.where((Die die) => die.value < KEEP_THRESHOLD).toList();
  }
}