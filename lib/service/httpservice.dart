import 'dart:developer';
import 'package:http/http.dart' as http;
import '../model/fooditem_model.dart';

class HttpService {
  static const String _baseUrl = 'https://api.nal.usda.gov/fdc/v1/foods/search';

  static const String _apiKey = 'AqKlUE6x3n7TuB1EJzQFGd7B6c9H1rWtJtoF6s7g';

  static Future<List<Food>?> getFoods(
    String query, {
    String? category,
    String? sortBy,
  }) async {
    Map<String, String> queryParams = {
      'query': query,
      'nutrients': '1008,1003,1004,1005',
      'dataType': 'Foundation,SR Legacy,Branded',
      'pageSize': '25',
    };

    if (category != null && category.isNotEmpty) {
      queryParams['foodCategory'] = category;
    }

    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams['sortBy'] = sortBy;
    } else {
      queryParams['sortBy'] = 'lowercaseDescription.keyword';
    }

    var uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        'x-api-key': _apiKey,
        'Content-Type': 'application/json',
      });
      log("HttpService Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Welcome data = welcomeFromJson(response.body);
        return data.foods;
      } else {
        log("HttpService API Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("HttpService Network Error: $e");
      return null;
    }
  }
}
