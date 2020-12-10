import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Effects/Effect.dart';
import 'package:flutter/material.dart';

/// [Dot] class, see also [Effect]:
/// Provide the ability to describe and use Damage Over Time effects in Combat.
///
/// A dot is an effect that is applied each turn till the end of its duration.
///
/// Example: Bleeding, losing health points each turn during a certain number
/// of turns.

class Dot extends Effect {
  /// Returns an [Dot] Object.
  Dot(
      {@required CombatStats stats,
      int duration = 1,
      @required String path,
      @required int target,
      String description = ""})
      : super(
            stats: stats,
            duration: duration,
            path: path,
            target: target,
            description: description);

  /// Return the [CombatStats] of this [Dot]
  @override
  CombatStats get effectStats {
    if (super.turnsLeft >= 0) return super.stats;

    return new CombatStats();
  }
}
