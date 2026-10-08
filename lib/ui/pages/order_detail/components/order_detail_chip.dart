import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/palette.dart';

class OrderDetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const OrderDetailChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.isDark()
            ? Palette.darkBackground
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 16, color: context.textColor()),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
