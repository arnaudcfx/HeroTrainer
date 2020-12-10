import 'package:info2051_2018/model/Core/Characters/Enemy.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// BigKnight class: see [Enemy]
/// This class contains all the specific data/behaviors of the BigKnight character.

class BigKnight extends Enemy {
  /// Returns the [BigKnight] Object
  BigKnight(int difficulty)
      : super(
          type: 'Monsters/BigKnight',
          ranges: [4, 5, 4],
          stats: new Stats(
              strength: Rand.rintd(10, 20, difficulty),
              intelligence: 1,
              speed: Rand.rintd(2, 6, difficulty),
              level: difficulty),
          spells: null,
        );
}
