import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';

/// Assassin class: see [Hero]
/// This class contains all the specific data/behaviors of the Assassin character.
/// Spells:
///   * Hit the enemy and poison it.
///   * Hit the enemy and make it bleed.
///
class Assassin extends Hero {
  /// Returns the Assassin Object
  Assassin()
      : super(
            type: 'Assassin',
            ranges: [10, 8, 5, 18, 12],
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                        stats: new CombatStats(hp: -s.physicalAttack * 2),
                        duration: 4,
                        path: 'assets/CombatScreen/Effects/Poison.png',
                        target: 1,
                        description: "Poisoned",
                      ),
                  damageGenerator: (CombatStats s) => s.physicalAttack * 2,
                  name: "Poison",
                  cost: 40,
                  description: "Poison your enemy",
                  animation: "attackExtra"),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.physicalAttack),
                      duration: 5,
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

  /// Overrides parent levelUp method to implement specific behavior.
  /// Our Rogue is based on the strength statistic.
  @override
  void levelUp() {
    super.baseStats = super.baseStats +
        new Stats(strength: 3, intelligence: 1, speed: 1, level: 1);
  }

  /// The type data is used to display the correct set of weapons and armors.
  /// e.g we have 3 sets of items: Warrior set, Mage set and Rogue set.
  @override
  String get type => "Rogue";

  /// The subType data is used to display the correct images about the hero.
  /// e.g we have 9 different unique heroes.
  @override
  String get subType => "Assassin";
}
