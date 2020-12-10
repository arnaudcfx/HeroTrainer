import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'package:info2051_2018/model/Services/Rand.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Core/Statistics/CombatStats.dart';
import 'package:info2051_2018/model/Core/Effects/BuffNerf.dart';

/// [ItemGenerator] class:
///
/// This class is used to easily be able to generate random items of different
/// statistics and rarities.
///
/// See also [MerchantScreen]
class ItemGenerator {
  /// Map that associates an adjective to each level of rarity.
  static Map<int, String> adjectives = {
    1: "cheap",
    2: "common",
    3: "nice",
    4: "extraordinary",
    5: "legendary"
  };

  /// Map that stores all types of armor.
  static Map<int, String> armor = {
    1: "Boots",
    2: "Chest",
    3: "Gloves",
    4: "Head",
    5: "Pants"
  };

  /// This method generate a random weapon from the weapon set of the current hero.
  /// (Each hero global type (3) has a special set of weapon and armor assets).
  /// Each statistics of the items is randomized and depends on the level of the
  /// player but also on the rarity level that is generated randomly too.
  static Item generateWeapon(int level, String type) {
    int rarity = Rand.rint(1, 6);

    Stats stats = new Stats(
      strength: Rand.rintd(1, 5, rarity + level),
      intelligence: Rand.rintd(0, 2, rarity + level),
    );
    int result =
        (stats.base.values.reduce((sum, element) => sum + element)).toInt();

    return new Item(
      usable: false,
      name: "Weapon",
      image: "assets/Common/Items/Weapons/$type/$rarity/${Rand.rint(1, 8)}.png",
      description: "A ${adjectives[rarity]} weapon",
      equipStats: stats,
      gold: result * 100,
    );
  }

  /// This method generate a random armor from the armor set of the current hero.
  /// (Each hero global type (3) has a special set of weapon and armor assets).
  /// Each statistics of the items is randomized and depends on the level of the
  /// player but also on the rarity level that is generated randomly too.
  static Item generateArmor(int level, String type, {int choice}) {
    int rarity = Rand.rint(1, 2);
    String adjective = rarity == 1 ? adjectives[1] : adjectives[5];
    Stats stats = new Stats(
      strength: Rand.rintd(1, 2, rarity + level),
      speed: Rand.rintd(1, 5, rarity + level),
    );
    String name = choice == null ? armor[Rand.rint(1, 5)] : armor[choice];
    var values = stats.base.values;
    int result = (values.reduce((sum, element) => sum + element)).toInt();

    return new Item(
      usable: false,
      name: name,
      image: "assets/Common/Items/Armor/$type/$name/$rarity.png",
      description: "A $adjective armor",
      equipStats: stats,
      gold: result * 100,
    );
  }

  /// This method generate a random Potion.
  /// Each statistics of the items is randomized and depends on the level of the
  /// player but also on the rarity level that is generated randomly too.
  static Item generatePotion(int level, String type) {
    int rarity = Rand.rint(1, 6);
    int choice = Rand.rint(1, 4);
    String potion;
    CombatStats stats;
    switch (choice) {
      case 1:
        potion = "Attack";
        stats = new CombatStats(
          mAtt: Rand.rintd(1, 3, rarity + level),
          pAtt: Rand.rintd(1, 3, rarity + level),
        );
        break;
      case 2:
        potion = "Defense";
        stats = new CombatStats(
          mDef: Rand.rintd(1, 3, rarity + level),
          pDef: Rand.rintd(1, 3, rarity + level),
        );
        break;
      case 3:
        potion = "Speed";
        stats = new CombatStats(
          dodge: Rand.rintd(1, 3, rarity + level),
          critChance: Rand.rintd(1, 3, rarity + level),
        );
        break;
    }

    int result = (Map<String, double>.from(stats.base)
        .values
        .reduce((sum, element) => sum + element)).toInt();

    return new Item(
      usable: true,
      name: "Potion",
      image: "assets/Common/Items/Potions/${Rand.rint(1, 11)}.png",
      description: "A ${adjectives[rarity]} $potion potion",
      equipStats: null,
      effect: new BuffNerf(
          stats: stats,
          duration: 2,
          path: 'assets/CombatScreen/Effects/buffatt.png',
          target: 0,
          description: "Attack Increased"),
      gold: result * 100,
    );
  }

  /// Used in [CombatState] to generate the Item won by the Player.
  static Item generateSomething(int level, String type) {
    int choice = Rand.rint(1, 4);
    print(choice);
    switch (choice) {
      case 1:
        return generateWeapon(level, type);
      case 3:
        return generateArmor(level, type);
      case 2:
        return generatePotion(level, type);
    }
    return generateWeapon(level, type);
  }
}
