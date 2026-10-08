import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

import '../api.dart';
import '../models/warning_model.dart';

class WarningService {
  /// Public endpoint — no auth token needed.
  ///
  /// [type] is left out on purpose by the callers: one request returns both
  /// kinds and the app splits them locally.
  static Future<List<WarningModel>> getAll({String? type}) async {
    final json = await BaseClient.get(
      API.host,
      API.warnings,
      headers: API.headers,
      query: {'firm_guid': API.firmGuid, if (type != null) 'type': type},
    );

    if (json['success'] == true && json['data'] != null) {
      final list = (json['data'] as List)
          .map((e) => WarningModel.fromJson(e))
          .toList();
      // The server already orders by level; keep it stable if that changes.
      list.sort((a, b) => (a.level ?? 0).compareTo(b.level ?? 0));
      return list;
    }
    return [];
  }
}
