import 'package:playing_around/src/games/Die.dart';
import 'package:playing_around/src/games/YahtzeeBottom.dart';
import 'package:playing_around/src/games/YahtzeeTop.dart';

class Yahtzee {
  static const DICE_COUNT = 5;

  YahtzeeTop top;
  YahtzeeBottom bottom;

  Yahtzee() {
    top = YahtzeeTop();
    bottom = YahtzeeBottom(top);
  }

  int get score => top.score + bottom.score;

  static bool isYahtzee(List<Die> dice) {
    if (dice.length != Yahtzee.DICE_COUNT) return false;

    for (int i = 1; i < dice.length; i++) {
      if (dice[i].value != dice[i - 1].value) return false;
    }

    return true;
  }

  play() {}

  test() {
    testTop();
    testBottom();
  }

  testTop() {
    // None gotten
    top.boxes[0].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    top.boxes[1].use(<Die>[Die(value: 5), Die(value: 1), Die(value: 6), Die(value: 5), Die(value: 4)]);
    top.boxes[2].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[3].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 1)]);
    top.boxes[4].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[5].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 1), Die(value: 5), Die(value: 4)]);

    print('top - none');
    print(top);

    // Gotten, no bonus
    top.boxes[0].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[1].use(<Die>[Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 2), Die(value: 4)]);
    top.boxes[2].use(<Die>[Die(value: 3), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 6), Die(value: 4), Die(value: 1)]);
    top.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    top.boxes[5].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('top - no bonus');
    print(top);

    // Gotten, bonus
    top.boxes[0].use(<Die>[Die(value: 1), Die(value: 1), Die(value: 6), Die(value: 1), Die(value: 4)]);
    top.boxes[1].use(<Die>[Die(value: 2), Die(value: 2), Die(value: 6), Die(value: 2), Die(value: 4)]);
    top.boxes[2].use(<Die>[Die(value: 3), Die(value: 3), Die(value: 3), Die(value: 1), Die(value: 4)]);
    top.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 4), Die(value: 4), Die(value: 1)]);
    top.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 5), Die(value: 5), Die(value: 4)]);
    top.boxes[5].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );

    print('top - with bonus');
    print(top);
  }

  testBottom() {
    // None gotten
    bottom.boxes[0].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    bottom.boxes[1].use(<Die>[Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 2), Die(value: 4)]);
    bottom.boxes[2].use(<Die>[Die(value: 3), Die(value: 2), Die(value: 6), Die(value: 1), Die(value: 4)]);
    bottom.boxes[3].use(<Die>[Die(value: 4), Die(value: 2), Die(value: 6), Die(value: 4), Die(value: 1)]);
    bottom.boxes[4].use(<Die>[Die(value: 5), Die(value: 2), Die(value: 6), Die(value: 5), Die(value: 4)]);
    bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('bottom - none');
    print(bottom);

    // Gotten
    bottom.boxes[0].use(<Die>[Die(value: 1), Die(value: 1), Die(value: 6), Die(value: 1), Die(value: 4)]);
    bottom.boxes[1].use(<Die>[Die(value: 2), Die(value: 2), Die(value: 2), Die(value: 2), Die(value: 4)]);
    bottom.boxes[2].use(<Die>[Die(value: 3), Die(value: 3), Die(value: 3), Die(value: 4), Die(value: 4)]);
    bottom.boxes[3].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 3), Die(value: 4), Die(value: 3)]);
    bottom.boxes[4].use(<Die>[Die(value: 1), Die(value: 2), Die(value: 3), Die(value: 4), Die(value: 5)]);
    bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)]);
    bottom.boxes[6].use(<Die>[Die(value: 6), Die(value: 2), Die(value: 1), Die(value: 6), Die(value: 4)]);

    print('bottom - all');
    print(bottom);

    // Gotten
    bottom.boxes[0].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[1].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[2].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[3].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[4].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );
    bottom.boxes[5].use(<Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)]);
    bottom.boxes[6].use(
      <Die>[Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6), Die(value: 6)],
      asBonusYahtzee: true
    );

    print('bottom - all yahtzees');
    print(bottom);
  }
}