import 'package:playing_around/src/games/ChanceYahtzeeBox.dart';
import 'package:playing_around/src/games/FourOfAKindYahtzeeBox.dart';
import 'package:playing_around/src/games/FullHouseYahtzeeBox.dart';
import 'package:playing_around/src/games/LargeStraightYahtzeeBox.dart';
import 'package:playing_around/src/games/SmallStraightYahtzeeBox.dart';
import 'package:playing_around/src/games/ThreeOfAKindYahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeBox.dart';
import 'package:playing_around/src/games/YahtzeeSection.dart';
import 'package:playing_around/src/games/YahtzeeYahtzeeBox.dart';

class YahtzeeBottom extends YahtzeeSection {
  YahtzeeBottom() : super(<YahtzeeBox>[
      ThreeOfAKindYahtzeeBox(),
      FourOfAKindYahtzeeBox(),
      FullHouseYahtzeeBox(),
      SmallStraightYahtzeeBox(),
      LargeStraightYahtzeeBox(),
      YahtzeeYahtzeeBox(),
      ChanceYahtzeeBox()
  ]);

  YahtzeeBox get yahtzeeYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == YahtzeeYahtzeeBox);
  bool get scoredYahtzee => yahtzeeYahtzeeBox.score != 0;
}