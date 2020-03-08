import 'package:playing_around/src/games/NumberYahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeSection.dart';

class YahtzeeTop extends YahtzeeSection {
  static const int BONUS_THRESHOLD = 63;
  static const int BONUS_VALUE = 35;

  YahtzeeTop() {
    boxes = <YahtzeeBox>[
      NumberYahtzeeBox(1, 'Ones'),
      NumberYahtzeeBox(2, 'Twos'),
      NumberYahtzeeBox(3, 'Threes'),
      NumberYahtzeeBox(4, 'Fours'),
      NumberYahtzeeBox(5, 'Fives'),
      NumberYahtzeeBox(6, 'Sixes'),
    ];
  }

  int get scorePreBonus => boxes.fold(0, (sum, box) => sum + box.score);
  bool get getsBonus => scorePreBonus >= BONUS_THRESHOLD;
  int get bonus => getsBonus ? BONUS_VALUE : 0;
  int get score => scorePreBonus + bonus;

  @override
  String toString() {
    return super.toString() + ', ' + getsBonus.toString();
  }
}