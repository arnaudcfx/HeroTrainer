import 'dart:async';
import 'package:flutter/material.dart';

/// [Animation] class:
/// This class is used to display the animations.

class Animation {
  /// Path of the directory containing the images of the animation.
  final String path;

  /// Number of images the animation is made off.
  final int range;

  /// returns an [Animation] object.
  Animation({@required this.range, @required this.path});

  /// Display the animation by putting each image path into the stream.
  void display(StreamController stream) async {
    for (int i = 1; i <= this.range; i++) {
      await Future.delayed(const Duration(milliseconds: 80), () {
        stream.add('$path$i.png');
      });
    }
  }
}
