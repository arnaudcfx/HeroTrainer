import 'package:info2051_2018/model/Core/Characters/Enemy.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Goblin class: see [Enemy]
/// This class contains all the specific data/behaviors of the Goblin character.
class Goblin extends Enemy {
  /// Returns the [Goblin] Object
  Goblin(int difficulty)
      : super(
          type: 'Monsters/Goblin',
          ranges: [4, 5, 3],
          stats: new Stats(
              strength: Rand.rintd(8, 10, difficulty),
              intelligence: 1,
              speed: Rand.rintd(12, 20, difficulty),
              level: difficulty),
          spells: null,
        );
}
