import 'package:flutter/material.dart';
import 'character.dart';
import 'rick_and_morty_api.dart'; 
import 'character_detail_page.dart';

class CharacterListPage extends StatefulWidget {
  final String? filterName;
  final String? filterStatus;

  const CharacterListPage({
    super.key,
    this.filterName,
    this.filterStatus,
  });

  @override
  CharacterListPageState createState() => CharacterListPageState();
}

class CharacterListPageState extends State<CharacterListPage> {
  final List<Character> _characters = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false; // Estado para controle de erro

  @override
  void initState() {
    super.initState();
    _fetchCharacters(); // Chama a busca inicial
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CharacterListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Verifica se os filtros mudaram
    if (widget.filterName != oldWidget.filterName ||
        widget.filterStatus != oldWidget.filterStatus) {
      // Se mudaram, reseta a lista e busca os personagens com os novos filtros
      _fetchCharacters(reset: true);
    }
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
      _hasError = false; // Reseta o estado de erro ao iniciar uma nova busca
    });

    if (reset) {
      _characters.clear();
      _currentPage = 1;
      _hasMore = true;
    }

    try {
      final newCharacters = await RickAndMortyApi.fetchCharacters(
        name: widget.filterName,
        status: widget.filterStatus,
        page: _currentPage,
      );

      setState(() {
        if (newCharacters.isEmpty) { // Se a lista estiver vazia, significa que não há mais resultados
          _hasMore = false;
        } else {
          _characters.addAll(newCharacters);
          _currentPage++;
        }
        _isLoading = false; // Garante que isLoading seja false em caso de sucesso
      });
    } on CharacterNotFoundException { // Captura a exceção específica para "não encontrado"
      setState(() {
        _isLoading = false;
        _hasMore = false;
        _hasError = false; // Não é um erro de sistema, mas sim "não encontrado"
        _characters.clear(); // Limpa a lista para exibir a mensagem de "nenhum resultado"
      });
    } catch (e) {
      // Captura qualquer outro erro que ocorra na chamada da API (erros de rede, servidor, etc.)
      print('Erro ao carregar personagens: $e');
      setState(() {
        _isLoading = false; // Garante que isLoading seja false em caso de erro
        _hasMore = false; // Assume que não há mais dados em caso de erro
        _hasError = true; // Define o estado de erro para erros reais
        _characters.clear(); // Limpa a lista para exibir a mensagem de erro
      });
      // Exibir uma SnackBar para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar personagens. Verifique sua conexão ou tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Condição para mostrar o indicador de carregamento inicial
    if (_characters.isEmpty && _isLoading && _currentPage == 1) {
      return const Center(child: CircularProgressIndicator());
    }
    // Condição para mostrar mensagem de erro (erros reais de sistema/rede)
    else if (_hasError) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.7), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.error_outline, // Ícone de erro
                color: Colors.white,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Ocorreu um erro ao carregar os personagens.',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Por favor, verifique sua conexão e tente novamente.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    // Condição para mostrar "nenhum resultado" quando filtros são aplicados e não há dados (incluindo "personagem não encontrado" via CharacterNotFoundException)
    else if (_characters.isEmpty && !_isLoading && !_hasMore && (widget.filterName != null || widget.filterStatus != null)) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7), // Fundo semi-transparente
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.sentiment_dissatisfied, // Ícone para "nenhum resultado"
                color: Colors.white,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Nenhum personagem encontrado com os filtros aplicados.',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Tente ajustar o nome ou o status do personagem.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    // Caso contrário, exibe a lista de personagens
    else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: _characters.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _characters.length) {
            final character = _characters[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                subtitle: Text(
                  '${character.species} - ${character.status}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CharacterDetailPage(character: character),
                    ),
                  );
                },
              ),
            );
          } else {
            // Exibe o CircularProgressIndicator apenas se ainda houver mais dados para carregar
            return _hasMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink(); // Não mostra nada se não houver mais dados
          }
        },
      );
    }
  }
}
