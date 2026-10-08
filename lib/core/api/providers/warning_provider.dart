import 'dart:convert';

import 'package:flutter/material.dart';

import '../../preferences/preference_keys.dart';
import '../../preferences/preferences_util.dart';
import '../models/warning_model.dart';
import '../services/warning_service.dart';
import '../../../ui/components/warning_dialog.dart';

class WarningProvider extends ChangeNotifier {
  final List<WarningModel> _warnings = [];
  List<WarningModel> get warnings => _warnings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  /// Guard so the launch popups are only attempted once per app session.
  bool _startupShown = false;

  List<WarningModel> get acceptWarnings =>
      _warnings.where((e) => e.type == WarningType.accept).toList();

  List<WarningModel> get infoWarnings =>
      _warnings.where((e) => e.type == WarningType.info).toList();

  /// `warning_guid -> updated_dt` of everything the client already confirmed.
  /// The server does not track this, so it lives on the device.
  Map<String, String> _readSeen() {
    final raw = PreferenceManager.instance.getStringValue(
      PreferenceKeys.SEEN_WARNINGS,
    );
    if (raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, "$v"));
    } catch (e) {
      debugPrint("Broken seen-warnings cache: $e");
      return {};
    }
  }

  Future<void> _writeSeen(Map<String, String> seen) async {
    await PreferenceManager.instance.setStringValue(
      PreferenceKeys.SEEN_WARNINGS,
      jsonEncode(seen),
    );
  }

  /// New warnings, plus the ones whose text changed since the client saw them.
  List<WarningModel> get pending {
    final seen = _readSeen();
    return _warnings.where((w) {
      final guid = w.warningGuid;
      if (guid == null) return false;
      if (!seen.containsKey(guid)) return true;
      return seen[guid] != (w.updatedDt ?? '');
    }).toList();
  }

  Future<void> markSeen(WarningModel warning) async {
    final guid = warning.warningGuid;
    if (guid == null) return;
    final seen = _readSeen();
    seen[guid] = warning.updatedDt ?? '';
    await _writeSeen(seen);
  }

  Future<void> getAll({bool silent = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _hasError = false;
    if (!silent) notifyListeners();
    try {
      final list = await WarningService.getAll();
      _warnings
        ..clear()
        ..addAll(list);
    } catch (e) {
      debugPrint("Error fetching warnings: $e");
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Shows the warnings the client has not confirmed yet, one after another.
  ///
  /// A failing request must never block the app: nothing is shown and nothing
  /// is stored, so the warnings simply reappear on the next launch.
  Future<void> showPendingWarnings(BuildContext context) async {
    if (_startupShown) return;
    _startupShown = true;

    await getAll(silent: true);
    if (_hasError) return;

    for (final warning in pending) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        // `accept` warnings may only be dismissed through their button.
        barrierDismissible: !warning.mustAccept,
        builder: (_) => WarningDialog(warning: warning),
      );
      await markSeen(warning);
    }
  }
}
