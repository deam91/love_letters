import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:love_letters/components/power_meter_indicator.dart';

/// The meter that displays a moving bar which determines the power of the
/// shoot.
class PowerMeter extends ConsumerWidget {
  const PowerMeter({Key? key, required this.controller}) : super(key: key);
  final AnimationController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width / 2;
    return SizedBox(
      height: 30.0,
      width: width,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(2.0),
              ),
              border: Border.all(
                color: Colors.red,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1.0),
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              color: Colors.grey,
              width: 10,
              child: const PowerMeterIndicator(),
            ),
            builder: (context, child) {
              return Positioned(
                height: 30,
                left: width * controller.value,
                child: child!,
              );
            },
          ),
        ],
      ),
    );
  }
}
