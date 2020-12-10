import 'package:info2051_2018/model/Core/Statistics/Stats.dart';
import 'package:info2051_2018/model/Services/Rand.dart';

/// [CombatStats] class:
///
/// This class is used to describe the hero fighting
/// capabilities in terms of simple data.
///
class CombatStats {
  /// Map used to store the data.
  Map<String, double> _base = {
    'hp': 0,
    'mp': 0,
    'pAtt': 0,
    'mAtt': 0,
    'spt': 0, // seconds
    'dodge': 0, // percentage
    'critChance': 0,
    'pDef': 0,
    'mDef': 0,
  };

  /// returns a [CombatStats] object.
  CombatStats(
      {int hp = 0,
      int mp = 0,
      int pAtt = 0,
      int mAtt = 0,
      int spt = 0,
      int dodge = 0,
      int pDef = 0,
      int mDef = 0,
      int critChance = 0}) {
    this.health = hp;
    this.mana = mp;
    this.physicalAttack = pAtt;
    this.magicAttack = mAtt;
    this.secPerTurn = spt;
    this.dodge = dodge;
    this.physicalDefense = pDef;
    this.magicDefense = mDef;
    this.critChance = critChance;
  }

  /// Named Constructor to build a [CombatStats] object from a [Stats] object.
  CombatStats.fromStats(Stats stats) {
    this._base['hp'] = (stats.strength * 10).toDouble();
    this._base['mp'] = (stats.intelligence * 10).toDouble();

    double x = (stats.strength * 5).toDouble();
    this._base['pAtt'] = Rand.rdouble((x - x / 10), (x + x / 10));

    x = stats.speed / stats.level;
    this._base['spt'] = 30 / x;
    this._base['dodge'] = x * 2;
    this._base['critChance'] = this._base['dodge'];
    x = (stats.intelligence * 5).toDouble();
    this._base['mAtt'] = Rand.rdouble((x - x / 10), (x + x / 10));

    x = (stats.strength * 2).toDouble();
    this._base['pDef'] = x;

    x = (stats.intelligence * 2).toDouble();
    this._base['mDef'] = x;
  }

  /// Named Constructor used to build a [CombatStats] object from a Map.
  CombatStats.fromJson(Map input) {
    this._base = new Map<String, double>.from(input);
  }

  /// Method used to transform ta [CombatStats] object into a Map.
  Map toJson() => this._base;

  /// Overloaded operator returns a new [CombatStats] made of the sum of the two
  /// [CombatStats] involved in the sum.
  CombatStats operator +(CombatStats other) {
    Map<String, double> x = new Map.from(this.base);

    other.base.forEach((key, value) {
      x[key] = x[key] + value;
    });
    return CombatStats.fromJson(x);
  }

  /// Overloaded operator returns a new [CombatStats] made of the minus operation
  /// of the two [CombatStats] involved in the operation.
  CombatStats operator -(CombatStats other) {
    Map<String, double> x = new Map.from(this.base);

    other.base.forEach((key, value) {
      x[key] = x[key] - value;
    });
    return CombatStats.fromJson(x);
  }

  /// getters: used to return an int while our map store double
  /// for easier operations.
  int get health => _base['hp'].toInt();
  int get mana => _base['mp'].toInt();
  int get physicalAttack => _base['pAtt'].toInt();
  int get magicAttack => _base['mAtt'].toInt();
  int get physicalDefense => _base['pDef'].toInt();
  int get magicDefense => _base['mDef'].toInt();
  int get secPerTurn => _base['spt'].toInt();
  int get dodge => _base['dodge'].toInt();
  int get critChance => _base['critChance'].toInt();
  Map get base => _base;

  /// setters
  set base(Map<String, double> map) => this._base = map;
  set health(int hp) => _base['hp'] = hp.toDouble();
  set mana(int mp) => _base['mp'] = mp.toDouble();
  set physicalAttack(int pAtt) => _base['pAtt'] = pAtt.toDouble();
  set magicAttack(int mAtt) => _base['mAtt'] = mAtt.toDouble();
  set physicalDefense(int pDef) => _base['pDef'] = pDef.toDouble();
  set magicDefense(int mDef) => _base['mDef'] = mDef.toDouble();
  set secPerTurn(int spt) => _base['spt'] = spt.toDouble();
  set dodge(int dodge) => _base['dodge'] = dodge.toDouble();
  set critChance(int crit) => _base['critChance'] = crit.toDouble();
}
