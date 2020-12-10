import 'package:info2051_2018/model/Core/Characters/Hero.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';

/// Mage class: see [Hero]
/// This class contains all the specific data/behaviors of the Mage character.
/// Spells:
///   * Increase the magical attack of the mage.
///   * Heal the mage over time.
///   * Fireball.
///
class Mage extends Hero {
  /// Returns the Mage Object
  Mage()
      : super(
            type: 'Mage',
            ranges: [10, 8, 6, 14,  7],
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
                  description: "Recover your health",
                  animation: ""),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.magicAttack * 2),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Fireblast.png',
                      target: 1,
                      description: "Burns: Lose HP over time"),
                  damageGenerator: (CombatStats s) => s.magicAttack * 2,
                  name: "Fireblast",
                  cost: 40,
                  description: "Burn your enemy",
                  animation: "attackExtra"),
            ],
            stats:
                new Stats(strength: 8, intelligence: 15, speed: 4, level: 1));

  /// Overrides parent levelUp method to implement specific behavior.
  /// Our Mage is based on the intelligence statistic.
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
  String get subType => "Mage";
}
