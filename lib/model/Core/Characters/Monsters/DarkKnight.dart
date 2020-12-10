import 'package:info2051_2018/model/Core/Characters/Enemy.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// DarkKnight class: see [Enemy]
/// This class contains all the specific data/behaviors of the DarkKnight character.
class DarkKnight extends Enemy {
  /// Returns the [DarkKnight] Object
  DarkKnight(int difficulty)
      : super(
            type: 'Monsters/DarkKnight',
            ranges: [5, 5, 3],
            stats: new Stats(
              strength: Rand.rintd(15, 20, difficulty),
              intelligence: 1,
              speed: Rand.rintd(5, 8, difficulty),
              level: difficulty,
            ),
            spells: null);
}
