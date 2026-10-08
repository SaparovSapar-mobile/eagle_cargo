import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:provider/provider.dart';

import 'package:eagle_cargo/core/api/providers/warning_provider.dart';
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'warnings_page.dart';

abstract class WarningsViewModel extends State<WarningsPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() async {
    final provider = context.read<WarningProvider>();
    await provider.getAll();
    if (!mounted) return;
    if (provider.hasError) {
      context.showErrorToast(description: context.tr('mb_error_occured'));
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
