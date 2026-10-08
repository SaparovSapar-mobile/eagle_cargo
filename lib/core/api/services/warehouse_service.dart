import 'package:flutter/foundation.dart';

import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/warehouse_model.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;

import '../models/payment_info_response.dart';

class WarehouseService {
  /// Local warehouses of the firm.
  ///
  /// [isForeign] filters by the `is_foreign` flag: `false` keeps the regular
  /// list free of the foreign warehouses that now have their own section,
  /// `null` returns everything (legacy behaviour).
  static Future<Map<String, dynamic>> getAll({
    int limit = 20,
    int page = 1,
    bool? isForeign,
    Map<String, String> params = const {},
  }) async {
    final json = await BaseClient.get(
      API.host,
      API.warehouses.replaceAll('{firmGuid}', API.firmGuid),
      headers: API.headers,
      query: {
        "limit": "$limit",
        "page": "$page",
        "status": 'true',
        // The backend only understands the literal strings "true"/"false".
        if (isForeign != null) "is_foreign": isForeign ? 'true' : 'false',
        ...params,
      },
    );
    return _parseList(json);
  }

  /// Warehouses abroad, served by the newer core endpoint.
  ///
  /// That list response is trimmed (guid, code, name, is_foreign, location),
  /// so each entry is completed from the detail endpoint — the card needs the
  /// address and phone to be of any use.
  static Future<Map<String, dynamic>> getForeign({
    int limit = 20,
    int page = 1,
  }) async {
    final json = await BaseClient.get(
      API.host,
      API.warehousesCore.replaceAll('{firmGuid}', API.firmGuid),
      headers: API.headers,
      query: {"limit": "$limit", "page": "$page", "is_foreign": 'true'},
    );
    final parsed = _parseList(json);
    final items = parsed['data'] as List<WarehouseModel>;
    await Future.wait(items.map(_fillFromDetail));
    return parsed;
  }

  /// Best-effort enrichment: on failure the trimmed record is kept as is.
  static Future<void> _fillFromDetail(WarehouseModel warehouse) async {
    final guid = warehouse.warehouseGuid;
    if (guid == null) return;
    try {
      final detail = await getDetail(guid);
      warehouse.address ??= detail.address;
      warehouse.phone ??= detail.phone;
      warehouse.latitude ??= detail.latitude;
      warehouse.longitude ??= detail.longitude;
    } catch (e) {
      debugPrint("Warehouse detail $guid failed: $e");
    }
  }

  /// Single warehouse. Throws [ApiException] with 404 when it does not exist.
  static Future<WarehouseModel> getDetail(String warehouseGuid) async {
    final json = await BaseClient.get(
      API.host,
      API.warehouseDetail.replaceAll('{warehouseGuid}', warehouseGuid),
      headers: API.headers,
    );
    return WarehouseModel.fromJson(json);
  }

  static Map<String, dynamic> _parseList(dynamic json) {
    final data = (json['data'] as List?) ?? [];
    return {
      "count": int.tryParse(json['total'].toString()) ?? data.length,
      "data": data.map<WarehouseModel>((e) => WarehouseModel.fromJson(e)).toList(),
    };
  }

  static Future<PaymentInfoResponse> getPaymentInfo() async {
    final json = await BaseClient.get(
      API.host,
      API.paymentInfo,
      headers: API.headers,
      query: {"firm_guid": API.firmGuid},
    );
    return PaymentInfoResponse.fromJson(json['data']);
  }
}
