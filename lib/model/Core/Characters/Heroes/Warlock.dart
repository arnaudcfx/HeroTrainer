import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';

import 'package:info2051_2018/model/Services/Rand.dart';

/// Warlock class: see [Hero]
/// This class contains all the specific data/behaviors of the Warlock character.
/// Spells:
///   * Increase the magical attack of the Warlock.
///   * Heal the Warlock over time.
///   * Apply a damage over time on the enemy.
///
class Warlock extends Hero {
  Warlock()
      : super(
            type: 'Warlock',
            ranges: [10, 8, 5, 14,  8],
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                        stats: new CombatStats(mp: s.magicAttack),
                        duration: 3,
                        path: 'assets/CombatScreen/Effects/Amplify.png',
                        target: 0,
                        description: "magic attack doubled",
                      ),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Amplify",
                  cost: 0,
                  description: "Double your magic attack",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                        stats: new CombatStats(hp: s.magicAttack),
                        duration: 3,
                        path: 'assets/CombatScreen/Effects/Endurance.png',
                        target: 0,
                        description: "HP doubled",
                      ),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Endurance",
                  cost: 0,
                  description: "Double your health",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.magicAttack),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Shadowblast.png',
                      target: 1,
                      description: "Scared: Lose HP over time"),
                  damageGenerator: (CombatStats s) => s.magicAttack * 2,
                  name: "Shadowblast",
                  cost: 40,
                  description: "Scares your enemy",
                  animation: "attackExtra"),
            ],
            stats:
                new Stats(strength: 8, intelligence: 15, speed: 4, level: 1));

  /// When being attacked by an Enemy , multiple things can happen.
  ///   * 10* chance to heal himself over time.
  ///   * [CombatStats] Depending on the dodge chance of the Warlock when being attacked
  ///     it has a certain % chance to dodge the attack and avoid the damages.
  @override
  AttackInfo attacked(String type, int damage) {
    double tmp = damage.toDouble();
    return new AttackInfo(
        effectGenerator: Rand.rbool(10)
            ? (CombatStats s) => new Dot(
                stats: new CombatStats(hp: this.combatStats.health ~/ 5),
                duration: 3,
                path: 'assets/CombatScreen/Effects/Heal.png',
                target: 0,
                description: "Warlock Passive effect : Heal 20% ")
            : null,
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

  /// Overrides parent levelUp method to implement specific behavior.
  /// Our warlock is based on the intelligence statistic.
  @override
  void levelUp() {
    super.baseStats = super.baseStats +
        new Stats(strength: 1, intelligence: 4, speed: 1, level: 1);
  }

  /// The type data is used to display the correct set of weapons and armors.
  /// e.g we have 3 sets of items: Warrior set, Mage set and Rogue set.
  @override
  String get type => "Mage";

  /// The subType data is used to display the correct images about the hero.
  /// e.g we have 9 different unique heroes.
  @override
  String get subType => "Warlock";
}
