import '../models/translation_model.dart';
import 'base_client.dart';

class TranslationService {
  static Future<List<TranslationModel>> getTranslations({
    required String host,
    required String path,
    String? category,
  }) async {
    final Map<String, dynamic> query = category != null
        ? {"category": category}
        : {};

    final response = await BaseClient.get(host, path, query: query);

    if (response is List) {
      return response.map((e) => TranslationModel.fromJson(e)).toList();
    }
    return [];
  }
}
