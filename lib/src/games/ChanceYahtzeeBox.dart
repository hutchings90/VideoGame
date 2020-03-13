import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/SumYahtzeeBox.dart';

class ChanceYahtzeeBox extends SumYahtzeeBox {
  ChanceYahtzeeBox() : super('Chance');

  bool canUse(List<Die> dice) {
    return true;
  }
  
  List<Die> diceToKeep(List<Die> dice) {
    return dice.where((Die die) => die.value > 3).toList();
  }
  
  List<Die> diceToRoll(List<Die> dice) {
    return dice.where((Die die) => die.value < 4).toList();
  }
}