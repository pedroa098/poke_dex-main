import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:poke_dex/models/pokemon_list_model.dart';
import 'package:poke_dex/models/pokemon_model.dart';
import 'pokemon_detail_page.dart';

class PokeHomePage extends StatefulWidget {
  const PokeHomePage({super.key});

  @override
  State<PokeHomePage> createState() => _PokeHomePageState();
}

class _PokeHomePageState extends State<PokeHomePage> {
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  Future<void> _fetchPokemons() async {
    final dio = Dio();
    try {
      final response = await dio
          .get('https://pokeapi.co/api/v2/pokemon?limit=1000&offset=0');
      var model = PokemonListModel.fromMap(response.data);
      setState(() {
        _pokemonList = model.results;
        _filteredPokemonList = _pokemonList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao carregar Pokémon: $e";
        _isLoading = false;
      });
    }
  }

  void _filterPokemons(String query) {
    setState(() {
      _filteredPokemonList = _pokemonList
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Pokedex"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar Pokémon',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterPokemons,
            ),
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingIndicator()
                : _errorMessage != null
                    ? _buildErrorWidget(_errorMessage!)
                    : _filteredPokemonList.isEmpty
                        ? _buildEmptyWidget()
                        : _buildPokemonGrid(_filteredPokemonList),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Text("Nenhum Pokémon encontrado."),
    );
  }

  Widget _buildPokemonGrid(List<Pokemon> pokemonList) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.2,
      ),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        var pokemon = pokemonList[index];
        return FutureBuilder<Map<String, dynamic>>(
          future: _fetchPokemonDetails(pokemon.url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Erro: ${snapshot.error}"));
              }

              var details = snapshot.data;
              if (details == null) {
                return const Center(child: Text("Detalhes não encontrados!"));
              }

              var imageUrl = details['sprites']['front_default'];
              var name = pokemon.name;

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    var contesto = scaffoldKey.currentContext ?? context;
                    Navigator.push(
                      contesto,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailPage(
                          pokemonUrl: pokemon.url,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        imageUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchPokemonDetails(String url) async {
    final dio = Dio();
    final response = await dio.get(url);
    return response.data;
  }
}
