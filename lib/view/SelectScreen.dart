import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:info2051_2018/provider/AppState.dart';
import 'Tools.dart';
import 'package:info2051_2018/provider/SelectState.dart';

///
/// Screen used to select a hero from a list of heroes
/// and that can then forward to the next screen.
///
/// See also :
/// [ChooseHero]
/// [Cell]
/// [Band]
class SelectScreen extends StatelessWidget {
  @override

  /// Returns a container in which there are heroes buttons
  /// widgets and a button to navigate to the next screen.
  /// When a hero is selected, it returns a hero representation.
  Widget build(BuildContext context) {
    /// Actual width and height of the screen
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    _width = (_height > _width) ? _width : _height / 1.2;
    _height = (_height > _width) ? _height : _width / 1.2;

    return ChangeNotifierProvider(
        create: (_) =>
            SelectState(heroes: Provider.of<AppState>(context).heroes),
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/SelectScreen/background.png'),
                fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: (MediaQuery.of(context).size.height >
                    MediaQuery.of(context).size.width)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Cell('cell1', 0, _width / 6, _height / 8),
                          Cell('cell4', 1, _width / 6, _height / 8),
                          Cell('cell7', 2, _width / 6, _height / 8),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Cell('cell2', 6, _width / 6, _height / 8),
                          Cell('cell5', 4, _width / 6, _height / 8),
                          Cell('cell8', 5, _width / 6, _height / 8),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Cell('cell3', 3, _width / 6, _height / 8),
                          Cell('cell6', 7, _width / 6, _height / 8),
                          Cell('cell9', 8, _width / 6, _height / 8),
                        ],
                      ),
                      Band(_height / 1.75, _width / 1.5),
                      ChooseHero(_width / 3, _height / 12),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(padding: EdgeInsets.all(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Cell('cell1', 0, _width / 5, _height / 4),
                              SizedBox(
                                height: 10,
                              ),
                              Cell('cell4', 1, _width / 5, _height / 4),
                              SizedBox(
                                height: 10,
                              ),
                              Cell('cell7', 2, _width / 5, _height / 4),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Cell('cell2', 6, _width / 5, _height / 4),
                              SizedBox(
                                height: 10,
                              ),
                              Cell('cell5', 4, _width / 5, _height / 4),
                              SizedBox(
                                height: 10,
                              ),
                              Cell('cell8', 5, _width / 5, _height / 4),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Cell('cell3', 3, _width / 5, _height / 4),
                              SizedBox(
                                height: 10,
                              ),
                              Cell('cell6', 7, _width / 5, _height / 4),
                              SizedBox(
                                height: 10,
                              ),
                              Cell('cell9', 8, _width / 5, _height / 4),
                            ],
                          ),
                          SizedBox(
                            width: _width / 3,
                          ),
                          Expanded(child: Band(_height / 1.3, _width / 1.9)),
                        ],
                      ),
                      Expanded(child: ChooseHero(_width / 3, _height / 12)),
                    ],
                  ),
          ),
        ));
  }
}

///
/// Used to remember the selected hero and
/// to navigate to the next screen.
///
class ChooseHero extends StatelessWidget {
  /// Actual width and height of the screen
  final _width, _height;
  ChooseHero(this._width, this._height);

  /// Returns a container in which there is a play button.
  Widget build(BuildContext context) {
    /// Actual state of the button
    var state = context.select((SelectState c) => c.state);
    return GestureDetector(
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/SelectScreen/play.png'),
                fit: BoxFit.cover),
          ),
        ),
        onTap: (state == Status.paused)
            ? () {}
            : () {
                int x = Provider.of<SelectState>(context, listen: false).curr;
                Provider.of<AppState>(context, listen: false).currHero = x;
                Navigator.pushReplacementNamed(context, '/home');
              });
  }
}

///
/// Used for displaying a hero.
///
class Cell extends StatelessWidget {
  final _cell, _i, _width, _height;
  Cell(this._cell, this._i, this._width, this._height);

  ///
  /// Returns a hero button.
  ///
  @override
  Widget build(BuildContext context) {
    /// Actual state of the button
    var state = context.select((SelectState c) => c.state);
    return GestureDetector(
        child: CustomImage(
            width: _height,
            height: _width,
            path: 'assets/SelectScreen/' + _cell + '.png'),
        onTap: (state == Status.paused)
            ? () {}
            : () {
                if (Provider.of<SelectState>(context, listen: false).curr != _i)
                  Provider.of<SelectState>(context, listen: false)
                      .changeCurr(_i);
              });
  }
}

///
/// Used for displaying a hero representation.
/// It contains the name and the hero animation and his description.
///
class Band extends StatelessWidget {
  /// Actual width and height of the screen
  final _width;
  final _height;

  Band(this._height, this._width);

  /// Returns a container in which there are a hero
  /// animation.
  @override
  Widget build(BuildContext context) {
    /// The background of the container
    var x = Provider.of<SelectState>(context, listen: false).band;

    /// The hero to animate
    var currHero = Provider.of<SelectState>(context, listen: true).currHero;

    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(x), fit: BoxFit.contain)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CharacterCase(
              currHero.stream,
              'assets/Common/Heroes/${currHero.type}/Idle/idle1.png',
              _height / 1.3,
              _width / 1.1),
          SizedBox(
            height: _height / 5,
          )
        ],
      ),
    );
  }
}
