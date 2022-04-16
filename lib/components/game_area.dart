import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:love_letters/common/constants.dart';
import 'package:love_letters/common/providers/repository.dart';
import 'package:love_letters/components/pigeon.dart';
import 'package:love_letters/components/player_container.dart';
import 'package:love_letters/components/power_meter.dart';
import 'package:love_letters/components/won.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bg_image.dart';
import 'castle1.dart';
import 'castle2.dart';
import 'love_letter.dart';

class GameArea extends ConsumerStatefulWidget {
  const GameArea({Key? key}) : super(key: key);

  @override
  ConsumerState<GameArea> createState() => _GameAreaState();
}

class _GameAreaState extends ConsumerState<GameArea>
    with TickerProviderStateMixin {
  double defaultBottom = kDefaultBottom;
  double widgetMinWidth = 0.0;
  double widgetMaxWidth = 0.0;
  double widgetMaxHeight = 0.0;
  double currentValue = 0.0;
  bool animatingPigeon = true;
  bool won = false;

  late OverlayEntry? overlayEntry;
  bool _isVisible = false;

  double left = 0.0;
  FlightDirection flightDirection = FlightDirection.right;
  late final AnimationController _controller;

  Duration duration = const Duration(milliseconds: 3000);
  Curve curve = Curves.easeInOut;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    );
    _controller.repeat(min: 0.01, max: 0.97, reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_isVisible) {
      hideWinOverlay();
    }
    super.dispose();
  }

  void hideWinOverlay() {
    _isVisible = false;
    overlayEntry?.remove();
    overlayEntry = null;
  }

  showWinOverlay() async {
    if (!_isVisible) {
      overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(overlayEntry!);
      _isVisible = true;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final text =
        flightDirection == FlightDirection.right ? 'Player 1' : 'Player 2';
    return OverlayEntry(
      builder: (context) => WonOverlay(restart: reset, text: text),
    );
  }

  onStopMeter() {
    setState(() {
      print('stop...');
      _controller.stop();
      var auxValue = _controller.value;
      print('animate pigeon..');
      double leftLimit = widgetMaxWidth;
      var realValue = 0.0;
      if (auxValue > 0.4 && auxValue < 0.6) {
        realValue = auxValue;
        if (flightDirection == FlightDirection.left) {
          left = 0.0;
          print('flying left $left');
        } else {
          left = leftLimit;
          print('flying right $left');
        }
      } else {
        if (auxValue >= 0.6) {
          realValue = 1 - auxValue;
        }
        if (auxValue <= 0.4) realValue = auxValue;
        if (flightDirection == FlightDirection.left) {
          left = leftLimit - realValue * leftLimit;
          print('flying left $left');
        } else {
          left = leftLimit * realValue;
          print('flying right $left');
        }
      }
      print('left $left');
      currentValue = auxValue;
    });
  }

  onEndAnimation() {
    if (currentValue != 0.0 && (currentValue <= 0.4 || currentValue >= 0.6)) {
      setState(() {
        print('falling down...');
        defaultBottom = -50;
        left = flightDirection == FlightDirection.left ? left - 20 : left + 20;
        duration = const Duration(milliseconds: 650);
        currentValue = 0.0;
        curve = Curves.easeInOutBack;
        if (flightDirection == FlightDirection.left &&
            ref.read(gamePlayProvider).playersCount[1] > 0) {
          ref.read(gamePlayProvider).playersCount[1]--;
        }
        if (flightDirection == FlightDirection.right &&
            ref.read(gamePlayProvider).playersCount[0] > 0) {
          ref.read(gamePlayProvider).playersCount[0]--;
        }
      });
    } else {
      setState(() {
        print('starting meter again...');
        animatingPigeon = false;
        duration = const Duration(milliseconds: 3000);
        curve = Curves.easeInOut;
        if (currentValue != 0.0 && (currentValue > 0.4 || currentValue < 0.6)) {
          flightDirection == FlightDirection.left
              ? ref.read(gamePlayProvider).playersCount[1]++
              : ref.read(gamePlayProvider).playersCount[0]++;
        }
        if (ref.read(gamePlayProvider).playersCount[0] == 5 ||
            ref.read(gamePlayProvider).playersCount[1] == 5) {
          // somebody win, lunch overlay with cup and confetti
          won = true;
          showWinOverlay();
          print('somebody win...');
        } else {
          _controller.repeat(min: 0.01, max: 0.97, reverse: true);
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {
              flightDirection = flightDirection == FlightDirection.left
                  ? FlightDirection.right
                  : FlightDirection.left;
              defaultBottom = kDefaultBottom;
              if (flightDirection == FlightDirection.left) {
                left = widgetMaxWidth;
                print('flying left $left');
              } else {
                left = 0.0;
                print('flying right $left');
              }
              animatingPigeon = true;
            });
          });
        }
      });
    }
  }

  reset() {
    hideWinOverlay();
    setState(() {
      flightDirection = FlightDirection.right;
      defaultBottom = kDefaultBottom;
      currentValue = 0.0;
      animatingPigeon = false;
      won = false;
      duration = const Duration(milliseconds: 3000);
      curve = Curves.easeInOut;
      ref.watch(gamePlayProvider).playersCount[0] = 0;
      ref.watch(gamePlayProvider).playersCount[1] = 0;
      _controller.repeat(min: 0.01, max: 0.97, reverse: true);
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        animatingPigeon = true;
        left = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final count1 = ref.watch(gamePlayProvider).playersCount[0];
    final count2 = ref.watch(gamePlayProvider).playersCount[1];
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: !won ? onStopMeter : null,
          child: LayoutBuilder(
            builder: (context, constraints) {
              widgetMaxHeight = constraints.maxHeight;
              widgetMinWidth = constraints.minWidth;
              widgetMaxWidth = constraints.maxWidth - 50;
              return Stack(
                children: [
                  const BackgroundImage(),
                  LoveLetter(count: count1),
                  Align(
                    alignment: Alignment.topRight,
                    child: LoveLetter(count: count2),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: PowerMeter(controller: _controller),
                    ),
                  ),
                  const Positioned(
                    bottom: 100,
                    left: -100,
                    child: Castle1(),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 30,
                    child: PlayerContainer(
                        color: flightDirection == FlightDirection.right
                            ? Colors.orange
                            : Colors.black54,
                        text: 'Player 1'),
                  ),
                  const Positioned(
                    bottom: 100,
                    right: -100,
                    child: Castle2(),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 30,
                    child: PlayerContainer(
                        color: flightDirection == FlightDirection.left
                            ? Colors.orange
                            : Colors.black54,
                        text: 'Player 2'),
                  ),
                  animatingPigeon
                      ? AnimatedPositioned(
                          onEnd: onEndAnimation,
                          duration: duration,
                          curve: curve,
                          bottom: defaultBottom,
                          left: left,
                          child: Pigeon(
                            flightDirection: flightDirection,
                          ),
                        )
                      : Container(),
                  Positioned(
                    child: TextButton(
                      child: Row(
                        children: const [
                          Text('deamdeveloper'),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.launch,
                            size: 12.0,
                          )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.only(right: 5.0),
                        textStyle: const TextStyle(color: Colors.white),
                        primary: Colors.white,
                      ),
                      onPressed: () async {
                        const _url = 'https://github.com/deam91/love_letters';
                        if (!await launch(_url)) throw 'Could not launch $_url';
                      },
                    ),
                    bottom: 0.0,
                    right: 5.0,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
