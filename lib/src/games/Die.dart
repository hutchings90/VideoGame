import 'dart:math';

final random = new Random();

class Die implements Comparable {
  int _value;

  int get value => _value;

  Die() {
    roll();
  }

  Die.fromDie(Die die) {
    _value = die._value;
  }

  int compareTo(dynamic other) {
    return _value - other._value;
  }

  @override
  String toString() {
    return _value.toString();
  }

  roll() {
    _value = random.nextInt(6) + 1;
  }
}