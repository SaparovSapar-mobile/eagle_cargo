import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isSelected;
  const NavItem({super.key, required this.activeIcon, required this.inactiveIcon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        Icon(
          isSelected ? activeIcon : inactiveIcon,
          size: 26,
          color: isSelected ? Colors.white : Colors.grey.shade600,
        ),
        // Show label only when NOT selected
        if (!isSelected)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
