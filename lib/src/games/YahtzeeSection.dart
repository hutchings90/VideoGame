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

  YahtzeeBox useDice(List<Die> dice) {
    YahtzeeBox yahtzeeBox = usableBoxes.firstWhere((YahtzeeBox yahtzeeBox) => yahtzeeBox.canUse(dice), orElse: () => null);

    if (yahtzeeBox != null) yahtzeeBox.use(dice);

    return yahtzeeBox;
  }
}