import 'package:playing_around/src/games/ChanceYahtzeeBox.dart';
import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/FourOfAKindYahtzeeBox.dart';
import 'package:playing_around/src/games/FullHouseYahtzeeBox.dart';
import 'package:playing_around/src/games/LargeStraightYahtzeeBox.dart';
import 'package:playing_around/src/games/SmallStraightYahtzeeBox.dart';
import 'package:playing_around/src/games/ThreeOfAKindYahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeSection.dart';
import 'package:playing_around/src/games/YahtzeeTop.dart';
import 'package:playing_around/src/games/YahtzeeYahtzeeBox.dart';

class YahtzeeBottom extends YahtzeeSection {
  static const int BONUS_YAHTZEE_SCORE = 100;

  YahtzeeTop top;

  YahtzeeBottom(this.top) {
    boxes = <YahtzeeBox>[
      ThreeOfAKindYahtzeeBox(),
      FourOfAKindYahtzeeBox(),
      FullHouseYahtzeeBox(),
      SmallStraightYahtzeeBox(),
      LargeStraightYahtzeeBox(),
      YahtzeeYahtzeeBox(),
      ChanceYahtzeeBox()
    ];
  }

  List<YahtzeeBox> get allBoxes {
    List<YahtzeeBox> combined = List.from(boxes);

    combined.addAll(top.boxes);

    return combined;
  }

  int get bonusYahtzeeCount => allBoxes.fold(0, (int count, YahtzeeBox box) => count + (box.isBonusYahtzee ? 1 : 0));
  int get bonusYahtzeeScore => BONUS_YAHTZEE_SCORE * bonusYahtzeeCount;
  int get score => boxes.fold(0, (int sum, YahtzeeBox box) => sum + box.score) + bonusYahtzeeScore;

  @override
  String toString() {
    return super.toString() + ', ' + bonusYahtzeeScore.toString();
  }
}