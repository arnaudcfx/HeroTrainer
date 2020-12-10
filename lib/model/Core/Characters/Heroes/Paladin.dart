import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Paladin class: see [Hero]
/// This class contains all the specific data/behaviors of the Paladin character.
/// Spells:
///   * Makes damage and decrease the defense of the enemy.
///   * Heal the Paladin during 4 turns.
///   * Fill the mana of the paladin.
///
/// Unique behaviors:
///   * Passive unique behavior : 10% chance to heal himself when being attacked.

class Paladin extends Hero {
  /// Returns the Paladin Object
  Paladin()
      : super(
            type: 'Paladin',
            ranges: [10, 6, 5, 13, 9],
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                      stats: new CombatStats(pDef: -s.physicalAttack ~/ 3),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Judgment.png',
                      target: 1,
                      description: "Defense reduced"),
                  damageGenerator: (CombatStats s) => s.physicalAttack ~/ 2,
                  name: "Judgment",
                  cost: 0,
                  description: "Reduces the enemy defense",
                  animation: "attackExtra"),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: s.health ~/ 6),
                      duration: 4,
                      path: 'assets/CombatScreen/Effects/Heal.png',
                      target: 0,
                      description: "Gain HP over time"),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Heal",
                  cost: 20,
                  description: "Regen hp",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(mp: s.mana),
                      duration: 1,
                      path: 'assets/CombatScreen/Effects/Blessing.png',
                      target: 0,
                      description: "Gain MP over time"),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Blessing",
                  cost: 0,
                  description: "Regen mana",
                  animation: ""),
            ],
            stats:
                new Stats(strength: 15, intelligence: 2, speed: 6, level: 1));

  /// When being attacked by an Enemy , multiple things can happen.
  ///   * 10* chance to heal himself over time.
  ///   * [CombatStats] Depending on the dodge chance of the Paladin when being attacked
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
                description: "Paladin Passive effect : Heal 20% ")
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
  /// Our Paladin is based on the strength statistic.
  @override
  void levelUp() {
    super.baseStats = super.baseStats +
        new Stats(strength: 3, intelligence: 1, speed: 1, level: 1);
  }

  /// The type data is used to display the correct set of weapons and armors.
  /// e.g we have 3 sets of items: Warrior set, Mage set and Rogue set.
  String get type => "Warrior";

  /// The subType data is used to display the correct images about the hero.
  /// e.g we have 9 different unique heroes.
  String get subType => "Paladin";
}
