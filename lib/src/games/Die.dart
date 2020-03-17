import 'dart:math';

final random = new Random();

class Die implements Comparable {
  static const SIDE_COUNT = 6;

  int value;

  Die({ this.value }) {
    if (value == null) roll();
  }

  Die.fromDie(Die die) {
    value = die.value;
  }

  int compareTo(dynamic other) {
    return value - other.value;
  }

  @override
  String toString() {
    return value.toString();
  }

  roll() {
    value = random.nextInt(SIDE_COUNT) + 1;
  }
}