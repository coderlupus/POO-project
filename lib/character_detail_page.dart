import 'package:flutter/material.dart';
import 'character.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // deixa imagem passar atrás da AppBar
      appBar: AppBar(
        title: Text(
          character.name,
          style: const TextStyle(fontFamily: 'get_schwifty'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF121212), // <- aqui você define a cor desejada
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 32,
              left: 20,
              right: 20,
              bottom: 20,
            ),
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
                    fontFamily: 'get_schwifty',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Species: ${character.species}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                Text(
                  'Status: ${character.status}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                Text(
                  'Origin: ${character.originName}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
