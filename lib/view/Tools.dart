import 'package:flutter/material.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'dart:async';

/// Custom Widget that displays images.
class CustomImage extends StatelessWidget {
  /// Size of the image.
  final double height, width;

  /// Url path of the image.
  final String path;

  /// Second image to display on top of the first one, optional.
  final Widget image;

  CustomImage(
      {@required this.height,
      @required this.width,
      @required this.path,
      this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.contain),
      ),
      child: this.image ?? this.image,
    );
  }
}

/// Custom Button used to simplify and unify the use of buttons across the app.
class CustomButton extends StatelessWidget {
  /// Size of the button.
  final double height, width;

  /// Url path of the clickable image.
  final String path;

  /// Functions that define the button behavior.
  final Function onTap, onLongPress;

  /// Text to be displayed on the button, optional.
  final Widget text;

  CustomButton(
      {@required this.height,
      @required this.width,
      @required this.path,
      this.onTap,
      this.onLongPress,
      this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            //color: Colors.black
            image:
                DecorationImage(image: AssetImage(path), fit: BoxFit.scaleDown),
          ),
          child: this.text ?? this.text,
        ),
        onTap: onTap,
        onLongPress: onLongPress);
  }
}

class CharacterCase extends StatelessWidget {
  final Stream _stream;
  final String _path;
  final double _width;
  final double _height;

  CharacterCase(this._stream, this._path, this._height, this._width);
  @override
  Widget build(BuildContext context) {
    //print('rebuilding cases');
    return StreamBuilder<String>(
        stream: _stream,
        initialData: this._path,
        builder: (context, snapshot) {
          return Image.asset(
            snapshot.data,
            height: _height,
            gaplessPlayback: true,
            width: _width,
            fit: BoxFit.contain,
          );
        });
  }
}

//HERE the draggable widget
class DraggableWidget extends StatelessWidget {
  Item item;
  final path;
  final Function onLongPress;
  DraggableWidget(this.item, this.path, this.onLongPress);

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: item,
        childWhenDragging: Container(
            height: 10.0,
            width: 10.0,

            //widget in backward
            child: CustomImage(height: 50, width: 50, path: this.path)),

        //see widget when dragged
        feedback: Container(
          child: CustomButton(
              height: 50,
              width: 50,
              path: item.image,
              onTap: null,
              onLongPress: null),
        ),

        //curr widget
        child: CustomImage(
          height: 50,
          width: 50,
          path: this.path,
          image: CustomButton(
              height: 50,
              width: 50,
              path: item.image,
              onTap: null,
              onLongPress: () => onLongPress(item)),
        ));
  }
}

class Slot extends StatelessWidget {
  final String path;
  final bool draggable;
  final item, i;
  final Function onTap, onLongPress;

  Slot(
      {@required this.path,
      this.item,
      this.i,
      this.draggable,
      this.onTap,
      this.onLongPress});
  @override
  Widget build(BuildContext context) {
    return draggable == true
        ? item == null
            ? CustomImage(height: 50, width: 50, path: this.path)
            : DraggableWidget(item, path, onLongPress)
        : item == null
            ? CustomImage(height: 50, width: 50, path: this.path)
            : CustomImage(
                height: 50,
                width: 50,
                path: this.path,
                image: Column(
                  children: [
                    CustomButton(
                        height: 70,
                        width: 70,
                        path: this.item.image,
                        onTap: () => onTap(i, item),
                        onLongPress: () => onLongPress(item)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImage(
                            width: 10,
                            height: 10,
                            path: 'assets/HeroScreen/Inventory/or.png'),
                        Text(
                          item.gold.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
  }
}

class Inventory extends StatelessWidget {
  final bool draggable;
  final grid, items, nbSlots;
  final Function onTap, onLongPress;

  Inventory(
      {@required this.grid,
      @required this.items,
      @required this.nbSlots,
      @required this.draggable,
      this.onTap,
      this.onLongPress});

  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        shrinkWrap: true,
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: grid,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(nbSlots, (index) {
          return Slot(
              path: 'assets/HeroScreen/Inventory/slot.png',
              item: (index > items.length - 1) ? null : items[index],
              i: index,
              draggable: draggable,
              onTap: onTap,
              onLongPress: onLongPress);
        }),
      ),
    );
  }
}

/// Method used to display a popup menu and return the [PopupMenuItem]'s value
/// chosen from it.
Future<int> popupMenu(List elements, BuildContext context, RenderBox position,
    double size) async {
  return elements.length == 0
      ? null
      : await showMenu(
          position: RelativeRect.fromLTRB(100, 400, 100, 400),
          context: context,
          items: elements.map((element) {
            return PopupMenuItem(
                value: elements.indexOf(element),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomImage(
                              height: size, width: size, path: element.image),
                          Text(element.name,
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ]),
                    Column(
                      children: element.stats.base.entries.map<Widget>((entry) {
                        return (entry.value != 0)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 16),
                                  ),
                                  CustomImage(
                                      height: 20,
                                      width: 20,
                                      path: "assets/arrow.png"),
                                  Text(
                                    '+' + entry.value.toString(),
                                    style: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 15),
                                  ),
                                ],
                              )
                            : SizedBox();
                      }).toList(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(element.description),
                    Text("Cost: " + element.cost.toString()),
                    (elements.length > 1)
                        ? OrientableDivider(orientation: true)
                        : SizedBox(),
                  ],
                ));
          }).toList(),
          elevation: 8.0,
        );
}

/// Class used to provide an easy way to make the screen rerender correctly
/// depending on its orientation.
class OrientationSwitcher extends StatelessWidget {
  final List<Widget> children;
  final orientation;
  final mainAxisAlignment;

  const OrientationSwitcher(
      {this.children,
      this.orientation,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return orientation
        ? Column(mainAxisAlignment: this.mainAxisAlignment, children: children)
        : Row(mainAxisAlignment: this.mainAxisAlignment, children: children);
  }
}
/// Class used to provide an easy way to render an horizontal or a vertical
/// [Divider] depending  on the orientationof the screen.
class OrientableDivider extends StatelessWidget {
  final bool orientation;
  final double thickness;
  final color;

  const OrientableDivider(
      {this.orientation, this.thickness = 2, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return orientation
        ? Divider(
            thickness: this.thickness,
            color: this.color,
          )
        : VerticalDivider(
            thickness: this.thickness,
            color: this.color,
          );
  }
}
