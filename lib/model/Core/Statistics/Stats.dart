/// [Stats] class:
///
/// This class is used to describe the hero capabilities in terms of simple data.
///
class Stats {
  /// Map used to store the data.
  Map<String, double> _base = {
    'strength': 0,
    'intelligence': 0,
    'speed': 0,
    'xp': 0,
    'level': 0,
  };

  /// returns a [Stats] object.
  Stats(
      {int strength = 0, int intelligence = 0, int speed = 0, int level = 0}) {
    this.strength = strength;
    this.intelligence = intelligence;
    this.speed = speed;
    this.level = level;
  }

  /// Named Constructor used to build a [Stats] object from a Map.
  Stats.fromJson(Map<String, dynamic> item) {
    this.base["strength"] = item['strength'];
    this.base['intelligence'] = item['intelligence'];
    this.base['speed'] = item['speed'];
    this.base['level'] = item['level'];
    this.base['xp'] = item['xp'];
  }

  /// Method used to transform ta [Stats] object into a Map.
  Map toJson() => {
        'strength': this._base["strength"],
        'intelligence': this._base["intelligence"],
        'speed': this._base["speed"],
        'level': this._base["level"],
        'xp': this._base["xp"],
      };

  /// Overloaded operator returns a new [Stats] made of the sum of the two
  /// [Stats] involved in the sum.
  Stats operator +(Stats other) {
    Map<String, double> x = new Map.from(this.base);

    other.base.forEach((key, value) {
      x[key] = x[key] + value;
    });
    return Stats.fromJson(x);
  }

  /// Overloaded operator returns a new [Stats] made of the minus operation
  /// of the two [Stats] involved in the operation.
  Stats operator -(Stats other) {
    Map<String, double> x = new Map.from(this.base);

    other.base.forEach((key, value) {
      x[key] = x[key] - value;
    });
    return Stats.fromJson(x);
  }

  /// getters: used to return an int while our map store double
  /// for easier operations.
  int get xp => _base['xp'].toInt();
  int get strength => _base['strength'].toInt();
  int get intelligence => _base['intelligence'].toInt();
  int get speed => _base['speed'].toInt();
  int get level => _base['level'].toInt();
  Map<String, double> get base => _base;

  /// setters
  set xp(int xp) => _base['xp'] = xp.toDouble();
  set strength(int strength) => _base['strength'] = strength.toDouble();
  set intelligence(int intelligence) =>
      _base['intelligence'] = intelligence.toDouble();
  set speed(int speed) => _base['speed'] = speed.toDouble();
  set level(int level) => _base['level'] = level.toDouble();
}
