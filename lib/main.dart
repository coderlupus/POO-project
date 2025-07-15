import 'package:flutter/material.dart';
import 'character_list_page.dart';
import 'filter_page.dart'; // seu filtro precisa estar importado aqui

void main() {
  runApp(const RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardTheme: const CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: Color(0xFF121212),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 85, 85, 85),
            foregroundColor: const Color.fromARGB(255, 0, 217, 255),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const CharacterListWrapper(),
    );
  }
}

class CharacterListWrapper extends StatefulWidget {
  const CharacterListWrapper({super.key});

  @override
  State<CharacterListWrapper> createState() => _CharacterListWrapperState();
}

class _CharacterListWrapperState extends State<CharacterListWrapper> {
  String? _filterName;
  String? _filterStatus;

  Future<void> _openFilter() async {
    final filters = await Navigator.push<Map<String, String?>>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterPage(
          name: _filterName,
          status: _filterStatus,
        ),
      ),
    );

    if (filters != null) {
      setState(() {
        _filterName = filters['name'];
        _filterStatus = filters['status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Personagens Rick and Morty',
          style: TextStyle(
            fontFamily: 'get_schwifty',
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openFilter,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/teste.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: CharacterListPage(
          filterName: _filterName,
          filterStatus: _filterStatus,
        ),
      ),
    );
  }
}
