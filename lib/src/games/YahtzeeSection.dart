import 'package:playing_around/src/games/YahtzeeBox.dart';

abstract class YahtzeeSection {
  final List<YahtzeeBox> boxes;

  YahtzeeSection(this.boxes);

  int get score => boxes.fold(0, (int sum, YahtzeeBox box) => sum + box.score);
  List<YahtzeeBox> get unusedBoxes => boxes.where((YahtzeeBox box) => !box.used).toList();

  @override
  String toString() {
    return boxes.fold(<String>[], (List<String> strings, YahtzeeBox box) {
      strings.add(box.toString());

      return strings;
    }).join('\n');
  }
}