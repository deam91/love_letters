import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:love_letters/common/constants.dart';

class WonOverlay extends StatelessWidget {
  WonOverlay({Key? key, required this.restart}) : super(key: key);
  final Function restart;

  final ConfettiController _controllerLeft =
      ConfettiController(duration: const Duration(seconds: 10));
  final ConfettiController _controllerRight =
      ConfettiController(duration: const Duration(seconds: 10));

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 3;
    final halfWidth = size.width / 1.5;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.0;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    _controllerLeft.play();
    _controllerRight.play();
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Colors.black.withOpacity(.90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/cup.png',
                    fit: BoxFit.contain,
                  ),
                  const FittedBox(
                    child: DefaultTextStyle(
                      style: TextStyle(color: Colors.white, fontSize: 40.0),
                      child: Text(
                        'Love Won!!',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        restart();
                      },
                      child: const Text('Restart'))
                ],
              ),
            );
          },
        ),
        Positioned(
          child: ConfettiWidget(
            confettiController: _controllerLeft,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/path.
          ),
          top: cMaxAppBarHeight,
          left: 0.0,
        ),
        Positioned(
          child: ConfettiWidget(
            confettiController: _controllerRight,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/path.
          ),
          top: cMaxAppBarHeight,
          right: 0.0,
        ),
      ],
    );
  }
}
