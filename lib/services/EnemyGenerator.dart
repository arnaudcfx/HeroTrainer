import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Characters/Monsters/Boss2.dart';
import 'package:info2051_2018/model/Core/Characters/Monsters/Boss1.dart';
import 'package:info2051_2018/model/Core/Characters/Monsters/DarkKnight.dart';
import 'package:info2051_2018/model/Core/Characters/Monsters/Goblin.dart';
import 'package:info2051_2018/model/Core/Characters/Monsters/Skeleton.dart';
import 'package:info2051_2018/model/Core/Characters/Monsters/Vampire.dart';
import 'package:info2051_2018/model/Services/Rand.dart';
import "dart:math";
import 'package:info2051_2018/model/Core/Characters/Monsters/BigKnight.dart';

/// [EnemyGenerator] class:
///
/// Class used to draw randomly new monsters for the [CombatState]
///
class EnemyGenerator {
  static Random random = new Random();

  /// List that contains all the basic enemis (for stage 1->10).
  static List<Function> enemies = [
    (int level) => new Goblin(Rand.rint(1, level + 1)),
    (int level) => new Skeleton(Rand.rint(1, level + 1)),
    (int level) => new Vampire(Rand.rint(1, level + 1)),
    (int level) => new DarkKnight(Rand.rint(1, level + 1)),
    (int level) => new BigKnight(Rand.rint(1, level + 1)),
  ];

  /// List that contains all the bosses (stage 10)
  static List<Function> bosses = [
    (int level) => new Boss1(Rand.rint(1, level + 1)),
    (int level) => new Boss2(Rand.rint(1, level + 1))
  ];

  /// Returns a random basic enemy from the list.
  static dynamic generateEnemy(int level) {
    Function x = enemies[random.nextInt(enemies.length)];
    return x(level);
  }

  /// Returns a random boss from the list.
  static Character generateBoss(int level) {
    Function x = bosses[random.nextInt(bosses.length)];
    return x(level);
  }
}
