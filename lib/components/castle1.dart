import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The castle on the left.
class Castle1 extends StatelessWidget {
  const Castle1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Image.asset(
          'assets/castle1.png',
        ),
      ),
    );
  }
}
