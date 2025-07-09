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
  final List<Character> _characters = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? filterName;
  String? filterStatus;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchCharacters();
    }
  }

  Future<void> _fetchCharacters({bool reset = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    if (reset) {
      _characters.clear();
      _currentPage = 1;
      _hasMore = true;
    }

    final newCharacters = await RickAndMortyApi.fetchCharacters(
      name: filterName,
      status: filterStatus,
      page: _currentPage,
    );

    setState(() {
      if (newCharacters.isEmpty) {
        _hasMore = false;
      } else {
        _characters.addAll(newCharacters);
        _currentPage++;
      }
      _isLoading = false;
    });
  }

  void _applyFilter(String? name, String? status) {
    setState(() {
      filterName = name;
      filterStatus = status;
    });
    _fetchCharacters(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  centerTitle: true, 
  title: const Text(
    'Rick and Morty',
    style: TextStyle(
      fontFamily: 'get_schwifty',
      fontSize: 24,
    ),
  ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Color.fromARGB(255, 0, 217, 255), // cor visível
            ),
            onPressed: () async {
              final filters = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FilterPage(name: filterName, status: filterStatus),
                ),
              );
              if (filters != null) {
                _applyFilter(filters['name'], filters['status']);
              }
            },
          ),
        ],
      ),
      body: _characters.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _characters.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _characters.length) {
                  final character = _characters[index];
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CharacterDetailPage(character: character),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                character.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    character.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 0, 217, 255),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    character.species,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // Loader at the end
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
    );
  }
}
