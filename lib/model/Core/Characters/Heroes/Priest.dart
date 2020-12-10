import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Priest class: see [Hero]
/// This class contains all the specific data/behaviors of the Priest character.
/// Spells:
///   * Attack the enemy and do damage over time.
///   * Small heal.
///   * Big heal.
/// Unique behaviors:
///   * Passive unique behavior : 15% chance of hurting the enemy when attacked.
class Priest extends Hero {
  /// Returns the Priest Object
  Priest()
      : super(
            type: 'Priest',
            ranges: [10, 8, 5, 14, 8],
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.magicAttack),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Smite.png',
                      target: 1,
                      description: "Smited"),
                  damageGenerator: (CombatStats s) => s.magicAttack,
                  name: "Smite",
                  cost: 0,
                  description: "Smite the enemy",
                  animation: "attackExtra"),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                        stats: new CombatStats(hp: s.magicAttack),
                        duration: 3,
                        path: 'assets/CombatScreen/Effects/Endurance.png',
                        target: 0,
                        description: "Healed",
                      ),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Endurance",
                  cost: 0,
                  description: "Heal yourself",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: s.magicAttack * 4),
                      duration: 4,
                      path: 'assets/CombatScreen/Effects/Heal.png',
                      target: 0,
                      description: "Gain HP over time"),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Heal",
                  cost: 40,
                  description: "Regen hp",
                  animation: ""),
            ],
            stats:
                new Stats(strength: 7, intelligence: 15, speed: 4, level: 1));

  /// When being attacked by an Enemy , multiple things can happen.
  ///   * 20* chance to hurt the enemy.
  ///   * [CombatStats] Depending on the dodge chance of the Priest when being attacked
  ///     it has a certain % chance to dodge the attack and avoid the damages.
  @override
  AttackInfo attacked(String type, int damage) {
    double tmp = damage.toDouble();
    return new AttackInfo(
        effectGenerator: Rand.rbool(20)
            ? (CombatStats s) => new Dot(
                stats: new CombatStats(hp: -s.magicAttack ~/ 1.5),
                duration: 1,
                path: 'assets/CombatScreen/Effects/Judgment.png',
                target: 1,
                description: "Priest Passive effect : Judgement ")
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
  /// Our priest is based on the intelligence statistic.
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
  String get subType => "Priest";
}
