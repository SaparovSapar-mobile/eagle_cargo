import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/ui/pages/index.dart';
import 'package:eagle_cargo/ui/pages/main/main_view_model.dart';
import 'package:eagle_cargo/ui/pages/notifications/notifications_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _LiquidFloatingNavState();
}

class _LiquidFloatingNavState extends MainViewModel {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark();
    return Scaffold(
      extendBody: true, // Content flows behind the floating navigation bar
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePage(key: homeKey),
          NotificationsPage(key: notificationsKey),
          ProfilePage(key: profileKey),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Palette.darkSurface.withValues(alpha: 255 * 0.65)
                          : Colors.white.withValues(alpha: 255 * 0.65),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Stack(
                      children: [
                        // Sliding Liquid Pill Indicator
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves
                              .easeOutBack, // Gives a pleasant fluid bounce
                          alignment: Alignment(
                            -1.0 +
                                (selectedIndex *
                                    (2.0 / (navElements.length - 1))),
                            0.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: FractionallySizedBox(
                              widthFactor: 1 / navElements.length,
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Palette.primary,
                                      Palette.primaryLight,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Palette.primary.withValues(
                                        alpha: 255 * 0.3,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Row of Items
                        Row(
                          children: List.generate(navElements.length, (index) {
                            final item = navElements[index];
                            final isSelected = selectedIndex == index;
                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() => selectedIndex = index);
                                  context.read<AuthProvider>().updateFcm();
                                  if (index == 0)
                                    homeKey.currentState?.onPageVisible();
                                  if (index == 1)
                                    notificationsKey.currentState
                                        ?.onPageVisible();
                                  if (index == 2)
                                    profileKey.currentState?.onPageVisible();
                                },
                                child: AnimatedScale(
                                  scale: isSelected ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isSelected
                                            ? item.activeIcon
                                            : item.inactiveIcon,
                                        size: 24,
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark
                                                  ? Colors.grey.shade500
                                                  : Colors.grey.shade600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        context.tr(item.label),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : (isDark
                                                    ? Colors.grey.shade400
                                                    : Colors.grey.shade600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
