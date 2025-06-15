import 'package:flutter/material.dart';
import 'character.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(character.image),
            SizedBox(height: 16),
            Text(
              character.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Espécie: ${character.species}'),
            Text('Status: ${character.status}'),
            Text('Origem: ${character.originName}'),
          ],
        ),
      ),
    );
  }
}
