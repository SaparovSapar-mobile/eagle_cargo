import 'package:kargoo_core/kargoo_core.dart';
import '../api.dart';
import '../models/slider_model.dart';

class SliderService {
  static Future<List<SliderModel>> getSliders({String? type}) async {
    final json = await BaseClient.get(
      API.host,
      API.sliders,
      headers: API.headers,
      query: {
        'is_active': 'true',
        'limit': '10',
        'firm_guid': API.firmGuid,
        if (type != null) 'type': type,
      },
    );

    if (json['success'] == true && json['data'] != null) {
      return (json['data'] as List)
          .map((e) => SliderModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
