import 'dart:math';
import 'package:flutter/material.dart';
import 'package:info2051_2018/services/EnemyGenerator.dart';
import 'package:info2051_2018/model/Core/Objects/Items.dart';
import 'package:info2051_2018/provider/CombatState.dart';
import 'package:info2051_2018/view/Tools.dart';
import 'package:provider/provider.dart';
import '../provider/AppState.dart';

/// [CombatScreen] class:
///
/// This Widget is the root of the widget tree responsible for displaying the
/// combat.
/// It also initializes the [ChangeNotifierProvider] available to all the widgets
/// in its subtree.
///
/// See also: [_ActionsPart] and [_CombatPart]
class CombatScreen extends StatelessWidget {
  /// Used to randomly select a combat background.
  final int _number = new Random().nextInt(4);
  final String _path = 'assets/CombatScreen';

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    var currStage = context.select((AppState a) => a.tmpStage);
    var orientation = _height > _width ? true : false;
    _width = (orientation) ? _width : _width / 1.7;
    _height = (orientation) ? _height / 1.8 : _height;

    return ChangeNotifierProvider(
      create: (_) => CombatState(characters: [
        Provider.of<AppState>(context, listen: false).heroEquipped(),
        (currStage[1] == 10)
            ? EnemyGenerator.generateBoss(
                Provider.of<AppState>(context, listen: false).currHero.level)
            : EnemyGenerator.generateEnemy(
                Provider.of<AppState>(context, listen: false).currHero.level),
      ], inventory: Provider.of<AppState>(context, listen: false).inventory),
      child: SafeArea(
          child: OrientationSwitcher(
        orientation: orientation,
        children: [
          Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    AssetImage(_path + "/background/battleground$_number.png"),
              ),
            ),
            child: _CombatPart(_height / 2, _width),
          ),
          Expanded(
            child: Container(
              width: _width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.8), BlendMode.dstATop),
                  image: AssetImage("assets/CombatScreen/OnLose/border.png"),
                ),
              ),
              child: _ActionsPart(height: _height / 2, width: _width),
            ),
          )
        ],
      )),
    );
  }
}

/// [_CombatPart] class:
///
/// This Widget is responsible for displaying the combat visual elements:
/// the [Character] and their animations.
///
/// See also: [_HealthBar] and [_ListEffects]
class _CombatPart extends StatelessWidget {
  final _height;
  final _width;

  _CombatPart(this._height, this._width);
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CombatState>(context, listen: false);

    var timeLeft = context.watch<CombatState>().spt;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HealthBar(
              choice: 1,
              width: this._width,
              height: this._height,
            ),
            CircularProgressIndicator(
              value: (timeLeft) / 7,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[500]),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CharacterCase(
                state.characters[0].stream,
                '${state.characters[0].path}/base.png',
                this._height,
                this._width / 2),
            CharacterCase(
                state.characters[1].stream,
                '${state.characters[1].path}/base.png',
                this._height,
                this._width / 2)
          ],
        ),
        _HealthBar(
          choice: 0,
          width: this._width,
          height: this._height,
        ),
      ],
    );
  }
}

/// [_ListEffects] class:
///
/// This Widget is responsible for displaying the effects affecting a [Character]
///
/// See also: [Effect]
class _ListEffects extends StatelessWidget {
  /// int provided to chose the character
  final int index;

  _ListEffects({@required this.index});

  @override
  Widget build(BuildContext context) {
    var effects = context.select((CombatState c) => c.effects[index]);
    return Container(
      height: 30,
      width: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: effects
            .map(
              (i) => Padding(
                padding: const EdgeInsets.all(3.0),
                child: CustomButton(
                  height: 40,
                  width: 40,
                  path: i.path,
                  onLongPress: () {
                    showMenu(
                        position: RelativeRect.fromLTRB(100, 400, 100, 400),
                        context: context,
                        items: [
                          PopupMenuItem(
                            value: 0,
                            child: Column(
                              children: [
                                Text(i.description),
                              ],
                            ),
                          )
                        ]);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// [_HealthBar] class:
///
/// This Widget is responsible for displaying the status of a [Character]
/// Health, mana left, dodged attacks and [Effect] affecting the Character.
///
/// See also: [_ListEffects]
class _HealthBar extends StatelessWidget {
  /// int provided to chose the character
  final choice;
  final width;
  final height;
  _HealthBar(
      {@required this.choice, @required this.width, @required this.height});

  @override
  Widget build(BuildContext context) {
    String path;
    var x = Provider.of<CombatState>(context, listen: false);
    var imgWidth = this.width / 4, imgHeight = this.height / 2;

    var currHp = context.select((CombatState c) => c.stats[choice].health);
    var dodged = context.select((CombatState c) => c.dodged[choice]);
    var maxHp = x.characters[choice].combatStats.health;
    imgWidth /= 2;
    imgHeight /= 1.5;

    switch (choice) {
      case 0:
        path = '${x.characters[0].path}/circle.png';
        break;
      case 1:
        path = '${x.characters[1].path}/circle.png';
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImage(height: imgWidth, width: imgHeight, path: path),
        Container(
          child: Column(
            children: [
              Stack(
                fit: StackFit.loose,
                children: [
                  SizedBox(
                    width: this.width / 2,
                    height: this.height / 10,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                  AnimatedContainer(
                    width: (this.width / 2) * (currHp / maxHp),
                    height: this.height / 10,
                    duration: Duration(milliseconds: 200),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              "assets/CombatScreen/Frames/Main/Bars/UnitFrame_HP_Fill_Red.png"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: this.width / 3,
                      height: this.height / 10,
                      child: Center(
                        child: Text(
                          "$currHp/$maxHp",
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[700],
                              decoration: TextDecoration.none),
                        ),
                      )),
                ],
              ),
              _Bar(
                  width: this.width / 3,
                  height: 10,
                  choice: 1,
                  character: this.choice),
              dodged == true
                  ? Text("dodged",
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.red[700],
                          decoration: TextDecoration.none))
                  : SizedBox(
                      height: 10,
                    ),
              _ListEffects(index: choice),
            ],
          ),
        ),
      ],
    );
  }
}

/// [_ActionsPart] class:
///
/// This Widget is responsible for displaying the combat interactive elements for
/// Player interaction.
/// It is also responsible for displaying the win and lose widgets when needed.
///
/// See also: [_Win] and [_Lose]
class _ActionsPart extends StatelessWidget {
  final height;
  final width;

  _ActionsPart({@required this.height, @required this.width});
  @override
  Widget build(BuildContext context) {
    // Dynamic rendering that depends on the phone size and screen resolution.
    var _width = this.width;
    var _height = this.height;
    _width = (_height > _width) ? _width : _height / 1.5;
    _height = (_height > _width) ? _height / 1.4 : _width;

    // Getting state information
    var state = context.select((CombatState c) => c.game);
    var turn = context.select((CombatState c) => c.currentTurn);
    var stage = context.select((AppState a) => a.tmpStage);
    var x = Provider.of<CombatState>(context, listen: false);

    return (state == Status.playing)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    height: _height / 1.1,
                    width: _width / 1.1,
                    path:
                        'assets/CombatScreen/${x.characters[0].type}/attack.png',
                    onTap: (turn != States.playerTurn)
                        ? () {}
                        : () {
                            context
                                .read<CombatState>()
                                .interact(HeroAction.physicalAttack);
                          },
                  ),
                  CustomButton(
                    height: _height / 1.1,
                    width: _width / 1.1,
                    path:
                        'assets/CombatScreen/${x.characters[0].type}/magic.png',
                    onTap: (turn != States.playerTurn)
                        ? () {}
                        : () async {
                            RenderBox rb =
                                context.findRenderObject() as RenderBox;
                            int chosen = await popupMenu(
                                x.characters[0].spells, context, rb, 30);

                            if (chosen != null) {
                              context.read<CombatState>().interact(
                                  HeroAction.magicalAttack,
                                  index: chosen);
                            }
                          },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    height: _height / 1.1,
                    width: _width / 1.1,
                    path: 'assets/CombatScreen/inventory.png',
                    onTap: (turn != States.playerTurn)
                        ? () {}
                        : () async {
                            RenderBox rb =
                                context.findRenderObject() as RenderBox;
                            int chosen =
                                await popupMenu(x.potions, context, rb, 30);

                            if (chosen != null) {
                              context
                                  .read<CombatState>()
                                  .interact(HeroAction.potion, index: chosen);
                            }
                          },
                  ),
                ],
              ),
              Text("" + stage[0].toString() + "-" + stage[1].toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.brown[800],
                      decoration: TextDecoration.none)),
            ],
          )
        : (turn == States.won
            ? _Win(
                width: this.width,
                height: this.height,
              )
            : _Lose(
                width: this.width,
                height: this.height,
              ));
  }
}

/// [_Win] class:
///
/// This Widget is responsible for displaying the information on the won fight.
///
/// See also:  [_Lose]
class _Win extends StatelessWidget {
  final double width;
  final double height;
  _Win({this.width = 200, this.height = 200});

  @override
  Widget build(BuildContext context) {
    var currGold = context.watch<CombatState>().gold;
    var currStage = context.select((AppState a) => a.tmpStage);
    var maxStage = context.select((AppState a) => a.maxStage);
    Item x = context.watch<CombatState>().item;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: this.width / 2,
          height: this.height / 2,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.scaleDown,
              image: AssetImage("assets/CombatScreen/OnWin/winbg.png"),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: this.height / 3.2,
                ),
                Text(
                  'You won!',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[700],
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ),
        _Bar(
          width: this.width / 2,
          height: this.height / 9,
          choice: 0,
          character: 0,
        ),
        SizedBox(
          height: 10,
          width: this.width,
        ),
        Container(
          height: this.height / 2,
          width: this.width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.scaleDown,
              image: AssetImage("assets/CombatScreen/OnLose/border.png"),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Gold Won : $currGold',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
              Text(
                'Object Won : ${x.name}',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                height: this.height / 8,
                width: this.width / 3,
                path: 'assets/CombatScreen/OnLose/button.png',
                onTap: () {
                  currStage[1] += 1;
                  if (currStage[1] == 11) currStage = [currStage[0] + 1, 0];
                  if (currStage[0] > maxStage[0] ||
                      (currStage[0] == maxStage[0] &&
                          currStage[1] > maxStage[1])) {
                    context.read<AppState>().maxStage = List.from(currStage);
                  }
                  context.read<AppState>().tmpStage = List.from(currStage);

                  context.read<AppState>().currGold = currGold;
                  context.read<AppState>().item = x;
                  context.read<AppState>().heroUnEquipped();
                  Navigator.pushReplacementNamed(context, '/combat');
                },
                text: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                )),
            CustomButton(
                height: this.height / 8,
                width: this.width / 3,
                path: 'assets/CombatScreen/OnLose/button.png',
                onTap: () {
                  currStage[1] += 1;
                  if (currStage[1] == 11) currStage = [currStage[0]++, 0];
                  if (currStage[0] > maxStage[0] ||
                      (currStage[0] == maxStage[0] &&
                          currStage[1] > maxStage[1])) {
                    context.read<AppState>().maxStage = List.from(currStage);
                  }
                  context.read<AppState>().tmpStage = [0, 0];
                  context.read<AppState>().currGold = currGold;
                  context.read<AppState>().item = x;
                  context.read<AppState>().heroUnEquipped();
                  context.read<AppState>().audioPlayer.stop();
                  Navigator.pushReplacementNamed(context, '/home');
                },
                text: Center(
                  child: Text(
                    'Quit',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                ))
          ],
        )
      ],
    );
  }
}

/// [_Lose] class:
///
/// This Widget is responsible for displaying the information on the lost fight.
///
/// See also: [_Win]
class _Lose extends StatelessWidget {
  final double width;
  final double height;

  _Lose({this.width = 200, this.height = 200});

  @override
  Widget build(BuildContext context) {
    var currStage = context.select((AppState a) => a.tmpStage);
    var maxStage = context.select((AppState a) => a.maxStage);
    var currGold = context.watch<CombatState>().gold;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/CombatScreen/OnLose/lossbg.png",
          height: this.height / 2,
          width: this.width / 2.1,
        ),
        Text(
          'Defeat',
          style: TextStyle(
              fontSize: 20,
              color: Colors.amber[550],
              decoration: TextDecoration.none),
        ),
        Container(
          height: this.height / 2,
          width: this.width / 2,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.scaleDown,
              image: AssetImage("assets/CombatScreen/OnLose/border.png"),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gold Lost : $currGold',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    height: this.height / 4,
                    width: this.width / 4,
                    path: 'assets/CombatScreen/OnLose/button.png',
                    onTap: () {
                      if (currStage[0] > maxStage[0] ||
                          (currStage[0] == maxStage[0] &&
                              currStage[1] > maxStage[1])) {
                        context.read<AppState>().maxStage =
                            List.from(currStage);
                      }
                      context.read<AppState>().tmpStage = [0, 0];
                      context.read<AppState>().heroUnEquipped();
                      context.read<AppState>().currGold = -currGold;
                      Navigator.pushReplacementNamed(context, '/combat');
                    },
                    text: Center(
                      child: Text(
                        'replay',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                    )),
              ),
              CustomButton(
                  height: this.height / 4,
                  width: this.width / 4,
                  path: 'assets/CombatScreen/OnLose/button.png',
                  onTap: () {
                    if (currStage[0] > maxStage[0] ||
                        (currStage[0] == maxStage[0] &&
                            currStage[1] > maxStage[1])) {
                      context.read<AppState>().maxStage = List.from(currStage);
                    }
                    context.read<AppState>().tmpStage = [0, 0];
                    context.read<AppState>().heroUnEquipped();
                    context.read<AppState>().currGold = -currGold;

                    context.read<AppState>().audioPlayer.stop();
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  text: Center(
                    child: Text(
                      'Quit',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}

/// [_Bar] class:
///
/// Multi-purpose bar widget. Used for displaying xp and mana changes.
///

class _Bar extends StatelessWidget {
  final double width;
  final double height;
  final int choice;
  final int character;
  _Bar({this.width, this.height, this.choice, this.character});

  @override
  Widget build(BuildContext context) {
    var value;
    var maxValue;
    switch (choice) {
      case 0:
        value = context.select((CombatState c) => c.characters[0].xp);
        maxValue = context.select((CombatState c) => c.characters[0].maxXp);
        break;
      case 1:
        value = context.select((CombatState c) => c.stats[character].mana);
        maxValue = context.select(
            (CombatState c) => c.characters[character].combatStats.mana);
    }

    return Container(
      child: Stack(
        fit: StackFit.loose,
        children: [
          SizedBox(
            width: this.width,
            height: this.height,
            child: const DecoratedBox(
              decoration: const BoxDecoration(color: Colors.white),
            ),
          ),
          AnimatedContainer(
            width: this.width * (value / maxValue),
            height: this.height,
            duration: Duration(milliseconds: 1500),
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      "assets/CombatScreen/Frames/Main/Bars/UnitFrame_Party_MP_Fill_Blue.png"),
                ),
              ),
            ),
          ),
          SizedBox(
              width: this.width,
              height: this.height,
              child: Center(
                child: Text(
                  "$value/$maxValue",
                  style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[700],
                      decoration: TextDecoration.none),
                ),
              )),
        ],
      ),
    );
  }
}
