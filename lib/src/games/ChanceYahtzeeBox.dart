import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/SumYahtzeeBox.dart';

class ChanceYahtzeeBox extends SumYahtzeeBox {
  ChanceYahtzeeBox() : super('Chance');

  bool canUse(List<Die> dice) {
    return true;
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