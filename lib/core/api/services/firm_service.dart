import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/firm_detail_response.dart';
import 'package:eagle_cargo/core/api/models/firm_rate_model.dart';

class FirmService {
  static Future<FirmDetailResponse> getFirmDetails() async {
    final json = await BaseClient.get(API.host, "${API.firmDetails}/${API.firmGuid}",
        headers: API.headers);
    return FirmDetailResponse.fromJson(json);
  }

  static Future<List<FirmRateModel>> getFirmRates() async {
    final json = await BaseClient.post(API.host, API.firmRates,
        headers: API.headers, body: {
      "firm_guid": API.firmGuid,
    });
    return json['data']
        .map<FirmRateModel>((e) => FirmRateModel.fromJson(e))
        .toList();
  }
}
