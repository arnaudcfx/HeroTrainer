import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'Tools.dart';
import 'package:provider/provider.dart';
import 'package:info2051_2018/provider/AppState.dart';
import 'package:info2051_2018/provider/CraftState.dart';
import 'package:info2051_2018/model/Core/Characters/Hero.dart' as p;

///
/// Screen used to craft an item from two items of the same type.
/// A magician is available to indicate whether the craft occurs or not.
///
/// See also :
/// [CraftInventory],
/// [DragTargetWidget],
/// [Craft],
/// [Magician]
///
class CraftScreen extends StatelessWidget {
  /// Asset path.
  final String path = 'assets/CraftScreen';

  /// Returns a container in which there are a seller, a craft box
  /// and the hero inventory.
  @override
  Widget build(BuildContext context) {
    /// Actual width and height of the screen.
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    /// Takes the type and the level from the actual hero.
    p.Hero x = context.watch<AppState>().currHero;

    /// Actual hero inventory.
    List<Item> items = context.watch<AppState>().currInventory;
    return ChangeNotifierProvider(
      create: (_) => CraftState(x.type, x.level, items),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('$path/background.jpg'), fit: BoxFit.cover),
          ),
          child: _height > _width
              ? Column(children: [
                  SizedBox(height: 250),
                  Magician(height: _height, width: _width),
                  SizedBox(height: 25),
                  Craft(height: _height, width: _width),
                  CraftInventory(grid: 6),
                ])
              : Row(children: [
                  SizedBox(
                    width: 237,
                  ),
                  Magician(height: _width, width: _height / 2),
                  Craft(height: _height, width: _width),
                  CraftInventory(grid: 4),
                ]),
        ), //child: _items(),
      ),
    );
  }
}

///
/// Display the hero inventory.
///
class CraftInventory extends StatelessWidget {
  /// Number of slots per line.
  final grid;

  CraftInventory({this.grid});

  /// Returns an inventory container.
  Widget build(BuildContext context) {
    /// Takes the magician inventory.
    var x = context.watch<CraftState>();
    return Inventory(
        grid: grid,
        items: x.currInventory,
        nbSlots: 90,
        draggable: true,
        onLongPress: (element) {
          popupMenu(
              [element], context, context.findRenderObject() as RenderBox, 60);
        });
  }
}

///
/// Craft box used for crafting an item from
/// two items of the same type.
///
class Craft extends StatelessWidget {
  /// Actual width and height of the screen.
  final height;
  final width;

  Craft({@required this.height, @required this.width});

  /// Returns two target slots and one craft button.
  @override
  Widget build(BuildContext context) {
    /// Button craft state.
    var state = context.select((CraftState c) => c.state);

    /// Path asset.
    final String path = 'assets/CraftScreen/';

    return height > width
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            DragTargetWidget(path: 'assets/CraftScreen/orb.gif', i: 0),
            CustomButton(
                height: 80,
                width: 80,
                path: path + "craft.png",
                onTap: (state == Status.paused)
                    ? () {}
                    : () {
                        Provider.of<CraftState>(context, listen: false).craft();
                      }),
            DragTargetWidget(path: 'assets/CraftScreen/orb.gif', i: 1),
          ])
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DragTargetWidget(path: 'assets/CraftScreen/orb.gif', i: 0),
              CustomButton(
                  height: 80,
                  width: 80,
                  path: path + "d.png",
                  onTap: (state == Status.paused)
                      ? () {}
                      : () {
                          Provider.of<CraftState>(context, listen: false)
                              .craft();
                        }),
              DragTargetWidget(path: 'assets/CraftScreen/orb.gif', i: 1),
            ],
          );
  }
}

///
/// Display a magician animation when the button craft is pressed:
/// It tells whether the items are relevant or not.
///
class Magician extends StatelessWidget {
  /// Actual width and height of the screen.
  final height;
  final width;
  final String path = 'assets/CraftScreen/Magician';

  Magician({@required this.height, @required this.width});

  /// Returns the magician animation.
  @override
  Widget build(BuildContext context) {
    var x = Provider.of<CraftState>(context, listen: true);

    return Container(
      child: Row(
        children: [
          CharacterCase(
              x.currMagician.stream, '$path/base.png', height / 4.5, width),
        ],
      ),
    );
  }
}

///
/// Used for making a widget a target widget.
/// Waits after a draggable widget.
/// Merge with the draggable widget if it is relevant.
///
class DragTargetWidget extends StatelessWidget {
  /// Path of the target widget
  final path;

  /// Slot number
  int i;

  /// Filled with the draggable widget if it is relevant
  Item item;

  /// Tells if the draggable widget is relevant
  bool accepted = false;

  DragTargetWidget({@required this.path, @required this.i});

  /// Returns a merged widget or a target widget.
  @override
  Widget build(BuildContext context) {
    /// Provider of CraftState
    var x = context.watch<CraftState>();
    return DragTarget(onWillAccept: (data) {
      return true;

      /// we just want to jump into onAccept
    }, onAccept: (Item data) {
      x.remove(data);
      x.itemAccepted(data, i);
      item = data;
      accepted = true;
    }, builder: (context, List<Item> cd, rd) {
      if (accepted) {
        /// merge
        return CustomImage(
            height: 70,
            width: 70,
            path: path,
            image: CustomImage(height: 50, width: 50, path: item.image));
      } else {
        /// waiting for a corresponding item
        return CustomImage(height: 70, width: 70, path: path);
      }
    });
  }
}
