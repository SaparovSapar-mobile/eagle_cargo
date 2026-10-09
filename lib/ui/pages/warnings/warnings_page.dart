import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eagle_cargo/core/api/providers/warning_provider.dart';
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/ui/pages/warnings/components/warning_card.dart';
import 'package:eagle_cargo/ui/pages/warnings/warnings_view_model.dart';
import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';
import 'package:eagle_cargo/ui/widgets/empty_state.dart';

/// Always-available section listing every warning of the firm, grouped by
/// type. Read-only: consent is only given in the launch dialog.
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
      appBar: DefaultAppBar(title: context.tl('mb_warnings')),
      // The spinner only replaces the content on the first load; a pull to
      // refresh keeps the list in place.
      body: provider.isLoading && provider.warnings.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : provider.hasError && provider.warnings.isEmpty
          ? _buildError()
          : RefreshIndicator(onRefresh: load, child: _buildList(provider)),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              context.tl('mb_error_occured'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primaryLight,
                foregroundColor: Colors.white,
              ),
              onPressed: load,
              child: Text(context.tl('mb_retry')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(WarningProvider provider) {
    final accept = provider.acceptWarnings;
    final info = provider.infoWarnings;

    if (accept.isEmpty && info.isEmpty) {
      // Still scrollable, so pull to refresh works on the empty state too.
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: EmptyState(
              icon: Icons.notifications_none_rounded,
              title: context.tl('mb_nothing_yet'),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      children: [
        if (accept.isNotEmpty) ...[
          _buildHeader(context.tl('mb_warnings_rules')),
          ...accept.map(
            (w) => WarningCard(warning: w, accepted: provider.isAccepted(w)),
          ),
        ],
        if (info.isNotEmpty) ...[
          _buildHeader(context.tl('mb_warnings_info')),
          ...info.map((w) => WarningCard(warning: w)),
        ],
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
