import 'package:flutter/material.dart';

/// The backround of the game.
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'assets/background.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
