import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Character class:
/// This class is an abstract class and defines the global behavior of our
/// characters.
/// See Also [Enemy] and [Hero]

abstract class Character {
  /// List to store the spells of our [Character].
  final List<AttackInfo> _spells;

  /// To each character is associated a [StreamController] which is used to
  /// display the animation of the character.
  final StreamController<String> _controller;

  /// To each character is associated a [Stats] object which holds all the
  /// rpg statistic of our character.
  Stats _baseStats;

  /// Returns a Character object.
  Character({@required Stats baseStats, @required List<AttackInfo> spells})
      : _baseStats = baseStats,
        _spells = spells,
        _controller = StreamController<String>.broadcast();

  /// This function defines a standard behavior for characters attacking.
  /// It returns a [AttackInfo] object containing the damage, [Effect] and
  /// animation of the attack.

  AttackInfo attack(String type, {int spell}) {
    if (type == "physical")
      return new AttackInfo(
          effectGenerator: null,
          damageGenerator: this.type == "mage"
              ? (CombatStats s) => s.physicalAttack
              : (CombatStats s) => s.physicalAttack ~/ 2,
          name: "Physical Hit",
          cost: 0,
          description: "",
          animation: "attack");

    return this._spells[spell];
  }
  /// This function defines a standard behavior for characters being Attacked.
  /// It returns a [AttackInfo] object containing
  ///   * The updated damage that the character will suffer, this updated damage
  ///     will take into account any damage reduction due to Dodgin or armor.
  ///   * [Effect] It is not the case for the default behavior but some heroes
  ///     and enemies can trigger special effects when being attacked.
  ///   * Animation name.

  AttackInfo attacked(String type, int damage) {
    double tmp = damage.toDouble();
    return new AttackInfo(
        effectGenerator: null,
        damageGenerator: (CombatStats s) {
          if (Rand.rbool(s.dodge)) return 0;
          var x = (type == "physical")
              ? tmp - tmp * (s.physicalDefense.toDouble() / 150)
              : tmp - tmp * (s.magicDefense.toDouble() / 150);
          return x.toInt();
        },
        name: "Physical Hit",
        cost: 0,
        description: "",
        animation: "attacked");
  }

  void animate(String name);
  void levelUp();

  /// Getters Methods.
  Stats get baseStats => _baseStats;
  CombatStats get combatStats => new CombatStats.fromStats(this._baseStats);
  int get strength => _baseStats.strength;
  int get intelligence => _baseStats.intelligence;
  int get speed => _baseStats.speed;
  int get level => _baseStats.level;
  int get xp => _baseStats.xp;
  int get maxXp => _baseStats.level * 100;
  String get type;
  String get path;
  String get subType;
  Stream get stream => _controller.stream;
  StreamController<String> get controller => _controller;
  List<AttackInfo> get spells => _spells;

  /// Setters Methods.

  set xp(int xp) => _baseStats.xp = xp;
  set strength(int strength) => _baseStats.strength = strength;
  set intelligence(int intelligence) => _baseStats.intelligence = intelligence;
  set speed(int speed) => _baseStats.speed = speed;
  set level(int level) => _baseStats.level = level;
  set baseStats(var stats) => _baseStats = stats;
}
