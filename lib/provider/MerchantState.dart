import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Characters/Merchant.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'dart:async';
import 'package:info2051_2018/model/Services/Rand.dart';
import 'package:info2051_2018/services/ItemGenerator.dart';

///
/// Logic state used to provide data and methods needed by the screen.
///
/// When a merchant is chosen,
/// it updates the corresponding animation and inventory
/// of the merchant.
///
/// When a seller an item is bought or sold,
/// it updates the corresponding merchant animation.
///
class MerchantState with ChangeNotifier {
  /// List of merchants
  List<Character> merchants = new List<Character>(3);

  /// Weapon inventory
  List<Item> weaponsInventory = new List<Item>(8);

  /// Armor inventory
  List<Item> armorInventory = new List<Item>(6);

  /// Potions inventory
  List<Item> potionsInventory = new List<Item>(9);

  /// Hero inventory
  List<Item> heroInventory;

  /// Asset items
  var path = 'assets/MerchantScreen/Items';

  /// The actual merchant type
  final String type;

  /// The actual hero level
  final int level;

  /// The actual hero level
  int _item = 0;

  /// The price of the current item
  int _priceItem;

  /// The current hero gold
  int currGold;

  /// Return true when an item has been bought
  bool _buy = false;

  /// Return true when an item has been sold
  bool _sell = false;

  /// Current button state
  Status state = Status.on;

  /// The actual merchant
  int curr = 0;

  MerchantState(this.type, this.level, this.currGold, this.heroInventory) {
    merchants[0] = new Merchant(type: 'Weapons', stats: new Stats());
    merchants[1] = new Merchant(type: 'Armor', stats: new Stats());
    merchants[2] = new Merchant(type: 'Potions', stats: new Stats());

    fillWeapons();
    fillArmor();
    fillPotions();
  }

  ///
  /// Fill the inventory of the merchant weapons
  ///
  void fillWeapons() {
    for (int i = 0; i < 8; i++) {
      weaponsInventory[i] = ItemGenerator.generateWeapon(level, type);
    }
  }

  ///
  /// Fill the inventory of the merchant armor
  ///
  void fillArmor() {
    for (int i = 0; i < 5; i++)
      armorInventory[i] =
          ItemGenerator.generateArmor(level, type, choice: i + 1);
  }

  ///
  /// Fill the inventory of the merchant potions
  ///
  void fillPotions() {
    for (int i = 0; i < 9; i++)
      potionsInventory[i] = ItemGenerator.generatePotion(level, type);
  }

  ///
  /// Provide the corresponding merchant animation
  /// where i is the current merchant.
  ///
  void changeCurr(int i) {
    this.state = Status.paused;
    curr += i;
    if (curr > 2) curr = 2;
    if (curr < 0) curr = 0;

    notifyListeners();
    merchants[curr].animate('hey');
    Future.delayed(const Duration(milliseconds: 1500), () {
      this.state = Status.on;
      notifyListeners();
    });
  }

  ///
  /// Provide the corresponding merchant animation
  /// when an item has been bought where i is the current merchant.
  ///
  void buy() {
    this.state = Status.paused;

    notifyListeners();
    if (currGold >= _priceItem) {
      merchants[curr].animate('happy');
      _buy = true;
    } else {
      merchants[curr].animate('sad');
      _buy = false;
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      this.state = Status.on;
      notifyListeners();
    });
  }

  ///
  /// Provide the corresponding merchant animation
  /// when an item has been sold where i is the current merchant.
  ///
  void sell(i) {
    currGold += _priceItem;
    heroInventory.remove(heroInventory[i]);
    merchants[curr].animate('happy');
    notifyListeners();
  }

  ///
  /// returns the hero inventory
  /// when we enter in sell mode.
  ///
  /// returns the current merchant inventory otherwise.
  ///
  get currInventory {
    if (_sell) return heroInventory;

    if (curr == 0)
      return weaponsInventory;
    else if (curr == 1)
      return armorInventory;
    else
      return potionsInventory;
  }

  /// returns the current merchant
  get currMerchant => this.merchants[this.curr];

  /// returns the current merchant item
  get item => currInventory[_item];

  /// returns the current hero gold
  get gold => currGold;

  /// returns the current price of the item
  get priceItem => _priceItem;

  /// returns the current golds
  get golds => 2;

  /// Updates item
  set item(item) => _item = item;

  /// Updates gold
  set gold(gold) => currGold = gold;

  ///
  /// Enters in sell mode or not.
  ///
  void next() {
    _sell ? _sell = false : _sell = true;
    notifyListeners();
  }

  ///
  /// Sell an item in sell mode,
  /// buy an item in buy mode.
  /// Updates golds in both cases.
  ///
  void itemAction(i, item) {
    _priceItem = item.cost;
    _sell ? sell(i) : buy();
    if (_buy) {
      currGold -= _priceItem;
      heroInventory.add(currInventory[i]);
    }
  }
}

/// When an animation occurs, the action button is paused for a while
enum Status { paused, on }
