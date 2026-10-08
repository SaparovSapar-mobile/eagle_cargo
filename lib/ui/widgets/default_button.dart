import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/utils/palette.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Color? color, textColor;
  final Function() onTap;
  const DefaultButton({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color ?? Colors.white,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: textColor ?? Palette.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
