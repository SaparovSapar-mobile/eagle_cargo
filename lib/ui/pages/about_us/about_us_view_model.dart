import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/firm_provider.dart';

import 'about_us_page.dart';

abstract class AboutUsViewModel extends State<AboutUsPage>{
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() => isLoading = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FirmProvider>().getFirmRates();
      context.read<FirmProvider>().getFirmDetails(
        onDone: () => setState(() => isLoading = false),
        onError: () => setState(() => isLoading = false),
      );
    });
  }
}