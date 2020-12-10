import 'package:info2051_2018/model/Core/Characters/Enemy.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Vampire class: see [Enemy]
/// This class contains all the specific data/behaviors of the Vampire character.

class Vampire extends Enemy {
  /// Returns the [Vampire] Object
  Vampire(int difficulty)
      : super(
            type: 'Monsters/Vampire',
            ranges: [5, 4, 3],
            stats: new Stats(
                strength: Rand.rintd(5, 10, difficulty),
                intelligence: Rand.rintd(20, 25, difficulty),
                speed: Rand.rintd(15, 18, difficulty),
                level: difficulty),
            spells: null);
}
