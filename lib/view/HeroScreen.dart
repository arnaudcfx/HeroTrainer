import 'package:flutter/material.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'package:info2051_2018/provider/AppState.dart';
import 'package:info2051_2018/provider/HeroState.dart';
import 'package:provider/provider.dart';
import 'package:info2051_2018/view/Tools.dart';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'Tools.dart';

///
/// Screen used to watch the equipment, stats, golds,
/// and the inventory of the hero.
/// The items from the inventory are draggable and can be dropped
/// in the corresponding equipment.
///
/// See also :
/// [HeroInventory],
/// [HeroDetails],
/// [DragTargetWidget],
/// [Gold]
///
class HeroScreen extends StatelessWidget {
  /// Returns a container in which there are an exit button,
  /// the actual equipment, golds and inventory widget of the hero.
  @override
  Widget build(BuildContext context) {
    /// Actual width and height of the screen.
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    /// Actual screen orientation.
    var orientation = _height > _width ? true : false;
    _width = (orientation) ? _width : _height / 1.05;
    _height = (orientation) ? _height / 1.5 : _width;

    return ChangeNotifierProvider(
        create: (_) => HeroState(
            context.read<AppState>().heroEquipped(),
            context.read<AppState>().currInventory,
            context.read<AppState>().currEquipment),
        child: SafeArea(
          child: Scaffold(
            //appBar: AppBar(),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/HeroScreen/background.png'),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: OrientationSwitcher(
                    orientation: orientation,
                    children: [
                      HeroDetails(width: _width, height: _height),
                      Gold(orientation: orientation, size: 15),
                      OrientableDivider(
                        thickness: 2.0,
                        color: Colors.grey[700],
                        orientation: orientation,
                      ),
                      HeroInventory()
                    ],
                  )),
            ),
          ),
        ));
  }
}

///
/// Displays the hero inventory.
/// items have a popup menu to describe each of them.
///
class HeroInventory extends StatelessWidget {
  /// Returns the hero inventory widget.
  Widget build(BuildContext context) {
    /// Takes the hero inventory.
    var y = context.watch<HeroState>().currInventory;
    return Inventory(
        grid: 7,
        items: y,
        nbSlots: 90,
        draggable: true,
        onLongPress: (element) {
          popupMenu(
              [element], context, context.findRenderObject() as RenderBox, 60);
        });
  }
}

///
/// Displays the hero equipment.
///
class HeroDetails extends StatelessWidget {
  /// Asset path.
  final String path = 'assets/HeroScreen/Inventory/Slots/';

  /// Slot size.
  final double slotSize = 50;

  /// Actual width and height of the screen.
  final width, height;

  /// List of slots for the hero equipment.
  final List<String> equip = [
    'Head.png',
    'Shoulders.png',
    'Chest.png',
    'Bracers.png',
    'Gloves.png',
    'Belt.png',
    'Pants.png',
    'Boots.png',
    'Weapon.png'
  ];
  HeroDetails({@required this.width, @required this.height});

  /// Returns nine target slots and five texts box
  /// to describe each hero stat.
  @override
  Widget build(BuildContext context) {
    Character hero = context.select((HeroState h) => h.currHero);

    /// Actual width and height of the screen.
    var y = context.watch<HeroState>();
    return Stack(
      children: [
        Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/HeroScreen/character.png'),
                  fit: BoxFit.fill),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(5)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: equip
                      .sublist(0, 4)
                      .map(
                        (i) => DragTargetWidget(
                            path: path, name: i, i: y.increment()),
                      )
                      .toList(),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: this.height / 3,
                    ),
                    CustomImage(
                        width: this.width / 4,
                        height: this.height / 3,
                        path:
                            'assets/Common/Heroes/${hero.subType}/Idle/idle1.png'),
                    SizedBox(
                      height: this.height / 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: equip
                          .sublist(8, 9)
                          .map(
                            (i) => DragTargetWidget(
                                path: path, name: i, i: y.increment()),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: equip
                      .sublist(4, 8)
                      .map(
                        (i) => DragTargetWidget(
                            path: path, name: i, i: y.increment()),
                      )
                      .toList(),
                ),
                SizedBox(
                  width: this.width / 25,
                  height: this.height / 1.5,
                  child: VerticalDivider(
                    thickness: 2,
                    color: Colors.grey[800],
                  ),
                ),
                Container(
                  width: this.width / 3,
                  height: this.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: hero.baseStats.base.entries.map((entry) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                entry.value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/HeroScreen/Separator.png'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            )),
        CustomButton(
            height: 60,
            width: 60,
            path: "assets/MerchantScreen/exit.png",
            onTap: () {
              context.read<AppState>().heroUnEquipped();
              Navigator.pop(context);
            }),
      ],
    );
  }
}

///
/// Used for making a widget a target widget.
/// Waits after a draggable widget.
/// Merge with the draggable widget if it is relevant.
///
class DragTargetWidget extends StatelessWidget {
  /// Path of the target widget.
  final path;

  /// Name of the target widget.
  final name;

  /// Slot number
  final int i;

  /// Tells if the draggable widget is relevant.
  bool accepted = false;

  DragTargetWidget(
      {@required this.path, @required this.name, @required this.i});

  /// Returns a merged widget or a target widget.
  @override
  Widget build(BuildContext context) {
    /// provider of HeroState
    var x = context.watch<HeroState>();
    return DragTarget(onWillAccept: (data) {
      return true;

      ///we just want to jump into onAccept
    }, onAccept: (Item data) {
      if (name == data.name + '.png') {
        x.remove(data);
        x.statsUpdate(data, i);
        x.itemAccepted(data, i);
        accepted = true;
      }
    }, builder: (context, List<Item> cd, rd) {
      if (accepted) {
        ///corresponding equipment
        return CustomImage(
            height: 50,
            width: 50,
            path: 'assets/HeroScreen/Inventory/slot.png',
            image: CustomImage(
                height: 50, width: 50, path: x.currEquipment[i].image));
      } else {
        ///waiting for a corresponding item
        return x.currEquipment[i] == null
            ? Slot(path: path + name)
            : CustomImage(
                height: 50,
                width: 50,
                path: 'assets/HeroScreen/Inventory/slot.png',
                image: CustomImage(
                    height: 50, width: 50, path: x.currEquipment[i].image));
      }
    });
  }
}

///
/// Displays the actual golds of the hero.
///
class Gold extends StatelessWidget {
  /// Actual orientation of the screen
  final bool orientation;

  /// Size of the widget.
  final double size;
  Gold({@required this.orientation, @required this.size});

  /// Returns a container in which there is a gold image
  /// and a text box containing the number of golds.
  @override
  Widget build(BuildContext context) {
    /// Actual hero gold.
    List<int> gold = context.watch<AppState>().gold;
    return OrientationSwitcher(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      orientation: !this.orientation,
      children: [
        CustomImage(
            width: this.size,
            height: this.size,
            path: 'assets/HeroScreen/Inventory/or.png'),
        Text(
          gold[0].toString(),
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
