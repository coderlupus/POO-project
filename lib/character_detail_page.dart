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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(character.image, height: 300),
            ),
            const SizedBox(height: 20),
            Text(
              character.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 247, 255),
              ),
            ),
            const SizedBox(height: 10),
            Text('Species: ${character.species}', style: const TextStyle(fontSize: 18)),
            Text('Status: ${character.status}', style: const TextStyle(fontSize: 18)),
            Text('Origin: ${character.originName}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
