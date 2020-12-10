import 'package:info2051_2018/model/Core/Effects/Effect.dart';
import 'package:flutter/material.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';

/// [AttackInfo] class:
/// This class is used to make the link between the [Character] and the [CombatState]
/// by providing the data needed to update the combat.
///
/// It allows complex attacks and attacked behavior thanks to
///   * its generator Function that takes into account the variation of the
///     Combat statistics during a fight.
///   * data payload made of the damage, optional cost and an [Effect].
///

class AttackInfo {
  /// Allows to generate an [Effect] based on the [CombatStats] provided
  /// during the fight.
  Effect Function(CombatStats s) effectGenerator;

  /// Allows to generate an [int] based on the [CombatStats] provided during
  /// the fight.
  int Function(CombatStats s) damageGenerator;

  /// If the attack is a spell, then it costs mana.
  int cost;

  /// Strings needed to describe the Attack.
  String name;
  String description;

  /// String to identify the animation to use.
  String animation;

  /// Return an [AttaclInfo] object
  AttackInfo(
      {@required this.effectGenerator,
      @required this.damageGenerator,
      this.name = "",
      this.cost = 0,
      this.description = "",
      this.animation = ""});

  /// With the given [CombatStats], generate the damage associated with this
  /// [AttackInfo]
  int damage(CombatStats s) {
    return this.damageGenerator(s);
  }

  /// With the given [CombatStats], generate the [Effect] associated with this
  /// [AttackInfo]
  Effect effect(CombatStats s) {
    if (this.effectGenerator == null) return null;
    return this.effectGenerator(s);
  }

  /// Returns the image associated if the effect, if there is one.
  String get image => "assets/CombatScreen/Effects/${this.name}.png";
  CombatStats get stats => new CombatStats();
}
