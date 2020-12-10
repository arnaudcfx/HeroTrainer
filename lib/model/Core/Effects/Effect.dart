import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:flutter/material.dart';

/// [Effect] class:
/// Provide the ability to describe and use effects in Combat.
/// An effect can be anything that can act on the [CombatStats] of
/// the two [Characters] during a Combat.
///
/// Example : Burning and losing health during 3 turns.
/// See also: [BuffNerf] and [Dot]

abstract class Effect {
  /// String to identify the icon path of the [Effect].
  String path;

  /// [CombatStats] that represent the impact that will occur on the
  /// [CombatStats] of a [Character].
  /// E.g : {"hp": -5}
  CombatStats stats;

  /// Int used to specify on which character in the fight the effect will be
  /// applied.
  /// The use of this int makes it very easy to make multi-heroes/ multi-monsters
  /// fight.
  ///
  /// In our situation the convention is :
  ///    * 0 : the hero.
  ///    * 1 : the enemy.
  int target;

  /// int used to specify the number of turns during which the effect will be
  /// active.
  int duration;

  /// String used to describe the Effect.
  String description;

  /// returns an [Effect] object.
  Effect(
      {@required this.stats,
      this.duration = 1,
      @required this.path,
      @required this.target,
      this.description = ""});

  /// Method used to transform a [Effect] object into a Map.
  Map toJson() => {
        "path": path,
        "stats": stats.toJson(),
        "target": target,
        "duration": duration,
        "description": description,
      };

  /// getter for the number of turns left for the effect,
  /// it updates duration each time it is called.
  int get turnsLeft {
    duration -= 1;
    return duration;
  }

  CombatStats get effectStats;
}
