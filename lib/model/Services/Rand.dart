import 'dart:math';

/// Rand class:
/// Static class used to perform random number generation.
class Rand {
  static final random = new Random();

  /// Generate a random number belonging to [ min ; max [
  static int rint(int min, int max) {
    return random.nextInt(max - min) + min;
  }

  /// Generate a random number belonging to ([ min ; max [) * difficulty
  static int rintd(int min, int max, int difficulty) {
    var x = (random.nextInt(max - min) + min) * difficulty;
    return x;
  }

  /// Generate a random number belonging to ([ min ; max ]) * difficulty
  static double rdouble(double min, double max) {
    return random.nextDouble() * (max - min) + min;
  }

  /// Generate a random boolean with a specified percentage of chance to get [true]
  static bool rbool(int percentage) {
    return random.nextInt(100) <= percentage ? true : false;
  }
}
