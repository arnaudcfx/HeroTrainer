import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';
import 'package:info2051_2018/model/Core/Effects/Effect.dart';
import 'package:flutter/foundation.dart';

/// [Item] class:
/// Defines the Items of the game.
///
/// There exist two types of items:
///   * Non-usable items, like weapons and armor.
///   * Usable items, like potions that can be used during the fight and provide
///     an [Effect] to its user.
class Item {
  /// Cost of the item.
  final int gold;

  /// Boolean used to determine if the item is usable in a combat.
  final bool usable;

  /// If the item is usable in combat, an [Effect] will provide its effect.
  final Effect effect;

  /// if the item is not usable in combat, a [Stats] will describe the stats
  /// it will add to the [Character] stats when equipped.
  Stats equipStats;

  /// Strings needed to describe the Item.
  final String name;
  final String image;
  final String description;

  /// returns an [Item] object
  Item(
      {@required this.name,
      @required this.image,
      @required this.gold,
      @required this.equipStats,
      @required this.description,
      this.usable = false,
      this.effect = null});

  /// Named Constructor used to build this object from a map.
  Item.fromJson(Map<String, dynamic> item)
      : name = item['name'],
        image = item['image'],
        gold = item['gold'],
        equipStats =
            (item['stats'] == null) ? null : new Stats.fromJson(item['stats']),
        usable = item['usable'],
        description = item['description'],
        effect = (item['effect'] == null)
            ? null
            : new BuffNerf.fromJson(item['effect']);

  /// Method used to transform this object into a Map.
  Map toJson() => {
        'name': this.name,
        'image': this.image,
        'gold': this.gold,
        'stats': this.equipStats?.toJson(),
        'description': this.description,
        'usable': this.usable,
        'effect': this.effect?.toJson()
      };

  int get cost => gold;

  /// Depending on wether this item is usable or not, it returns the
  /// [Stats] or [CombatStats] needed.
  dynamic get stats =>
      this.equipStats == null ? this.effect.stats : this.equipStats;
}
