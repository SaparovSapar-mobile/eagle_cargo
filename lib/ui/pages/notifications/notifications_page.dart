//
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/ui/pages/notifications/notifications_view_model.dart';
import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';

import 'components/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends NotificationsViewModel {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: DefaultAppBar(
        title: context.tr('mb_notifications'),
        chevronBack: false,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          final list = provider.list;

          if (provider.isFetching && list.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (list.isEmpty) {
            return Center(
              child: LottieBuilder.asset(
                'assets/lottie/empty.json',
                width: size.width / 1.5,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              provider.reset();
              await provider.getAll();
            },
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: list.length + (provider.isFetching ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < list.length) {
                  return NotificationCard(notification: list[index]);
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
