import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

import '../api.dart';
import '../models/warning_model.dart';

class WarningService {
  /// Public endpoint — no auth token needed.
  ///
  /// Without [type] both kinds come back (the profile section splits them
  /// locally); the launch dialog asks for `accept` only.
  static Future<List<WarningModel>> getAll({String? type}) async {
    final json = await BaseClient.get(
      API.host,
      API.warnings,
      headers: API.headers,
      query: {'firm_guid': API.firmGuid, if (type != null) 'type': type},
    );

    if (json['success'] == true && json['data'] != null) {
      // Already ordered by `level` on the server — keep that order as is.
      return (json['data'] as List)
          .map((e) => WarningModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
