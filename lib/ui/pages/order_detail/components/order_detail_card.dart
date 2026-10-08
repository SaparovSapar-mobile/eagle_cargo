import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/palette.dart';

class OrderDetailCard extends StatelessWidget {
  final Widget child;
  const OrderDetailCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.isDark() ? Palette.darkSurface: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: context.defaultShadow()
    ),
    child: child,
  );
  }
}