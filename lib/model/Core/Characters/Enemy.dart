import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Animation.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';

/// Enemy class: see [Character]
/// This class is an abstract class and defines what are the animation of the
/// enemies of the game and how to use them.

abstract class Enemy extends Character {
  /// Map used to store and retrieve the animations.
  Map<String, Animation> anim;
  /// String to keep track of the location of the assets of the enemy.
  final String _path;

  /// Returns the Enemy Object
  Enemy(
      {@required String type,
      @required List<int> ranges,
      @required Stats stats,
      @required List<AttackInfo> spells})
      : _path = 'assets/CombatScreen/$type',
        super(baseStats: stats, spells: spells) {
    anim = {
      'death': Animation(
          path: 'assets/CombatScreen/$type/Death/death', range: ranges[0]),
      'attack': Animation(
          path: 'assets/CombatScreen/$type/Attack/attack', range: ranges[1]),
      'attacked': Animation(
          path: 'assets/CombatScreen/$type/Hurt/hurt', range: ranges[2]),
    };
  }

  /// Method used to display an animation using the [StreamController].
  /// The animation is retrieved based on the name given as argument.
  @override
  void animate(String name) {
    anim[name].display(super.controller);
    if (name != 'death' && name != 'idle')
      super.controller.add(path + '/base.png');
  }

  /// These methods are unused by the monsters of the game.
  String get type => "";
  String get subType => "";
  String get path => this._path;
  @override
  void levelUp() {}
}
