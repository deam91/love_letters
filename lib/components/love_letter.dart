import 'package:flutter/material.dart';

class LoveLetter extends StatelessWidget {
  const LoveLetter({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 45,
      child: Stack(
        children: [
          Image.asset('assets/love_letter.png'),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchOutCurve: Curves.linearToEaseOut,
                switchInCurve: Curves.easeInToLinear,
                child: Text(
                  '$count',
                  key: ValueKey(count),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
