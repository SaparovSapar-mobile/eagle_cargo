import 'package:kargoo_core/kargoo_core.dart';
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/location_model.dart';

class LocationService {
  static Future<List<LocationModel>> fetchRegions() async {
    const turkmenistanGuid = "74e325da-56b9-4797-a950-03ac2305c6f9";
    try {
      final response = await BaseClient.get(
        API.host,
        "${API.locations}/$turkmenistanGuid/children",
        headers: API.headers,
      );

      if (response is List) {
        return response.map((e) => LocationModel.fromJson(e)).toList();
      } else if (response is Map && response['data'] is List) {
        return (response['data'] as List)
            .map((e) => LocationModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
