import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:info2051_2018/model/Core/Characters/Character.dart';
import 'package:path_provider/path_provider.dart';
import 'package:info2051_2018/model/Core/Statistics/Stats.dart';

/// [SavingLoadingService] class:
///
/// Class used to take car of all the methods related to loading or saving
/// data from/to the memory of the phone.
///
/// See also [AppState]
class SavingLoadingService{

  /// Method used to retrieve the local path where the data related to this app
  /// is stored on the phone.
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  /// Method used to retrieve the local file associated with the input name
  static Future<File> _localFile(String name) async {
    final path = await _localPath;
    return File('$path/$name.json');
  }

  /// Method used to store a character statistics in the memory of the phone
  static Future<void> saveHero(Character c) async {
    final file = await _localFile(c.subType);
    /// clear the file.
    file.writeAsStringSync("");
    String jsonString = jsonEncode(c.baseStats.base);
    /// write to the file
    file.writeAsString(jsonString);
  }

  /// Method used to load a character statistics in the memory of the phone
  static Future<Stats> loadHero(String type) async {
    final file = await _localFile(type);
    final fileExists = await file.exists();
    if(fileExists){
      try {
        String jsonString  = await file.readAsString();
        Stats json = new Stats.fromJson(jsonDecode(jsonString));
        return json;
      } catch (e) {
        print('Tried reading _file error: $e');
        return null;
      }
    }
    return null;
  }
  /// Method used to load a list of primitives types.
  static Future<List> loadList(String type) async {
    final file = await _localFile(type);
    final fileExists = await file.exists();

    if(fileExists){
      try {
        String jsonString  = await file.readAsString();
        List json = jsonDecode(jsonString);
        return json;
      } catch (e) {
        print('Tried reading _file error: $e');
        return null;
      }
    }
    return null;
  }
  /// Method used to load a list of objects in the memory of the phone at a
  /// specified location.
  /// Each Object must implement the toJson() method.
  static Future<void> saveListObjects(List input, String location) async {
    final file = await _localFile(location);
    String jsonString = jsonEncode(input);
    file.writeAsString(jsonString);
  }
  /// Method used to save a list of elements in the memory of the phone at a
  /// specified location.
  /// Each element must implement the toJson() method.
  static Future<void> saveList(List input, String location) async {
    final file = await _localFile(location);
    String jsonString = jsonEncode(input);
    file.writeAsString(jsonString);
  }
}
