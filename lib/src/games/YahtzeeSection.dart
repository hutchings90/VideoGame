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
    return _yahtzeeBoxByScoreCompare(dice, usableBoxes.where((YahtzeeBox yahtzeeBox) => yahtzeeBox.canUse(dice)).toList(), true);
  }

  YahtzeeBox throwAwayYahtzeeBox(List<Die> dice) {
    return _yahtzeeBoxByScoreCompare(dice, usableBoxes, false);
  }

  YahtzeeBox _yahtzeeBoxByScoreCompare(List<Die> dice, List<YahtzeeBox> yahtzeeBoxes, bool greaterThan) {
    YahtzeeBox yahtzeeBox;

    if (yahtzeeBoxes.length > 0) yahtzeeBox = yahtzeeBoxes.reduce((YahtzeeBox prev, YahtzeeBox cur) => (greaterThan == cur.diceScore(dice) > prev.diceScore(dice)) ? cur : prev);

    return yahtzeeBox;
  }
}