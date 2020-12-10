import 'package:flutter/material.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'dart:async';

///
/// Logic state used to provide data and methods needed by the screen.
///
/// When a hero is chosen, it updates the corresponding
/// animation and description of the hero.
///
class SelectState with ChangeNotifier {
  /// List of heroes
  final List<Character> heroes;

  /// Actual state
  Status state = Status.on;

  /// Actual hero
  int curr = 0;

  SelectState({this.heroes});

  ///
  /// Provide the corresponding hero animation
  /// where i is the current hero.
  ///
  void changeCurr(int i) {
    this.state = Status.paused;
    curr = i;
    notifyListeners();
    heroes[i].animate('idle');
    Future.delayed(const Duration(milliseconds: 1500), () {
      this.state = Status.on;
      notifyListeners();
    });
  }

  /// Provide the corresponding hero description.
  String get band => 'assets/SelectScreen/${this.currHero.subType}_band.png';

  /// Set the current hero.
  set hero(int hero) => this.curr = hero;

  /// Returns the current hero.
  get currHero => this.heroes[this.curr];
}

/// When an animation occurs, the action button is paused for a while
enum Status {
   paused,
   on
}