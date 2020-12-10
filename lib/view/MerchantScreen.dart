import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'Tools.dart';
import 'package:provider/provider.dart';
import 'package:info2051_2018/provider/AppState.dart';
import 'package:info2051_2018/provider/MerchantState.dart';
import 'package:info2051_2018/model/Core/Characters/Hero.dart' as p;

///
/// Screen used to buy or sell items from the hero inventory.
/// A merchant (one for weapons another for armor and one for potions)
/// is available to indicate whether an item has been bought or sold.
///
/// See also :
/// [_Exit],
/// [_Choice],
/// [_Merchant],
/// [_MerchantInventory]
///
class MerchantScreen extends StatelessWidget {

  /// Returns a container in which there are an exit button, a merchant,
  /// a select button to choice the right merchant and the merchant inventory,
  /// and a sell mode button.
  @override
  Widget build(BuildContext context) {
    /// Actual width and height of the screen
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    /// Takes the type and the level of the actual hero
    p.Hero x = context.watch<AppState>().currHero;
    /// Takes the gold and the inventory of the actual hero
    var y = context.watch<AppState>();
    return ChangeNotifierProvider(
      create: (_) => MerchantState(x.type, x.level, y.currGold, y.currInventory),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/MerchantScreen/background.png'),
                fit: BoxFit.cover),
          ),
          child: _height > _width
              ? Column(
              children: [
                _Exit(_width, _height),
                _Merchant(height: _height, width: _width),
                _Choice(_height, _width),
                _MerchantInventory(grid: 4),
              ]
          )
              : Row(
              children: [
                Column(
                  children: [
                    _Exit(_width, _height),
                  ],
                ),
                _Merchant(height: _width, width: _height),
                _Choice(_height, _width),
                _MerchantInventory(grid: 3),
              ]
          ),
        ), //child: _items(),
      ),
    );
  }
}

///
/// Exit button for exiting the screen.
///
class _Exit extends StatelessWidget {
  /// Actual width and height of the screen
  final _height;
  final _width;

  _Exit(this._height, this._width);

  /// Returns an exit button widget.
  @override
  Widget build(BuildContext context) {

    /// Exit button state
    var state = context.select((MerchantState c) => c.state);
    /// Asset path
    final String _path = 'assets/MerchantScreen/';

    return _height > _width ?
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(height: 60, width:60, path: _path + "exit.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              var x = Provider.of<MerchantState>(context, listen: false);
              Provider.of<AppState>(context, listen: false).newGold = x.gold;
              Navigator.pushReplacementNamed(context, '/home');
            }),
      ],
    ):
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(height: 75, width:75, path: _path + "exit.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              var x = Provider.of<MerchantState>(context, listen: false);
              Provider.of<AppState>(context, listen: false).newGold = x.gold;
              Navigator.pushReplacementNamed(context, '/home');
            }),
      ],
    );

  }}

///
/// Choice button for selecting the right merchant.
///
class _Choice extends StatelessWidget {
  /// Actual width and height of the screen
  final _height;
  final _width;

  _Choice(this._height, this._width);

  /// Returns a left and right button widget.
  @override
  Widget build(BuildContext context) {
    var state = context.select((MerchantState c) => c.state);
    final String _path = 'assets/MerchantScreen/';

    return _height > _width ?
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(height: 50, width:50, path: _path + "left.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              Provider.of<MerchantState>(context, listen: false).changeCurr(-1);
            }),
        CustomButton(height: 50, width:50, path: _path + "next.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              Provider.of<MerchantState>(context, listen: false).next();
            }),
        CustomButton(height: 50, width:50, path: _path + "right.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              Provider.of<MerchantState>(context, listen: false).changeCurr(1);
            })
      ],
    ):
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(height: 50, width:50, path: _path + "left2.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              Provider.of<MerchantState>(context, listen: false).changeCurr(1);
            }),
        CustomButton(height: 50, width:50, path: _path + "next2.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              Provider.of<MerchantState>(context, listen: false).next();
            }),
        CustomButton(height: 50, width:50, path: _path + "right2.png",
            onTap: (state == Status.paused)
                ? () {}
                : () {
              Provider.of<MerchantState>(context, listen: false).changeCurr(-1);
            })
      ],
    );

  }}

///
/// Displays a merchant animation.
///
class _Merchant extends StatelessWidget {
  /// Actual width and height of the screen
  final height;
  final width;

  _Merchant({@required this.height, @required this.width});

  /// Returns a container in which there is a merchant animation.
  @override
  Widget build(BuildContext context) {
    /// Takes the actual merchant
    var x = Provider.of<MerchantState>(context, listen: true);

    return Container(
      child: CharacterCase(
          x.currMerchant.stream,
          'assets/MerchantScreen/Seller/${x.currMerchant.type}/1.png',
          height / 2.10, width/1.1),
    );
  }
}

///
/// Displays a merchant inventory.
/// Items have a popup menu to describe each of them.
///
class _MerchantInventory extends StatelessWidget {
  /// Number of slots per line
  final grid;

  _MerchantInventory({@required this.grid});

  /// Returns the merchant inventory widget.
  @override
  Widget build(BuildContext context) {
    List<Item> items = context.watch<MerchantState>().currInventory;
    var state = context.select((MerchantState c) => c.state);
    var x = context.watch<MerchantState>();
    return Inventory(grid: grid, items: items, nbSlots: 9,
        draggable: false,
        onTap: (state == Status.paused)
            ? () {}
            : (i, item) {
          x.itemAction(i, item);
        },
        onLongPress: (element) {
            popupMenu(
                [element], context, context.findRenderObject() as RenderBox, 60);
          });
  }
}
