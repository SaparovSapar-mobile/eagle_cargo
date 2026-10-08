import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/utils/palette.dart';

class SplashElements extends StatelessWidget {
  const SplashElements({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.loose,
      children: [
        Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
            ),
            child: Image.asset(
              'assets/images/app_logo.jpg',
              width: size.width / 2,
              height: size.width / 2,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: LinearProgressIndicator(
            color: Palette.primaryLight,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
