import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/notification_provider.dart';
import 'package:eagle_cargo/ui/pages/main/components/page_lifecycle.dart';
import 'notifications_page.dart';

abstract class NotificationsViewModel extends State<NotificationsPage> with PageLifecycle{
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          context.read<NotificationProvider>().getAll();
        }
      });
    });
    context.read<NotificationProvider>().reset();
    context.read<NotificationProvider>().getAll();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}