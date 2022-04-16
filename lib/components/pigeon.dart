import 'dart:math' as math;

import 'package:flutter/material.dart';

enum FlightDirection {
  left,
  right,
}

/// The cannon ball that we will shoot.
class Pigeon extends StatelessWidget {
  const Pigeon({
    Key? key,
    required this.flightDirection,
  }) : super(key: key);

  final FlightDirection flightDirection;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: flightDirection == FlightDirection.left
          ? Matrix4.identity()
          : Matrix4.rotationY(math.pi),
      child: SizedBox(
        height: 50,
        child: Image.asset('assets/carrier_pigeon.png'),
      ),
    );
  }
}
