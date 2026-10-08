import 'package:flutter/cupertino.dart';
import 'package:eagle_cargo/ui/pages/index.dart';
import 'package:eagle_cargo/ui/pages/notifications/notifications_page.dart';

class NavElement {
  final IconData activeIcon, inactiveIcon;
  final String label;
  const NavElement({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

abstract class MainViewModel extends State<MainPage>{
  int selectedIndex = 0;
  late GlobalKey<HomePageState> homeKey;
  late GlobalKey<NotificationsPageState> notificationsKey;
  late GlobalKey<ProfilePageState> profileKey;

  @override
  void initState() {
    super.initState();
    homeKey = GlobalKey<HomePageState>();
    // trackKey = GlobalKey<TrackPageState>();
    notificationsKey = GlobalKey<NotificationsPageState>();
    profileKey = GlobalKey<ProfilePageState>();
  }

  final List<NavElement> navElements = [
    NavElement(
      activeIcon: CupertinoIcons.house_fill,
      inactiveIcon: CupertinoIcons.house,
      label: 'mb_home',
    ),
    NavElement(
      activeIcon: CupertinoIcons.bell_fill,
      inactiveIcon: CupertinoIcons.bell,
      label: 'mb_notifications',
    ),
    NavElement(
      activeIcon: CupertinoIcons.person_fill,
      inactiveIcon: CupertinoIcons.person,
      label: 'mb_profile',
    ),
  ];
}