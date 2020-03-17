import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';

abstract class YahtzeeSection {
  List<YahtzeeBox> boxes = <YahtzeeBox>[];

  int get score => boxes.fold(0, (int sum, YahtzeeBox box) => sum + box.score);

  List<YahtzeeBox> get usableBoxes => boxes.where((YahtzeeBox box) => !box.used).toList();

  @override
  String toString() {
    return boxes.fold(<String>[], (List<String> strings, YahtzeeBox box) {
      strings.add(box.toString());

      return strings;
    }).join('\n');
  }

  YahtzeeBox mostValuableYahtzeeBox(List<Die> dice) {
    List<YahtzeeBox> yahtzeeBoxes = usableBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.canUse(dice)).toList();
    YahtzeeBox yahtzeeBox;

    if (yahtzeeBoxes.length > 0) yahtzeeBox = yahtzeeBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => cur.diceScore(dice) > prev.diceScore(dice) ? cur : prev);

    return yahtzeeBox;
  }
}