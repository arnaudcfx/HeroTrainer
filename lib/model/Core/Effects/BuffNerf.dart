import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Effects/Effect.dart';
import 'package:flutter/foundation.dart';

/// [BuffNerf] class, see also [Effect]:
/// Provide the ability to describe and use buff and nerf effects in Combat.
///
/// A buff is an temporary improvement of the [CombatStats] of a [Character]
/// it is applied once, last some turns and then is removed.
///
/// A nerf is the temporary decrease of [CombatStats].

class BuffNerf extends Effect {
  /// Boolean to only apply the BuffNerf once.
  bool _applied = false;

  /// Returns an [BuffNerf] Object.
  BuffNerf(
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

  /// Named Constructor used to build this object from a map.
  BuffNerf.fromJson(Map<String, dynamic> item)
      : super(
            stats: new CombatStats.fromJson(item['stats']),
            duration: item['duration'],
            path: item['path'],
            target: item['target'],
            description: item['description']);

  /// Return the [CombatStats] of this [BuffNerf] only if it hasn't been applied.
  /// Otherwise returns an empty [CombatStats]
  @override
  CombatStats get effectStats {
    int duration = super.turnsLeft;
    if (duration >= 0 && !_applied) {
      this._applied = !this._applied;
      return super.stats;
    }
    var stats = new CombatStats();
    if (duration == -1) return stats - super.stats;

    return stats;
  }
}
