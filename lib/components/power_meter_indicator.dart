import 'package:flutter/material.dart';

/// The red line in the [PowerMeter] that goes left to right and right to left.
class PowerMeterIndicator extends StatelessWidget {
  const PowerMeterIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5.0,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
    );
  }
}
