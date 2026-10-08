import 'package:flutter/material.dart';
import 'package:eagle_cargo/ui/pages/main/components/page_lifecycle.dart';
import 'home_page.dart';

import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/order_provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys, VersionUtil;
import 'package:eagle_cargo/core/api/providers/slider_provider.dart';
import 'package:eagle_cargo/core/api/providers/warning_provider.dart';
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/utils/version_util.dart';
import 'package:eagle_cargo/ui/components/barcode_scanner_page.dart';

abstract class HomeViewModel extends State<HomePage> with PageLifecycle, TickerProviderStateMixin{
  final  codeController = TextEditingController();
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    _checkForUpdate.call();
    tabController = TabController(length: 2, vsync: this);

    // Safe: load after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      loadTabData(tabController.index);
    });

    // Listen to tab changes
    tabController.addListener(_handleTabChange);
  }

  void _checkForUpdate() async {
    await VersionUtil.checkForUpdate(context);
    // Warnings come first: an `accept` one blocks everything behind it.
    if (mounted) {
      await context.read<WarningProvider>().showPendingWarnings(context);
    }
    if (mounted) {
      context.read<SliderProvider>().showRandomPopup(context);
    }
  }

  @override
  void onPageVisible() {
    debugPrint("Home page reopened → refreshing current tab");
    if (mounted) loadTabData(tabController.index);
    super.onPageVisible();
  }

  void _handleTabChange() {
    if (!tabController.indexIsChanging && mounted) {
      loadTabData(tabController.index);
    }
  }

  void loadTabData(int index) {
    if (!mounted) return;

    final provider = context.read<OrderProvider>();
    provider.reset();

    if (index == 0) {
      // Pending tab → confirmed + pending
      provider.query = {
        'status': [
          'confirmed',
          'pending',
        ], // ← This becomes ?status=confirmed&status=pending
      };
    } else {
      // Completed tab
      provider.query = {'status': 'completed'};
    }

    provider.getOrders(
      onSuccess: () => setState(() {}),
      onError: () {
        context.showErrorToast(description: context.tr('error_loading'));
      },
    );
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Future<void> searchByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;

    codeController.text = trimmed;

    await context.read<OrderProvider>().trackOrder(
      orderNumber: trimmed,
      onSuccess: () => setState(() {}),
      onNotFound: () {
        context.showInfoToast(
          description: context.tr('no_data_found'),
        );
      },
      onError: () {
        context.showErrorToast(description: context.tr('mb_error_occured'));
      },
    );
  }

  Future<void> scanQr() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result == null || !mounted) return;

    codeController.text = result;
    searchByCode(result);
  }
}