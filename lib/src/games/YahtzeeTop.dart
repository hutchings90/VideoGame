import 'package:playing_around/src/games/NumberYahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeSection.dart';

class YahtzeeTop extends YahtzeeSection {
  static const int BONUS_THRESHOLD = 63;
  static const int BONUS_VALUE = 35;

  YahtzeeTop() : super(<YahtzeeBox>[
      NumberYahtzeeBox(1, 'Ones'),
      NumberYahtzeeBox(2, 'Twos'),
      NumberYahtzeeBox(3, 'Threes'),
      NumberYahtzeeBox(4, 'Fours'),
      NumberYahtzeeBox(5, 'Fives'),
      NumberYahtzeeBox(6, 'Sixes'),
  ]);

  int get _scorePreBonus => super.score;
  bool get _getsBonus => _scorePreBonus >= BONUS_THRESHOLD;
  int get _bonus => _getsBonus ? BONUS_VALUE : 0;

  @override
  int get score => _scorePreBonus + _bonus;

  @override
  String toString() {
    return super.toString() + '\nBonus: ' + (_getsBonus ? BONUS_VALUE.toString() : '0');
  }

  NumberYahtzeeBox boxOfValue(int value) {
    return boxes.firstWhere((YahtzeeBox box) => (box as NumberYahtzeeBox).value == value) as NumberYahtzeeBox;
  }
}