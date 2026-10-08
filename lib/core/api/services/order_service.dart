import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/order_model.dart';
import 'package:eagle_cargo/core/api/models/package_model.dart';

class OrderService {
  static Future<Map<String, dynamic>> getOrders({
    int limit = 20,
    int page = 1,
    Map<String, dynamic> params = const {},
  }) async {
    final queryParams = <String, dynamic>{"limit": "$limit", "page": "$page"};

    // This magic handles List values correctly
    params.forEach((key, value) {
      if (value is List) {
        queryParams[key] = value; // Uri will repeat the key
      } else {
        queryParams[key] = value.toString();
      }
    });

    final json = await BaseClient.get(API.host, API.orders,
        headers: API.headers, query: queryParams);
    return {
      "count": int.tryParse(json['meta']['total'].toString()),
      "data": json['data']
          .map<OrderModel>((e) => OrderModel.fromJson(e))
          .toList(),
    };
  }

  static Future<Map<String, dynamic>> searchPackage({
    required String orderNumber,
  }) async {
    try {
      final json = await BaseClient.get(
        API.host,
        API.trackOrder.replaceAll('{orderNumber}', orderNumber),
        headers: API.headers,
      );
      return {"status": 200, "data": PackageModel.fromJson(json)};
    } on ApiException catch (e) {
      return {"status": e.statusCode, "message": e.message};
    } catch (e) {
      return {"status": 500, "message": e.toString()};
    }
  }
}
