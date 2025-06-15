import 'package:flutter/material.dart';
import 'character.dart';
import 'rick_and_morty_api.dart';
import 'character_detail_page.dart';
import 'filter_page.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  CharacterListPageState createState() => CharacterListPageState();
}

class CharacterListPageState extends State<CharacterListPage> {
  late Future<List<Character>> futureCharacters;
  String? filterName;
  String? filterStatus;

  @override
  void initState() {
    super.initState();
    futureCharacters = RickAndMortyApi.fetchCharacters();
  }

  void _applyFilter(String? name, String? status) {
    setState(() {
      filterName = name;
      filterStatus = status;
      futureCharacters = RickAndMortyApi.fetchCharacters(name: name, status: status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens Rick and Morty'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filters = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilterPage(name: filterName, status: filterStatus),
                ),
              );
              if (filters != null) {
                _applyFilter(filters['name'], filters['status']);
              }
            },
          )
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        character.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      character.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${character.species} - ${character.status}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CharacterDetailPage(character: character),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar personagens'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
