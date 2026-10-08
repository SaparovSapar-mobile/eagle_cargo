import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/order_provider.dart';

import 'order_detail_page.dart';
import 'package:flutter/material.dart';
abstract class OrderDetailViewModel extends State<OrderDetailPage>{
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args =
          ModalRoute.of(context)?.settings.arguments as OrderDetailPageArgs;
      if (args.trackingNumber != null &&
          (args.trackingNumber?.isNotEmpty ?? false)) {
        context.read<OrderProvider>().getOne(
          orderNumber: args.trackingNumber,
          onSuccess: () {
            setState(() => isLoading = false);
          },
        );
      }
    });
  }
}