import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart';

class RickAndMortyApi {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static Future<List<Character>> fetchCharacters({
    String? name,
    String? status,
    int page = 1,
  }) async {
    final queryParameters = <String, String>{};
    if (name != null && name.isNotEmpty) {
      queryParameters['name'] = name;
    }
    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }
    queryParameters['page'] = page.toString();

    final uri = Uri.parse(
      '$baseUrl/character',
    ).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar personagens');
    }
  }
}
