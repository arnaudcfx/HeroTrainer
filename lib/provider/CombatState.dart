import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Effects/Effect.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'dart:async';
import 'package:info2051_2018/model/Services/Rand.dart';
import 'package:info2051_2018/services/PausableTimer.dart';
import 'package:info2051_2018/model/Core/Effects/AttackInfo.dart';
import 'package:info2051_2018/services/ItemGenerator.dart';

/// [CombatState] class:
///
/// This class is used to provide data and methods that are needed by
/// [CombatScreen] and also to notify widgets of the screen that changes
/// have occurred.
///
/// In this state, most of the data is about two characters : a hero and
/// a enemy.
/// To make this representation easily extend to multi-hero or multi-enemyfights,
/// everything is represented thanks to list.
///
/// In our situation the convention is :
///    * 0 : the hero.
///    * 1 : the enemy.
///
class CombatState with ChangeNotifier {
  /// List holding the two characters.
  final List<Character> characters;

  /// List holding the gold won or lost.
  final int gold;

  /// List holding the CombatStats of the two characters.
  /// Its elements change over time due to effects. That is why we don't use
  /// directly from the [Character] class.
  final List<CombatStats> stats;

  /// List representation the inventory.
  final List<Item> inventory;

  /// List representation the potions, usable during the combat.
  final List<Item> potions;

  /// List holding the list of [Effect] affecting each [Character]
  final List<List<Effect>> effects;

  /// Item won.
  final Item wonItem;

  /// List used to notify the UI that an attack has been dodged.
  var dodged = [false, false];

  /// [Status] variable used to indicate if the combat is finished or not.
  Status game;

  /// [States] variable used to indicate whose turn it is.
  States currentTurn;

  /// Timer used so that, every 7 seconds the enemy will hit.
  StartStopTimer timer;
  double spt = 7;

  /// Returns a [CombatState] object
  CombatState({this.characters, this.inventory})
      : this.gold = Rand.rint(1, 100),
        this.stats = new List.generate(
            2, (i) => new CombatStats() + characters[i].combatStats),
        this.effects = new List.generate(2, (i) => new List<Effect>()),
        this.wonItem = ItemGenerator.generateSomething(
            characters[0].level, characters[0].type),
        this.potions =
            inventory.where((element) => element.usable == true).toList() {
    game = Status.playing;
    currentTurn = States.playerTurn;

    this.timer = new StartStopTimer(
        period: 1,
        callback: () {
          if (this.game == Status.playing &&
              this.currentTurn == States.playerTurn) {
            if (this.spt == 0) {
              this.currentTurn = States.heroAction;
              notifyListeners();
              this.spt = 7;
              this.interact(HeroAction.timeOut);
              return;
            }
            this.spt -= 1;
            notifyListeners();
          }
        });
    this.timer.start();
  }

  /// Handles the turns, at the start of each turn, effects are handled and updated.
  Future<void> _newTurn() async {
    this.currentTurn = States.newTurn;
    notifyListeners();

    await this._handleEffects(0);
    if (this.game == Status.finished) return;
    await this._handleEffects(1);
    if (this.game == Status.finished) return;

    await Future.delayed(const Duration(milliseconds: 500));
    this.currentTurn = States.playerTurn;
    notifyListeners();
  }

  /// Handles the effects. Each effect' stats is added to the target stats.
  /// When the duration of an [Effect] is over, it is removed from the list.
  Future<void> _handleEffects(int index) async {
    if (this.effects[index].length > 0) {
      CombatStats tmp;
      for (Effect effect in this.effects[index]) {
        await Future.delayed(const Duration(milliseconds: 200));
        tmp = effect.effectStats;
        this.stats[index] += tmp;

        if (this.stats[index].health < 0) this.stats[index].health = 0;

        if (this.stats[index].health >
            this.characters[index].combatStats.health)
          this.stats[index].health = this.characters[index].combatStats.health;

        if (this.stats[index].mana > this.characters[index].combatStats.mana)
          this.stats[index].mana = this.characters[index].combatStats.mana;

        notifyListeners();
      }
    }
    this.effects[index].removeWhere((element) => element.duration < 0);
    if (this.stats[index].health <= 0) {
      print("Effect lost: " + index.toString());
      (index == 0) ? this._heroDeath() : this._enemyDeath();
      return;
    }
  }

  /// Handles the Human player interactions, to make it predictable it handles
  /// a [HeroAction] value as input. Depending on the action it calls
  /// the appropriate methods.
  Future<void> interact(HeroAction action, {int index}) async {
    this.currentTurn = States.heroAction;
    notifyListeners();

    switch (action) {
      case HeroAction.physicalAttack:
        {
          await this._attack(0, 1, "physical");
          break;
        }
      case HeroAction.potion:
        {
          Item i = this.potions[index];
          this.potions.remove(i);
          this.inventory.remove(i);
          this.effects[i.effect.target].add(i.effect);
          this.currentTurn = States.playerTurn;
          notifyListeners();
          return;
        }
      case HeroAction.magicalAttack:
        {
          if (this.characters[0].spells[index].cost > this.stats[0].mana) {
            this.currentTurn = States.playerTurn;
            notifyListeners();
            return;
          }
          this.stats[0].mana -= this.characters[0].spells[index].cost;
          await this._attack(0, 1, "magical", spell: index);
          break;
        }
      case HeroAction.timeOut:
        {
          break;
        }
    }
    if (this.game == Status.finished) return;

    this.currentTurn = States.enemyAction;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));
    await this._attack(1, 0, "physical", spell: this.stats[1].mana);
    await Future.delayed(const Duration(milliseconds: 200));
    if (this.game != Status.finished) this._newTurn();
  }

  /// Handles [Character] attacks. First we generate the [AttackInfo] attack, it
  /// contains the direct damage and a possible [Effect] from the attacker.
  /// Then we generate the [AttackInfo] defense, that contains the update attack
  /// damage (takes armor into account) and another possible [Effect] from the
  /// target being attacked.
  Future<void> _attack(int attacker, int target, String type,
      {int spell}) async {
    AttackInfo attack = this.characters[attacker].attack(type, spell: spell);
    Effect effectAtt = attack.effect(this.stats[attacker]);
    if (effectAtt != null) {
      this.effects[effectAtt.target].add(effectAtt);
    }

    AttackInfo defense = this
        .characters[target]
        .attacked(type, attack.damage(this.stats[attacker]));
    Effect effectDef = defense.effect(this.stats[target]);
    if (effectDef != null) {
      this.effects[effectDef.target].add(effectDef);
    }

    int damage = (defense.damage(this.stats[target]) < 0)
        ? 0
        : defense.damage(this.stats[target]);

    // Dodge handling
    if (damage == 0 && attack.damage(this.stats[attacker]) != 0) {
      Future.delayed(Duration(seconds: 0), () async {
        this.dodged[target] = true;
        notifyListeners();
        await Future.delayed(Duration(milliseconds: 1000));
        this.dodged[target] = false;
        notifyListeners();
      });
    }
    this.stats[target].health = (this.stats[target].health - damage < 0)
        ? 0
        : this.stats[target].health - damage;

    // Animations
    this.characters[attacker].animate(attack.animation);
    await Future.delayed(const Duration(milliseconds: 300));
    if (damage != 0) this.characters[target].animate(defense.animation);
    notifyListeners();

    if (this.stats[target].health <= 0) {
      (target == 0) ? this._heroDeath() : this._enemyDeath();
      return;
    }
  }

  /// Handle the win case, xp is updated and possible level up is handled.
  void _win() {
    int wonXp = Rand.rint(10, 30) * this.characters[0].level;
    this.characters[0].xp = wonXp + this.characters[0].xp;

    while (this.characters[0].xp >= this.characters[0].maxXp)
      this.characters[0].levelUp();

    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

  /// Handle the character death.
  void _enemyDeath() {
    this.characters[1].animate('death');
    this.game = Status.finished;
    this.currentTurn = States.won;
    notifyListeners();
    _win();
  }

  /// Handle the character death.
  void _heroDeath() {
    this.stats[0].health = 0;
    this.characters[0].animate('death');
    this.game = Status.finished;
    this.currentTurn = States.lost;
    notifyListeners();
  }

  Item get item => wonItem;
}

enum Status { playing, finished }
enum States { newTurn, playerTurn, enemyAction, heroAction, lost, won }
enum HeroAction { physicalAttack, magicalAttack, potion, timeOut }
