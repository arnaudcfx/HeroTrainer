import 'package:info2051_2018/model/Core/Characters/Enemy.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// Skeleton class: see [Enemy]
/// This class contains all the specific data/behaviors of the Skeleton character.
class Skeleton extends Enemy {
  /// Returns the [Skeleton] Object
  Skeleton(int difficulty)
      : super(
            type: 'Monsters/Skeleton',
            ranges: [5, 4, 2],
            stats: new Stats(
                strength: Rand.rintd(8, 10, difficulty),
                intelligence: Rand.rintd(2, 5, difficulty),
                speed: Rand.rintd(0, 5, difficulty),
                level: difficulty),
            spells: null);
}
