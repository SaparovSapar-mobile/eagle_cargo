import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys, VersionUtil;
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/models/order_model.dart';
import 'package:eagle_cargo/core/api/providers/order_provider.dart';

import 'shipment_tile.dart';

class HomeOrderList extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final String status;
  const HomeOrderList({super.key, required this.status, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    bool isLoading = provider.isFetching;
    List<OrderModel> orders = provider.orders
        .where((o) => o.status == status)
        .toList();
    if (isLoading && orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            Center(
              child: Column(
                children: [
                  // Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  // SizedBox(height: 16),
                  Text(
                    context.tr('mb_temporary_empty'),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 100),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ShipmentTile.fromOrder(order: order),
          );
        },
      ),
    );
  }
}
