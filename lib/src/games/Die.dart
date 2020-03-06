import 'dart:math';

final random = new Random();

class Die implements Comparable {
  int value;

  Die({ this.value }) {
    if (value == null) value = random.nextInt(6);
  }

  int compareTo(dynamic other) {
    return value - other.value;
  }

  @override
  String toString() {
    return value.toString();
  }
}