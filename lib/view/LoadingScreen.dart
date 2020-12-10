import 'package:flutter/material.dart';
import 'Tools.dart';

///
/// Starting screen used to do any background loading
/// and that can then forward to the next screen.
///
class LoadingScreen extends StatelessWidget {
  /// Asset path.
  final _path = 'assets/LoadingScreen';

  /// Returns a container in which there is a button
  /// widget to navigate to the next screen.
  @override
  Widget build(BuildContext context) {
    /// Actual width and height of the screen.
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    _width = (_height > _width) ? _width : _height;
    _height = (_height > _width) ? _height : _width * 1.5;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage(_path + '/background.png'), fit: BoxFit.cover),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(30)),
              CustomButton(
                width: _width / 2,
                height: _height / 10,
                path: _path + '/BTN.png',
                onTap: () => Navigator.pushReplacementNamed(context, '/select'),
              )
            ]),
      ),
    );
  }
}
