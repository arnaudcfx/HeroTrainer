import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// WARRIOR class: see [Hero]
/// This class contains all the specific data/behaviors of the warrior character.
/// Spells:
///   * Double its defense during 3 turns.
///   * Hit the ennemy and make it bleed.
///   * A massive hit associated with a decrease the armor of the ennemy.
///
/// Unique behaviors:
///   * Passive unique behavior : 10% chance increase defense when attacking

class Warrior extends Hero {
  /// Returns the Warrior Object
  Warrior()
      : super(
            type: 'Warrior',
            ranges: [10, 5, 6, 13,  8],
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                      stats: new CombatStats(
                          mDef: s.magicDefense, pDef: s.physicalDefense),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Defend.png',
                      target: 0,
                      description: "Defense doubled"),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Defend",
                  cost: 0,
                  description: "Double your defense",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.physicalAttack ~/ 3),
                      duration: 3,
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
                      stats: new CombatStats(
                          mDef: -s.magicDefense, pDef: -s.physicalDefense),
                      duration: 2,
                      path: 'assets/CombatScreen/Effects/weakness.png',
                      target: 1,
                      description: "Defense Weakened"),
                  damageGenerator: (CombatStats s) => s.physicalAttack * 2,
                  name: "Smash",
                  cost: 40,
                  description: "Crush and weaken your ennemy",
                  animation: "attackExtra"),
            ],
            stats:
                new Stats(strength: 15, intelligence: 4, speed: 4, level: 1));

  /// Overrides parent levelUp method to implement specific behavior.
  /// Our warrior is based on the strength statistic.
  @override
  void levelUp() {
    super.baseStats = super.baseStats +
        new Stats(strength: 3, intelligence: 1, speed: 1, level: 1);
  }

  /// When attacking an Enemy with a normal physical attack, multiple things
  /// can happen.
  ///   * 10* chance to increase its armor.
  ///   * [CombatStats] Depending on the critical chance of the warrior when attacking
  ///     it has a certain % chance to make a critical hit (damage * 150%).
  ///
  @override
  AttackInfo attack(String type, {int spell}) {
    if (type == "physical") {
      return new AttackInfo(
          effectGenerator: Rand.rbool(10)
              ? (CombatStats s) => new BuffNerf(
                  stats: new CombatStats(
                      mDef: s.magicDefense ~/ 10,
                      pDef: s.physicalDefense ~/ 10),
                  duration: 1,
                  path: 'assets/CombatScreen/Effects/Defend.png',
                  target: 0,
                  description: "Warrior Passive effect : Defense 110%")
              : null,
          damageGenerator: (CombatStats s) => Rand.rbool(s.critChance)
              ? (s.physicalAttack.toDouble() * 1.5).toInt()
              : s.physicalAttack,
          name: "Physical Hit",
          cost: 0,
          description: "",
          animation: "attack");
    }
    return super.spells[spell];
  }
  /// The type data is used to display the correct set of weapons and armors.
  /// e.g we have 3 sets of items: Warrior set, Mage set and Rogue set.
  String get type => "Warrior";
  /// The subType data is used to display the correct images about the hero.
  /// e.g we have 9 different unique heroes.
  String get subType => "Warrior";
}
