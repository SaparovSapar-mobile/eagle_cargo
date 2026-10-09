import '../models/language_model.dart';
import '../models/translation_model.dart';
import 'base_client.dart';

class TranslationService {
  /// [firmGuid] adds the firm's own languages to every item; without it only
  /// `tk`/`ru`/`en` come back.
  static Future<List<TranslationModel>> getTranslations({
    required String host,
    required String path,
    String? category,
    String? firmGuid,
  }) async {
    final Map<String, dynamic> query = {
      "category": ?category,
      "firm_guid": ?firmGuid,
    };

    final response = await BaseClient.get(host, path, query: query);

    if (response is List) {
      return response.map((e) => TranslationModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Languages the firm's clients can pick, already in display order.
  static Future<List<LanguageModel>> getLanguages({
    required String host,
    required String path,
    required String firmGuid,
  }) async {
    final response = await BaseClient.get(
      host,
      path,
      query: {"firm_guid": firmGuid},
    );

    if (response is List) {
      return response
          .map((e) => LanguageModel.fromJson(e))
          .where((e) => e.code.isNotEmpty)
          .toList();
    }
    return [];
  }
}
