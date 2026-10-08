import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/models/notification_model.dart';
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';

class NotificationDetailPage extends StatelessWidget {

  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationModel? notification = context.watch<NotificationProvider>().current;
    return Scaffold(
      appBar: DefaultAppBar(title: notification?.title ?? "..."),
      body: notification == null ? CircularProgressIndicator.adaptive(): SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section: Type and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Text(
                  notification.createdDt ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              notification.title ?? 'No Title',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    // color: Colors.black87,
                  ),
            ),
            const Divider(height: 32, thickness: 1),
            
            // Message Body
            Text(
              notification.message ?? 'No message content available.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    // color: Colors.grey[800],
                  ),
            ),
            
            const SizedBox(height: 40),
            
            // Status Info
            if (notification.isRead ?? false)
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    '${context.tr('mb_read_date')} ${notification.readDt ?? "Unknown"}',
                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

}

class NotificationDetailPageArgs{
   final NotificationModel model;

  NotificationDetailPageArgs({required this.model});

}