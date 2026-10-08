import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/utils/palette.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool chevronBack;
  final List<Widget> actions;
  const DefaultAppBar({
    super.key,
    required this.title,
    this.chevronBack = true,
    this.actions = const[]
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryLight,
      automaticallyImplyLeading: chevronBack ? false : true,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      leading: chevronBack
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.chevron_back),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
