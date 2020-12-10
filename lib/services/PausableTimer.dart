import 'dart:async';
/// [StartStopTimer] class:
///
/// Used in combat to interrupt the fight every 7 seconds if the player doesn't $
/// play.
/// See also [CombatState]
class StartStopTimer {
  Timer timer;
  Function callback;
  int period;
  StartStopTimer({this.callback, this.period=1});

  void start() {
    this.timer = Timer.periodic(Duration(seconds: period), (Timer t) {callback();});
  }
  void stop() {
    this.timer.cancel();
  }
}