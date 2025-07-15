import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart'; // Certifique-se de que a classe Character está definida neste arquivo ou importada corretamente

// 1. Definição da exceção personalizada
class CharacterNotFoundException implements Exception {
  final String message;
  CharacterNotFoundException([this.message = "Nenhum personagem encontrado com os critérios."]);

  @override
  String toString() => "CharacterNotFoundException: $message";
}

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
      // Verifica se 'results' existe e não é nulo. Se não houver resultados, 'results' pode ser nulo.
      if (data['results'] != null) {
        final results = data['results'] as List;
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        // Se a API retorna 200 mas com 'results' nulo (o que pode acontecer se a página for inválida, por exemplo),
        // tratamos como uma lista vazia.
        return [];
      }
    } else if (response.statusCode == 404) {
      // 2. Lança a exceção personalizada para 404 (personagem não encontrado)
      throw CharacterNotFoundException('Nenhum personagem encontrado com os filtros aplicados.');
    } else {
      // Lança uma exceção genérica para outros erros HTTP
      throw Exception('Falha ao carregar personagens: Status ${response.statusCode}');
    }
  }
}
