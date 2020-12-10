import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Rogue class: see [Hero]
/// This class contains all the specific data/behaviors of the Rogue character.
/// Spells:
///   * Double the speed of the rogue.
///   * Hit the enemy and make it bleed.
///
/// Unique behaviors:
///   * Passive unique behavior : 10% chance to double the Rogue' speed.
class Rogue extends Hero {
  /// Returns the Rogue Object
  Rogue()
      : super(
            type: 'Rogue',
            ranges: [10, 8, 6, 18,11],
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                        stats: new CombatStats(
                            dodge: s.dodge, critChance: s.critChance),
                        duration: 3,
                        path: 'assets/CombatScreen/Effects/Speed.png',
                        target: 0,
                        description: "Critical hit and dodge chances doubled",
                      ),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Speed",
                  cost: 0,
                  description: "Double your speed",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.physicalAttack),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Bleed.png',
                      target: 1,
                      description: "Bleeding: Lose HP over time"),
                  damageGenerator: (CombatStats s) => s.physicalAttack,
                  name: "Bleed",
                  cost: 10,
                  description: "Cut your enemy",
                  animation: "attackExtra"),
            ],
            stats:
                new Stats(strength: 10, intelligence: 10, speed: 15, level: 1));

  /// When attacking an Enemy, multiple things can happen with the Rogue
  /// physical attacks.
  ///
  /// * 10* chance to increase its speed.
  /// * combatstats.critChance% chance to make a critical hit (damage * 150%).
  ///
  AttackInfo attack(String type, {int spell}) {
    if (type == "physical") {
      return new AttackInfo(
          effectGenerator: Rand.rbool(10)
              ? (CombatStats s) => new BuffNerf(
                  stats: new CombatStats(
                      dodge: s.dodge ~/ 10, critChance: s.critChance ~/ 10),
                  duration: 1,
                  path: 'assets/CombatScreen/Effects/Speed.png',
                  target: 0,
                  description: "Warrior Passive effect : Speed 110%")
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

  /// Overrides parent levelUp method to implement specific behavior.
  /// Our Rogue is based on the speed statistic.
  @override
  void levelUp() {
    super.baseStats = super.baseStats +
        new Stats(strength: 1, intelligence: 1, speed: 2, level: 1);
  }

  /// The type data is used to display the correct set of weapons and armors.
  /// e.g we have 3 sets of items: Warrior set, Mage set and Rogue set.
  String get type => "Rogue";

  /// The subType data is used to display the correct images about the hero.
  /// e.g we have 9 different unique heroes.
  String get subType => "Rogue";
}
