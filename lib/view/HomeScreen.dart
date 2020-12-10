import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Tools.dart';
import 'package:provider/provider.dart';
import 'package:info2051_2018/provider/AppState.dart';

///
/// Screen used to navigate between the craft screen,
/// the combat screen, the shop and the hero inventory.
/// The user can also save his game at any time and he can
/// see his highest stage achieved so far.
///
class HomeScreen extends StatelessWidget {
  /// Returns a container in which there are a description
  /// window, five buttons widgets (craft, monster, shop, inventory, save),
  /// and a text box containing the highest stage achieved.
  @override
  Widget build(BuildContext context) {
    /// Actual width and height of the screen.
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    _width = (_height > _width) ? _width : _height;
    _height = (_height > _width) ? _height : _width * 1.5;

    /// Stage achieved.
    var stage = context.select((AppState a) => a.maxStage);

    /// State of the saving button, used to display a waiting animation when
    /// needed.
    var status = context.select((AppState a) => a.saving);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('assets/HomeScreen/background.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20)),
            CustomImage(
                width: _width,
                height: _height / 5,
                path: 'assets/HomeScreen/dialog.png'),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomButton(
                width: _width / 5,
                height: _height / 7.5,
                path: 'assets/HomeScreen/craft.png',
                onTap: () => Navigator.pushNamed(context, '/craft'),
              ),
              CustomButton(
                width: _width / 4,
                height: _height / 6.5,
                path: 'assets/HomeScreen/monster.png',
                onTap: () {
                  context.read<AppState>().audioPlayer.play(
                      "https://wingless-seraph.net/material/Battle-Rosemoon.mp3",
                      isLocal: false);
                  Navigator.pushReplacementNamed(context, '/combat');
                },
              ),
              CustomButton(
                width: _width / 5,
                height: _height / 8.5,
                path: 'assets/HomeScreen/seller.png',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/merchant'),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomButton(
                width: _width / 5,
                height: _height / 7.5,
                path: 'assets/HomeScreen/inventory.png',
                onTap: () => Navigator.pushNamed(context, '/hero'),
              ),
              status == false
                  ? CustomButton(
                      width: _width / 5,
                      height: _height / 7.5,
                      path: 'assets/HomeScreen/tape_yellow.png',
                      onTap: () {
                        context.read<AppState>().saveAll();
                      })
                  : CircularProgressIndicator(
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.red[500]),
                    )
            ]),
            SizedBox(height: 2),
            Text("The Highest stage you achieved to reach is : ",
                style: TextStyle(fontSize: 15)),
            Text(
              "" + stage[0].toString() + "-" + stage[1].toString(),
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey[750],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
