import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

import 'package:eagle_cargo/core/api/models/warning_model.dart';
import 'package:eagle_cargo/core/api/providers/warning_provider.dart';
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/ui/pages/warnings/components/warning_card.dart';
import 'package:eagle_cargo/ui/pages/warnings/warnings_view_model.dart';
import 'package:eagle_cargo/ui/widgets/empty_state.dart';

/// Always-available section listing every warning of the firm, split by type.
class WarningsPage extends StatefulWidget {
  const WarningsPage({super.key});

  @override
  State<WarningsPage> createState() => _WarningsPageState();
}

class _WarningsPageState extends WarningsViewModel {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WarningProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryLight,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          context.tl('mb_warnings'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: context.tr('rules_header')),
            Tab(text: context.tr('action_info')),
          ],
        ),
      ),
      // The spinner only replaces the content on the first load; a pull to
      // refresh keeps the list in place.
      body: provider.isLoading && provider.warnings.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : TabBarView(
              controller: tabController,
              children: [
                _buildList(provider.acceptWarnings),
                _buildList(provider.infoWarnings),
              ],
            ),
    );
  }

  Widget _buildList(List<WarningModel> items) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: load,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: EmptyState(
                icon: Icons.notifications_none_rounded,
                title: context.tr('mb_temporary_empty'),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: load,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: items.length,
        itemBuilder: (_, i) => WarningCard(warning: items[i]),
      ),
    );
  }
}
