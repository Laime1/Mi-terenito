import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HouseLoader extends StatelessWidget {
  final double size;

  const HouseLoader({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/house_loading.json',
        width: 200,
        height: 200,
      ),
    );
  }
}
