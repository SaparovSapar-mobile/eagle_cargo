import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final bool showArrow;
  final Widget? trailing;
  final Function()? onTap;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.color,
    this.trailing,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? (context.isDark() ? Colors.white : Colors.black87),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: color ?? (context.isDark() ? Colors.white : Colors.black87),
        ),
      ),
      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : trailing,
      onTap: onTap,
    );
  }
}
