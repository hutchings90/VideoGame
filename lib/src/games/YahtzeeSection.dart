import 'package:playing_around/src/games/YahtzeeBox.dart';

abstract class YahtzeeSection {
  List<YahtzeeBox> boxes = <YahtzeeBox>[];

  int get score;

  @override
  String toString() {
    return boxes.toString();
  }
}