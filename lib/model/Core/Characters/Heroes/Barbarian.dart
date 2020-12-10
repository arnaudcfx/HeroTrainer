import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Barbarian class: see [Hero]
/// This class contains all the specific data/behaviors of the Barbarian character.
/// Spells:
///   * Double its critical hit chances during 3 turns.
///   * Hit the ennemy and make it bleed.
///   * A massive hit associated with an increase of attack stats of the barbarian.
///
/// Unique behaviors:
///   * Passive unique behavior : 10% chance increase attack when attacking.

class Barbarian extends Hero {
  /// Returns the Barbarian Object
  Barbarian()
      : super(
            type: 'Barbarian',
            ranges: [10, 6, 5, 13, 9],
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                      stats: new CombatStats(critChance: s.critChance),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Fury.png',
                      target: 0,
                      description: "Critical hit chances doubled"),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Fury",
                  cost: 0,
                  description: "Double your physical attack",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.physicalAttack ~/ 3),
                      duration: 6,
                      path: 'assets/CombatScreen/Effects/Bleed.png',
                      target: 1,
                      description: "Bleeding: Lose HP over time"),
                  damageGenerator: (CombatStats s) => s.physicalAttack ~/ 2,
                  name: "Bleed",
                  cost: 10,
                  description: "Cut your enemy",
                  animation: "attackExtra"),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                      stats: new CombatStats(pAtt: s.physicalAttack ~/ 3),
                      duration: 4,
                      path: 'assets/CombatScreen/Effects/Strength.png',
                      target: 0,
                      description: "Gain strength over time"),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Smash",
                  cost: 60,
                  description: "Gain strength",
                  animation: ""),
            ],
            stats:
                new Stats(strength: 15, intelligence: 1, speed: 6, level: 1));

  /// When attacking an Enemy with a normal physical attack, multiple things
  /// can happen.
  ///   * 10* chance to increase its attack.
  ///   * [CombatStats] Depending on the critical chance of the barbarian when attacking
  ///     it has a certain % chance to make a critical hit (damage * 150%).

  @override
  AttackInfo attack(String type, {int spell}) {
    if (type == "physical") {
      return new AttackInfo(
          effectGenerator: Rand.rbool(10)
              ? (CombatStats s) => new BuffNerf(
                  stats: new CombatStats(
                    pAtt: s.physicalAttack ~/ 10,
                  ),
                  duration: 1,
                  path: 'assets/CombatScreen/Effects/buffatt.png',
                  target: 0,
                  description: "Barbarian Passive effect : Attack 110%")
              : null,
          damageGenerator: (CombatStats s) => Rand.rbool(s.critChance)
              ? (s.physicalAttack.toDouble() * 1.2).toInt()
              : s.physicalAttack,
          name: "Physical Hit",
          cost: 0,
          description: "",
          animation: "attack");
    }
    return super.spells[spell];
  }

  /// Overrides parent levelUp method to implement specific behavior.
  /// Our barbarian is based on the strength statistic.
  @override
  void levelUp() {
    super.baseStats = super.baseStats +
        new Stats(strength: 3, intelligence: 1, speed: 1, level: 1);
  }

  /// The type data is used to display the correct set of weapons and armors.
  /// e.g we have 3 sets of items: Warrior set, Mage set and Rogue set.
  @override
  String get type => "Warrior";

  /// The subType data is used to display the correct images about the hero.
  /// e.g we have 9 different unique heroes.
  @override
  String get subType => "Barbarian";
}
