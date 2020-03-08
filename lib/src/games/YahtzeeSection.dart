import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

abstract class YahtzeeSection {
  List<YahtzeeBox> boxes = <YahtzeeBox>[];

  int get score;

  List<YahtzeeBox> get usableBoxes => boxes.where((YahtzeeBox box) => !box.used).toList();

  @override
  String toString() {
    return boxes.toString();
  }

  YahtzeeBox useDice(List<Die> dice) {
    YahtzeeBox yahtzeeBox = usableBoxes.firstWhere((YahtzeeBox yahtzeeBox) => yahtzeeBox.canUse(dice), orElse: () => null);

    if (yahtzeeBox != null) yahtzeeBox.use(dice);

    return yahtzeeBox;
  }
}