import 'package:flutter/material.dart';

/// The castle on the right.
class Castle2 extends StatelessWidget {
  const Castle2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: Image.asset(
        'assets/castle2.png',
      ),
    );
  }
}
