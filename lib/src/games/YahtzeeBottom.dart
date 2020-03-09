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
  YahtzeeBottom() {
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
}