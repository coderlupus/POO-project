import 'package:flutter/material.dart';
import 'character.dart';
import 'rick_and_morty_api.dart';
import 'character_detail_page.dart';
import 'filter_page.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
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
        title: Text('Rick and Morty Characters'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final filters = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FilterPage(name: filterName, status: filterStatus)),
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
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    leading: Image.network(character.image),
                    title: Text(character.name),
                    subtitle: Text('${character.species} - ${character.status}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CharacterDetailPage(character: character)),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar personagens'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}