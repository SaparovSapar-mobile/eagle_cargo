import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/models/notification_model.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:eagle_cargo/core/routes/routes.dart';
import 'package:eagle_cargo/core/utils/palette.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final unread = notification.isRead == false;
    final iconColor = Palette.primary;

    String timeStr = '';
    try {
      if (notification.createdDt != null) {
        final date = DateTime.parse(notification.createdDt!);
        timeStr = DateFormat('dd.MM.yyyy HH:mm').format(date);
      }
    } catch (e) {
      timeStr = notification.createdDt ?? '';
    }

    return GestureDetector(
      onTap: () {
        context.read<NotificationProvider>().getOne(
          guid: notification.guid,
          onDone: () {
            Navigator.pushNamed(context, Routes.notificationDetail);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.isDark() ? Palette.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: context.defaultShadow(),
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            /// Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 255 * 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.bell,
                color: Colors.white,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? 'Sargyt',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message ?? '',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeStr,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
