import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/api.dart';
import '../models/notification_model.dart';

class NotificationService {
  static Future<Map<String, dynamic>> getAll({
    int limit = 20,
    int page = 1,
  }) async {
    final json = await BaseClient.get(
      API.host,
      API.notifications,
      headers: API.headers,
      query: {"limit": "$limit", "page": "$page"},
    );
    return {
      "count": int.tryParse(json["pagination"]['total'].toString()) ?? 0,
      "data": json['data']
          .map<NotificationModel>((e) => NotificationModel.fromJson(e))
          .toList(),
    };
  }

  static Future<NotificationModel> getOne({required String guid}) async {
    final json = await BaseClient.get(API.host, "${API.notifications}/$guid",
        headers: API.headers);
    return NotificationModel.fromJson(json);
  }

  static Future<bool> markAsRead({required String guid}) async {
    try {
      await BaseClient.patch(API.host, "${API.notifications}/$guid/read",
          headers: API.headers, body: {});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> getUnreadCount() async {
    final json = await BaseClient.get(API.host, "${API.notifications}/unread-count",
        headers: API.headers);
    return int.tryParse(json['unread_count'].toString()) ?? 0;
  }
}
