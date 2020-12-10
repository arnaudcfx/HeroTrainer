import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Characters/Merchant.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'dart:async';
import 'package:info2051_2018/services/ItemGenerator.dart';

///
/// Logic state used to provide data and methods needed by the screen.
///
/// When the craft occurs it updates the magician animation.
///
/// If the craft succeed, the items in the craftbox
/// are then relevant (same type) and the magician add a new item
/// in the hero inventory.
/// If not, the items returns back in the hero inventory.
///
class CraftState with ChangeNotifier {
  /// Magician inventory.
  List<Item> inventory = new List<Item>(48);

  /// Craftbox.
  List<Item> items = new List<Item>(3);

  /// Hero inventory.
  List<Item> heroInventory;

  /// Craft item.
  Item result;

  /// Magician character used in the screen.
  Character magician;

  /// Asset path
  var path = 'assets/CraftScreen';

  /// Hero type
  final String type;

  /// Hero level
  final int level;

  /// Number of items dropped in the craftbox
  int nbItems = 0;

  /// Actual item in the craftbox
  int currItem = 0;

  /// Current button state
  Status state = Status.on;

  CraftState(this.type, this.level, this.heroInventory) {
    magician = new Merchant(type: 'Magician', stats: new Stats());

    fillInventory();
  }

  ///
  /// Fill the magician inventory.
  ///
  void fillInventory() {
    for (int i = 0; i < 40; i++)
      inventory[i] = ItemGenerator.generatePotion(level, type);
  }

  ///
  /// The craft occurs only when there are exactly two items
  /// and have the same type.
  /// Otherwise, the items returns back in the hero inventory.
  ///
  void craft() {
    this.state = Status.paused;
    notifyListeners();

    if (nbItems == 2) {
      if (items[0].name == items[1].name) {
        if (items[0].name != "Potion")
          items[0].equipStats += items[1].equipStats;
        else
          items[0].effect.stats += items[1].effect.stats;
        heroInventory.add(items[0]);
        items[0] = null;
        items[1] = null;
        magician.animate('hurry');
      } else {
        heroInventory.add(items[0]);
        heroInventory.add(items[1]);
        items[0] = null;
        items[1] = null;
        magician.animate('idiot');
      }
      nbItems = 0;
    } else if (nbItems == 1) {
      heroInventory.add(items[currItem]);
      items[currItem] = null;
      magician.animate('idiot');
      nbItems = 0;
    } else
      magician.animate('idiot');

    Future.delayed(const Duration(milliseconds: 1500), () {
      this.state = Status.on;
      notifyListeners();
    });
    notifyListeners();
  }

  /// Returns the hero inventory.
  get currInventory => heroInventory;

  /// Returns the magician inventory.
  get currMagician => magician;

  /// Returns the current item.
  get item => items[currItem];

  /// Returns the craft item.
  get newItem => result;

  ///
  /// Add a new item in the hero equipment in position i.
  /// When an item is dropped in a merged slot,
  /// the merge item returns back in the hero inventory.
  ///
  void itemAccepted(item, i) {
    print(i);
    currItem = i;
    if (items[i] != null) {
      heroInventory.add(items[i]);
      items[i] = null;
      nbItems--;
    }

    items[i] = item;
    if (nbItems < 2) nbItems++;

    notifyListeners();
  }

  ///
  /// Removes the item from the inventory.
  ///
  void remove(item) {
    heroInventory.remove(item);
    notifyListeners();
  }
}

/// When an animation occurs, the action button is paused for a while
enum Status { paused, on }
