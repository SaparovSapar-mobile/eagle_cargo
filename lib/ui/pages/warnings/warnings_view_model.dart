import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eagle_cargo/core/api/providers/warning_provider.dart';
import 'warnings_page.dart';

abstract class WarningsViewModel extends State<WarningsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() => context.read<WarningProvider>().getAll();
}
