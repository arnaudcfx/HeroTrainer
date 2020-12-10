
import 'package:flutter/material.dart';
import 'package:info2051_2018/model/Core/Characters/Heroes/Mage.dart';
import 'package:info2051_2018/model/Core/Characters/Heroes/Rogue.dart';
import 'package:info2051_2018/model/Core/Characters/Heroes/Warrior.dart';
import 'package:info2051_2018/model/Core/Characters/Heroes/Barbarian.dart';
import 'package:info2051_2018/model/Core/Characters/Heroes/Assassin.dart';
import 'package:info2051_2018/model/Core/Characters/Heroes/Warlock.dart';
import 'package:info2051_2018/view/CraftScreen.dart';
import 'package:info2051_2018/view/MerchantScreen.dart';
import 'package:provider/provider.dart';
import 'package:info2051_2018/provider/AppState.dart';
import 'package:info2051_2018/view/CombatScreen.dart';
import 'package:info2051_2018/view/HeroScreen.dart';
import 'package:info2051_2018/view/HomeScreen.dart';
import 'package:info2051_2018/view/LoadingScreen.dart';
import 'package:info2051_2018/view/SelectScreen.dart';
import 'model/Core/Characters/Character.dart';
import 'model/Core/Characters/Heroes/Priest.dart';
import 'model/Core/Characters/Heroes/Paladin.dart';
import 'model/Core/Characters/Heroes/Terrorist.dart';

///
/// Entry point of our program.
/// It initializes the global AppState provider and Launches our
/// widget root [MyApp].
///
void main() {

  List<Character> heroes = new List<Character>(9);
  heroes[0] = new Warrior();
  heroes[1] = new Rogue();
  heroes[2] = new Mage();
  heroes[3] = new Barbarian();
  heroes[4] = new Terrorist();
  heroes[5] = new Warlock();
  heroes[6] = new Paladin();
  heroes[7] = new Assassin();
  heroes[8] = new Priest();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (BuildContext context) =>
          AppState(heroes: heroes),
    ),
  ], child: MyApp()));
}
/// Widget root of our application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      title: 'Hero Trainer',
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(),
        '/home': (context) => HomeScreen(),
        '/craft': (context) => CraftScreen(),
        '/merchant': (context) => MerchantScreen(),
        '/hero': (context) => HeroScreen(),
        '/combat': (context) => CombatScreen(),
        '/select': (context) => SelectScreen(),
      },
    );
  }
}
