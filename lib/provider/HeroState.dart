import 'package:flutter/foundation.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/view/Tools.dart';

///
/// Logic state used to provide data and methods needed by the screen.
///
/// When the draggable item merged with the target one,
/// it updates the states of the hero.
///
/// If the target item has already a draggable item,
/// the draggable item returns back in the hero inventory.
///
class HeroState with ChangeNotifier {
  /// Current hero.
  final Character hero;

  /// Current hero equipment.
  List<Item> heroEquipment;

  /// Current hero inventory.
  List<Item> heroInventory;

  /// The current target item number.
  int curr = 0;

  HeroState(this.hero, this.heroInventory, this.heroEquipment);

  /// returns the current hero
  Character get currHero => hero;

  /// returns the current inventory
  List<Item> get currInventory => heroInventory;

  /// returns the current equipment
  List<Item> get currEquipment => heroEquipment;

  ///
  /// Update the stats of the hero,
  /// where item is the draggable item and i the current equipment.
  /// When the target item is not empty the stats of the item are
  /// removed from the current hero stats.
  ///
  void statsUpdate(item, i) {
    if (item != null) {
      /// the target item is empty
      if (heroEquipment[i] == null)
        hero.baseStats = hero.baseStats + item.stats;
      else {
        /// the target item is not empty
        hero.baseStats = (hero.baseStats - heroEquipment[i].stats) + item.stats;
        heroInventory.add(heroEquipment[i]);
      }
      notifyListeners();
    }
  }

  ///
  /// Removes an item from the hero inventory.
  ///
  void remove(item) {
    heroInventory.remove(item);
    notifyListeners();
  }

  ///
  /// Add a new item in the hero equipment in position i.
  ///
  void itemAccepted(item, i) {
    heroEquipment[i] = item;
    notifyListeners();
  }

  ///
  /// Update the current target item number.
  ///
  int increment() {
    curr == 8 ? curr = 0 : curr++;

    return curr;
  }
}
