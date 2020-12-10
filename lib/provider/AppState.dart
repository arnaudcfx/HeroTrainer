import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'package:info2051_2018/services/SavingLoading.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// [AppState] class:
///
/// This is our global Application state, shared and accessible in all widgets
/// of our app. It contains all the information needed to operate the app and
/// act as a single source of truth in the application.
///
/// Others States will typically be built by taking as argument some parts of
/// the data of appState and [Screens] will update appState at then end when
/// unmounting (commiting the modification at the end).
///
class AppState with ChangeNotifier {
  /// AudioPlayer used to have a music during fights.
  AudioPlayer audioPlayer;

  /// List of the heroes playable in the app.
  List<Character> heroes;

  /// List of items representating the current inventory of the Player.
  List<Item> inventory = new List<Item>();

  /// List of items representating the current equipment of the Player.
  List<Item> equipment = new List<Item>(9);

  /// Variable holding the highest stage the player achieved to reach.
  /// Stages have the form X - Y where Y increases at each combat won till
  /// reaching 10, at this point a boss fight occurs, if won we roll back to
  /// X+1 - 0.
  /// Example : 0-10 -> 1-0
  List<int> maxStage = [0, 0];
  List<int> tmpStage = [0, 0];

  /// Variable holding the current amount of gold the plauer has.
  List<int> gold = [0];

  /// Variable to keep track of the current hero being used.
  int _mainHero = 0;
  int _xp = 0;

  /// Boolean to indict to the UI that a saving is in progress
  bool saving = false;

  /// returns an [AppState] object, when initiated, it will try to fetch
  /// data from the memory, if no data in memory, all elements are initated
  /// with default values.
  AppState({this.heroes}) {
    /// Loading from the phone each stats for each hero
    heroes.forEach((element) async {
      var x = await SavingLoadingService.loadHero(element.subType);

      if (x != null) {
        element.baseStats = x;
      }
    });
    this._loadInventory();
    this._loadEquipment();
    this._loadLists();
    audioPlayer = new AudioPlayer();
  }

  /// Method used to load the inventory from the gsm memory.
  Future<void> _loadInventory() async {
    var x = await SavingLoadingService.loadList("inventory");
    if (x != null)
      this.inventory = x.map((json) => Item.fromJson(json)).toList();
  }

  /// Method used to load the equipment from the gsm memory.
  Future<void> _loadEquipment() async {
    var x = await SavingLoadingService.loadList("equipment");
    if (x != null)
      this.equipment =
          x.map((json) => json == null ? null : Item.fromJson(json)).toList();
  }

  /// Method used to load the data with a [List] of basic data types from the
  /// phone memory.
  Future<void> _loadLists() async {
    var x = await SavingLoadingService.loadList("stage");
    if (x != null) this.maxStage = List.from(x);
    x = await SavingLoadingService.loadList("gold");
    if (x != null) this.gold = List.from(x);
  }

  /// Method used to save all important data of the appstate in the memory of the
  /// phone.
  void saveAll() async {
    this.saving = true;
    notifyListeners();
    this.heroes.forEach((element) {
      SavingLoadingService.saveHero(element);
    });
    await SavingLoadingService.saveList(this.gold, "gold");
    await SavingLoadingService.saveList(this.maxStage, "stage");
    await SavingLoadingService.saveListObjects(this.inventory, "inventory");
    await SavingLoadingService.saveListObjects(this.equipment, "equipment");
    this.saving = false;
    notifyListeners();
  }

  /// Method used to return the currently played hero with the statistics updated
  /// depending on the equipment it is carrying.
  Character heroEquipped() {
    this.equipment.forEach((item) {
      if (item != null) {
        this.currHero.baseStats = this.currHero.baseStats + item.stats;
      }
    });
    return this.currHero;
  }

  /// Method used to return the currently played hero without the statistics
  /// depending on the equipment it is carrying.
  Character heroUnEquipped() {
    this.equipment.forEach((item) {
      if (item != null) {
        this.currHero.baseStats = this.currHero.baseStats - item.stats;
      }
    });
    return this.currHero;
  }

  set currHero(int hero) => this._mainHero = hero;
  set item(Item item) => this.inventory.add(item);

  void remove(item) => inventory.remove(item);

  set addXp(int xp) => this._xp += xp;
  set newGold(int gold) => this.gold[0] = gold;
  set currGold(int gold) => this.gold[0] += gold;
  get currHero => this.heroes[this._mainHero];
  get currXp => this._xp;
  get currGold => this.gold[0];
  get currInventory => this.inventory;
  get currEquipment => this.equipment;
}
