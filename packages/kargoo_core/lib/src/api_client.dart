// packages/logistics_core/lib/src/api_client.dart
class LogisticsApi {
  final String baseUrl;
  LogisticsApi(this.baseUrl);

  Future<Map> getTracking(String id) async {
    // Shared logic for all 5 apps
    return {"status": "In Transit", "location": "Warehouse A"};
  }
}