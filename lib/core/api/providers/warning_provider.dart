import 'dart:convert';

import 'package:flutter/material.dart';

import '../../preferences/preference_keys.dart';
import '../../preferences/preferences_util.dart';
import '../models/warning_model.dart';
import '../services/warning_service.dart';
import '../../../ui/components/warning_dialog.dart';

class WarningProvider extends ChangeNotifier {
  /// Past this the launch request is dropped until the next app start.
  static const _startupTimeout = Duration(seconds: 5);

  final List<WarningModel> _warnings = [];
  List<WarningModel> get warnings => _warnings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  /// Launch request, started from the splash so it runs alongside the rest of
  /// the startup work.
  Future<List<WarningModel>?>? _startupFetch;

  /// Guard so the launch dialog is only attempted once per app session.
  bool _startupShown = false;

  List<WarningModel> get acceptWarnings =>
      _warnings.where((e) => e.type == WarningType.accept).toList();

  List<WarningModel> get infoWarnings =>
      _warnings.where((e) => e.type == WarningType.info).toList();

  /// `warning_guid -> updated_dt` of every `accept` warning the client
  /// confirmed. The server does not track this, so it lives on the device.
  Map<String, String> _readAccepted() {
    final raw = PreferenceManager.instance.getStringValue(
      PreferenceKeys.ACCEPTED_WARNINGS,
    );
    if (raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, "$v"));
    } catch (e) {
      debugPrint("Broken accepted-warnings cache: $e");
      return {};
    }
  }

  /// Accepted only while the text is the one the client agreed to — an edit
  /// in the web panel bumps `updated_dt` and asks for consent again.
  bool isAccepted(WarningModel warning) {
    final guid = warning.warningGuid;
    if (guid == null) return false;
    return _readAccepted()[guid] == (warning.updatedDt ?? '');
  }

  /// Stored right away, so a client who quits halfway through only sees the
  /// remaining warnings on the next launch.
  Future<void> accept(WarningModel warning) async {
    final guid = warning.warningGuid;
    if (guid == null) return;
    final accepted = _readAccepted();
    accepted[guid] = warning.updatedDt ?? '';
    await PreferenceManager.instance.setStringValue(
      PreferenceKeys.ACCEPTED_WARNINGS,
      jsonEncode(accepted),
    );
    notifyListeners();
  }

  Future<void> getAll() async {
    if (_isLoading) return;
    _isLoading = true;
    _hasError = false;
    notifyListeners();
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

  /// Starts loading the launch warnings without waiting for them.
  ///
  /// Resolves to `null` on any failure or after [_startupTimeout]; the
  /// warnings then simply wait for the next launch.
  void prefetchStartupWarnings() {
    _startupFetch ??= WarningService.getAll(type: WarningType.accept.name)
        .timeout(_startupTimeout)
        .then<List<WarningModel>?>((list) => list)
        .catchError((e) {
          debugPrint("Startup warnings skipped: $e");
          return null;
        });
  }

  /// Shows the `accept` warnings the client has not confirmed yet, one after
  /// another, in a dialog that can only be left by accepting them all.
  ///
  /// A failing request must never block the app: nothing is shown and nothing
  /// is stored.
  Future<void> showPendingWarnings(BuildContext context) async {
    if (_startupShown) return;
    _startupShown = true;

    prefetchStartupWarnings();
    final list = await _startupFetch;
    if (list == null) return;

    // `info` warnings never block — they live in the profile section only.
    final pending = list
        .where((w) => w.mustAccept && w.warningGuid != null && !isAccepted(w))
        .toList();
    if (pending.isEmpty || !context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WarningDialog(warnings: pending, onAccept: accept),
    );
  }
}
