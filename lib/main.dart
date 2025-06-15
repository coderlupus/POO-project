import 'package:flutter/material.dart';
import 'character_list_page.dart';

void main() {
  runApp(RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CharacterListPage(),
    );
  }
}
