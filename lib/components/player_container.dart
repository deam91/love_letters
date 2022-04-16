import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayerContainer extends StatelessWidget {
  const PlayerContainer({Key? key, required this.color, required this.text})
      : super(key: key);
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 30,
      width: 70,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: color.withOpacity(.9),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
