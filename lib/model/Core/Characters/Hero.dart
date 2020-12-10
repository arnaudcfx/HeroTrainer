import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Animation.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';

/// Hero class: see [Character]
/// This class is an abstract class and defines what are the animation of the
/// Heroes of the game and how to use them.

abstract class Hero extends Character {
  /// String to keep track of the location of the assets of the hero.
  final String _path;
  /// Map used to store and retrieve the animations.
  Map<String, Animation> anim;

  /// Returns the Hero Object
  Hero(
      {@required String type,
      @required List<int> ranges,
      @required Stats stats,
      @required List<AttackInfo> spells})
      : _path = 'assets/Common/Heroes/$type',
        super(baseStats: stats, spells: spells) {
    anim = {
      'death': Animation(path: '$_path/Death/death', range: ranges[0]),
      'attack': Animation(path: '$_path/Attack/attack', range: ranges[1]),
      'attacked': Animation(path: '$_path/Hurt/hurt', range: ranges[2]),
      'idle': Animation(path: '$_path/Idle/idle', range: ranges[3]),
      'attackExtra':
          Animation(path: '$_path/Attack_Extra/attack_extra', range: ranges[4]),
    };
  }
  /// Method used to display an animation using the [StreamController].
  /// The animation is retrieved based on the name given as argument.
  @override
  void animate(String name) {
    if (name != "") {
      anim[name].display(super.controller);
      if (name != 'death') super.controller.add(_path + '/base.png');
    }
  }
  /// Specific getters
  String get path => this._path;
  List<AttackInfo> get spells => super.spells;

  /// These methods are to be implemented by the classes that inherits from
  /// [Hero].
  String get type;
  String get subType;
  @override
  void levelUp();
  @override
  AttackInfo attack(String type, {int spell});


}
