import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/firm_provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/ui/pages/about_us/about_us_view_model.dart';
import 'package:eagle_cargo/ui/pages/about_us/components/about_contact_section.dart';
import 'package:eagle_cargo/ui/pages/about_us/components/about_firm_section.dart';
import 'package:eagle_cargo/ui/pages/about_us/components/about_service_section.dart';
import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';

import 'components/about_us_header.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends AboutUsViewModel {
  

  @override
  Widget build(BuildContext context) {
    final firm = context.watch<FirmProvider>().firmDetails;
    final rates = context.watch<FirmProvider>().firmRates;

    return Scaffold(
      backgroundColor: context.isDark()
          ? Palette.darkBackground
          : Colors.grey[50],
      appBar: DefaultAppBar(title: context.tr('mb_about_us')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator(
              onRefresh: () async => fetchData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Clean Header without Stack
                    AboutUsHeader(firm: firm),
                    AboutFirmSection(firm: firm),
                    const SizedBox(height: 30),
                    AboutServiceSection(rates: rates),
                    const SizedBox(height: 30),
                    AboutContactSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}
