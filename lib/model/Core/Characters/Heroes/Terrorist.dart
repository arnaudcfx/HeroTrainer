import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Characters/Hero.dart';

import 'package:info2051_2018/model/Services/Rand.dart';

/// Terrorist class: see [Hero]
/// This class contains all the specific data/behaviors of the Terrorist character.
/// Spells:
///   * Makes big damage and damage over time but cost a lot of mana.
///   * Hit the enemy and make it bleed.
///
/// Unique behaviors:
///   * Passive unique behavior : 5% chance to damage the enemy when being attacked.
class Terrorist extends Hero {
  /// Returns the Terrorist Object
  Terrorist()
      : super(
      type: 'Terrorist',
      ranges: [10, 8, 5, 19, 12],
      spells: [
        new AttackInfo(
            effectGenerator: (CombatStats s) => new Dot(
              stats: new CombatStats(hp: -s.physicalAttack*3),
              duration: 3,
              path: 'assets/CombatScreen/Effects/Bomb.png',
              target: 1,
              description: "Bomb damage",
            ),
            damageGenerator: (CombatStats s) => s.physicalAttack*2,
            name: "Bomb",
            cost: 50,
            description: "Throw a bomb on your enemy",
            animation: "attackExtra"),
        new AttackInfo(
            effectGenerator: (CombatStats s) => new Dot(
                stats: new CombatStats(hp: -s.physicalAttack),
                duration: 3,
                path: 'assets/CombatScreen/Effects/Bleed.png',
                target: 1,
                description: "Bleeding: Lose HP over time"),
            damageGenerator: (CombatStats s) => s.physicalAttack ~/ 2,
            name: "Bleed",
            cost: 10,
            description: "Cut your enemy",
            animation: "attackExtra"),
      ],
      stats: new Stats(
          strength: 10,
          intelligence: 4,
          speed: 15,
          level: 1));

  /// When being attacked by an Enemy , multiple things can happen.
  ///   * 5* chance to damage the enemy.
  ///   * [CombatStats] Depending on the dodge chance of the Terrorist when being attacked
  ///     it has a certain % chance to dodge the attack and avoid the damages.
  @override
  AttackInfo attacked(String type, int damage) {
    double tmp = damage.toDouble();
    return new AttackInfo(
        effectGenerator: Rand.rbool(5)
            ? (CombatStats s) => new Dot(
            stats: new CombatStats(hp: -this.combatStats.health ~/ 3),
            duration: 1,
            path: 'assets/CombatScreen/Effects/Bomb.png',
            target: 1,
            description: "Terrorist Passive effect : Damage when being hit ")
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
  /// Our Terrorist is based on the speed statistic.
  @override
  void levelUp() {
    super.baseStats = super.baseStats + new Stats(
        strength: 1,
        intelligence: 1,
        speed: 2,
        level: 1
    );
  }
  /// The type data is used to display the correct set of weapons and armors.
  /// e.g we have 3 sets of items: Warrior set, Mage set and Rogue set.
  String get type => "Rogue";
  /// The subType data is used to display the correct images about the hero.
  /// e.g we have 9 different unique heroes.
  String get subType=>"Terrorist";

}