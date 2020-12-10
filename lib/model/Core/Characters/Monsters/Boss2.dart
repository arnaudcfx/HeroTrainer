import 'package:info2051_2018/model/Core/Characters/Enemy.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Dot.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';

/// Boss2 class: see [Enemy]
/// This class contains all the specific data/behaviors of the Boss2 character.
/// Unique behaviors:
///   * Passive unique behavior : 10% chance to double its attack.
///   * Passive unique behavior : 10% chance to hurt its attacker when attacked.
class Boss2 extends Enemy {
  Boss2(int difficulty)
      : super(
            type: 'Monsters/Boss2',
            ranges: [6, 8, 3],
            stats: new Stats(
              strength: Rand.rintd(20, 25, difficulty),
              intelligence: Rand.rintd(10, 15, difficulty),
              speed: Rand.rintd(7, 8, difficulty),
              level: difficulty,
            ),
            spells: [
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new BuffNerf(
                      stats: new CombatStats(
                          mAtt: s.magicAttack, pDef: s.physicalAttack),
                      duration: 2,
                      path: 'assets/CombatScreen/Effects/buffatt.png',
                      target: 1,
                      description: "Attack Doubled"),
                  damageGenerator: (CombatStats s) => 0,
                  name: "Anger",
                  cost: 1,
                  description: "Double your attack",
                  animation: "spell1"),
              new AttackInfo(
                  effectGenerator: (CombatStats s) => new Dot(
                      stats: new CombatStats(hp: -s.physicalAttack ~/ 3),
                      duration: 3,
                      path: 'assets/CombatScreen/Effects/Bleed.png',
                      target: 0,
                      description: "Bleeding: Lose HP over time"),
                  damageGenerator: (CombatStats s) => s.physicalAttack ~/ 2,
                  name: "Bleed",
                  cost: 10,
                  description: "Cut your enemy",
                  animation: "spell2"),
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
                  animation: "spell3"),
            ]);
  /// When attacking an Hero with a normal physical attack, multiple things
  /// can happen.
  ///   * 5* chance to increase its attack.
  ///   * [CombatStats] Depending on the critical chance of the Boss1 when attacking
  ///     it has a certain % chance to make a critical hit (damage * 150%).

  @override
  AttackInfo attack(String type, {int spell}) {
    return new AttackInfo(
        effectGenerator: Rand.rbool(10)
            ? (CombatStats s) => new BuffNerf(
            stats: new CombatStats(pAtt: s.physicalAttack),
            duration: 2,
            path: 'assets/CombatScreen/Effects/Amplify.png',
            target: 1,
            description: "Passive effect : Attack*2")
            : null,
        damageGenerator: (CombatStats s) => Rand.rbool(s.critChance)
            ? (s.magicAttack.toDouble() * 1.5).toInt()
            : s.magicAttack,
        name: "Magic Hit",
        cost: 0,
        description: "",
        animation: "attack");
  }

  /// When being attacked by an Hero , multiple things can happen.
  ///   * 10* chance to burn the enemy.
  ///   * [CombatStats] Depending on the dodge chance of the Paladin when being attacked
  ///     it has a certain % chance to dodge the attack and avoid the damages.
  @override
  AttackInfo attacked(String type, int damage) {
    double tmp = damage.toDouble();
    return new AttackInfo(
        effectGenerator: Rand.rbool(10)
            ? (CombatStats s) => new BuffNerf(
            stats: new CombatStats(mAtt: s.magicAttack ~/ 10),
            duration: 2,
            path: 'assets/CombatScreen/Effects/Fireblast.png',
            target: 0,
            description: "Burns")
            : null,
        damageGenerator: (CombatStats s) {
          if (Rand.rbool(s.dodge)) return 0;
          var x = (type == "physical")
              ? tmp - tmp * (s.physicalDefense.toDouble() / 150)
              : tmp - tmp * (s.magicDefense.toDouble() / 150);
          return x.toInt();
        },
        name: "Magic Hit",
        cost: 0,
        description: "",
        animation: "attacked");
  }
}
