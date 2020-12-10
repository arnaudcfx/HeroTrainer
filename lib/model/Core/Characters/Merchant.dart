import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Animation.dart';

/// Merchant class: see [Character]
/// This class defines the behavior and animations of the merchants of the game.

class Merchant extends Character {
  /// String to keep track of the location of the assets of the merchant.
  final String _path;

  /// Map used to store and retrieve the animations.
  Map<String, Animation> anim;

  /// List used to store and retrieve the 3 different merchants
  List<Character> merchants = new List<Character>(3);

  /// Returns a Merchant object.
  Merchant({@required String type, @required Stats stats})
      : _path = 'assets/MerchantScreen/Seller/$type',
        super(baseStats: stats, spells: null) {
    anim = {};
    anim['hey'] = Animation(path: '$_path/Hey/', range: 10);
    anim['happy'] = Animation(path: '$_path/Happy/', range: 10);
    anim['sad'] = Animation(path: '$_path/Sad/', range: 10);
    anim['hurry'] =
        Animation(path: 'assets/CraftScreen/Magician/Hurry/', range: 9);
    anim['idiot'] =
        Animation(path: 'assets/CraftScreen/Magician/Idiot/', range: 9);
  }
  /// Method used to display an animation using the [StreamController].
  /// The animation is retrieved based on the name given as argument.
  @override
  void animate(String name) {
    anim[name].display(super.controller);
  }

  /// These methods are unused by the monsters of the game.
  String get type => "Weapons";
  String get subType => "";
  String get path => "";
  @override
  void levelUp() {}
}
