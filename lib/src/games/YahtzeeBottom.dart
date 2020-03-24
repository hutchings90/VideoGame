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

  YahtzeeBox get threeOfAKindYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == ThreeOfAKindYahtzeeBox);
  YahtzeeBox get fourOfAKindYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == FourOfAKindYahtzeeBox);
  YahtzeeBox get fullHouseYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == FullHouseYahtzeeBox);
  YahtzeeBox get smallStraightYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == SmallStraightYahtzeeBox);
  YahtzeeBox get largeStraightYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == LargeStraightYahtzeeBox);
  YahtzeeBox get yahtzeeYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == YahtzeeYahtzeeBox);
  YahtzeeBox get chanceYahtzeeBox => boxes.firstWhere((YahtzeeBox box) => box.runtimeType == ChanceYahtzeeBox);
  YahtzeeBox get preferredWildcardBox {
    if (!largeStraightYahtzeeBox.used) return largeStraightYahtzeeBox;
    if (!smallStraightYahtzeeBox.used) return smallStraightYahtzeeBox;
    if (!fourOfAKindYahtzeeBox.used) return fourOfAKindYahtzeeBox;
    if (!threeOfAKindYahtzeeBox.used) return threeOfAKindYahtzeeBox;
    if (!fullHouseYahtzeeBox.used) return fullHouseYahtzeeBox;
    if (!chanceYahtzeeBox.used) return chanceYahtzeeBox;
    return null;
  }
}