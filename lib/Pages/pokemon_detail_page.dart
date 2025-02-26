import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/pokemon_details_model.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonUrl;

  const PokemonDetailPage({super.key, required this.pokemonUrl});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late PokemonDetails _pokemonDetails;
  bool _isLoading = true;
  bool casoShiny = false; // Movido para ser uma variável de instância

  @override
  void initState() {
    super.initState();
    _fetchPokemonDetails();
  }

  Future<void> _fetchPokemonDetails() async {
    final dio = Dio();
    final response = await dio.get(widget.pokemonUrl);
    _pokemonDetails = PokemonDetails.fromMap(response.data);
    setState(() {
      _isLoading = false;
    });
  }

  /// Retorna a cor de fundo com base no tipo do Pokémon
  Color _getBackgroundColor() {
    if (_isLoading || _pokemonDetails.types.isEmpty) {
      return Colors.grey; // Cor padrão se não houver tipos
    }

    // Mapeia o primeiro tipo para uma cor
    switch (_pokemonDetails.types[0]) {
      case 'grass':
        return const Color.fromARGB(255, 55, 212, 60);
      case 'fire':
        return const Color.fromARGB(255, 240, 73, 7);
      case 'water':
        return const Color.fromARGB(255, 10, 115, 201);
      case 'electric':
        return Colors.amber;
      case 'poison':
        return const Color.fromARGB(255, 175, 37, 202);
      case 'bug':
        return const Color.fromARGB(255, 138, 204, 63);
      case 'flying':
        return const Color.fromARGB(255, 113, 191, 228);
      case 'normal':
        return const Color.fromARGB(255, 201, 199, 199);
      case 'fighting':
        return const Color.fromARGB(255, 218, 6, 6);
      case 'rock':
        return const Color.fromARGB(255, 199, 99, 63);
      case 'ground':
        return const Color.fromARGB(255, 172, 84, 1);
      case 'psychic':
        return Colors.deepPurpleAccent.shade100;
      case 'fairy':
        return const Color.fromARGB(255, 214, 106, 182);
      case 'ghost':
        return const Color.fromARGB(255, 109, 16, 231);
      case 'dragon':
        return const Color.fromARGB(255, 1, 60, 223);
      case 'ice':
        return const Color.fromARGB(255, 0, 162, 255);
      default:
        return Colors.grey;
    }
  }

  Widget _buildBody() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    }
    var pokemon = _pokemonDetails;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Efeito de blur
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2), // Cor com transparência
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Título
                    _buildPokemonName(pokemon),
                    const SizedBox(height: 20),
                    // Imagem do Pokémon
                    _buildPokemonImage(pokemon),
                    const SizedBox(height: 20),
                    // Tipos do Pokémon
                    _buildPokemonTypes(pokemon),
                    const SizedBox(height: 20),
                    // Cards de informações
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card de informações básicas
                        _buildInformacoesBasicas(pokemon),
                        const SizedBox(width: 20),
                        // carta de habilidades
                        _buildHabilidades(pokemon),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Card de estatísticas
                    Card(
                      elevation: 4,
                      color: Colors.white
                          .withOpacity(0.2), // Cor com transparência
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Estatísticas",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.white, // Texto branco para contraste
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildStatRow("HP", pokemon.hp),
                            _buildStatRow("Ataque", pokemon.attack),
                            _buildStatRow("Defesa", pokemon.defense),
                            _buildStatRow(
                                "Ataque Special", pokemon.specialAttack),
                            _buildStatRow(
                                "Defesa Special", pokemon.specialDefense),
                            _buildStatRow("Velocidade", pokemon.speed),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card _buildHabilidades(PokemonDetails pokemon) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.2), // Cor com transparência
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ataques",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto branco para contraste
              ),
            ),
            const SizedBox(height: 10),
            ...pokemon.abilities
                .map((ability) => Text(
                      "- $ability",
                      style: const TextStyle(
                        color: Colors.white, // Texto branco para contraste
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Card _buildInformacoesBasicas(PokemonDetails pokemon) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 0, 0, 0)
          .withOpacity(0.5), // Cor com transparência
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Text(
              "Informações",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto branco para contraste
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Altura: ${pokemon.height} m",
              style: const TextStyle(
                color: Colors.white, // Texto branco para contraste
              ),
            ),
            Text(
              "Peso: ${pokemon.weight} kg",
              style: const TextStyle(
                color: Colors.white, // Texto branco para contraste
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildPokemonTypes(PokemonDetails pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pokemon.types.map((type) {
        IconData icon;
        Color color;

        // ícones e cores
        switch (type) {
          case 'grass':
            icon = Icons.grass;
            color = Colors.green;
            break;
          case 'fire':
            icon = Icons.local_fire_department;
            color = const Color.fromARGB(255, 240, 73, 7);
            break;
          case 'water':
            icon = Icons.water_drop;
            color = const Color.fromARGB(255, 0, 85, 155);
            break;
          case 'electric':
            icon = Icons.bolt;
            color = Colors.yellow;
            break;
          case 'poison':
            icon = FontAwesomeIcons.skullCrossbones;
            color = Colors.deepPurple;
            break;
          case 'bug':
            icon = FontAwesomeIcons.bug;
            color = Colors.lightGreen;
            break;
          case 'flying':
            icon = FontAwesomeIcons.feather;
            color = Colors.lightBlueAccent;
            break;
          case 'normal':
            icon = FontAwesomeIcons.circle;
            color = Colors.grey;
            break;
          case 'fighting':
            icon = FontAwesomeIcons.handBackFist;
            color = const Color.fromARGB(255, 219, 31, 31);
            break;
          case 'rock':
            icon = FontAwesomeIcons.gem;
            color = const Color.fromARGB(255, 209, 88, 8);
            break;
          case 'ground':
            icon = Icons.terrain_outlined;
            color = Colors.redAccent;
            break;
          case 'ghost':
            icon = FontAwesomeIcons.ghost;
            color = const Color.fromARGB(255, 80, 47, 88);
            break;
          case 'psychic':
            icon = FontAwesomeIcons.eye;
            color = const Color.fromARGB(255, 211, 46, 189);
            break;
          case 'fairy':
            icon = FontAwesomeIcons.starOfDavid;
            color = const Color.fromARGB(255, 204, 85, 168);
            break;
          case 'dragon':
            icon = FontAwesomeIcons.dragon;
            color = const Color.fromARGB(255, 4, 0, 255);
            break;
          case 'ice':
            icon = Icons.ac_unit;
            color = const Color.fromARGB(255, 0, 238, 255);
            break;
          default:
            icon = Icons.question_mark;
            color = Colors.grey;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              Text(
                type.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white, // Texto branco para contraste
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPokemonName(PokemonDetails pokemon) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Movimentos"),
          content: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
                5,
                (e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Movim 1"),
                      ),
                    )),
          ),
        ),
      ),
      child: Text(
        pokemon.name.toUpperCase(),
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Texto branco para contraste
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _getBackgroundColor();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Detalhes do Pokémon"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildStatRow(String label, int value) {
    IconData icon;

    // Escolha o ícone com base no rótulo da estatística
    switch (label.toLowerCase()) {
      case 'hp':
        icon = FontAwesomeIcons.heart;
        break;
      case 'ataque':
        icon = FontAwesomeIcons.fistRaised;
        break;
      case 'defesa':
        icon = FontAwesomeIcons.shieldAlt;
        break;
      case 'ataque special':
        icon = FontAwesomeIcons.magic;
        break;
      case 'defesa special':
        icon = FontAwesomeIcons.shieldVirus;
        break;
      case 'velocidade':
        icon = FontAwesomeIcons.tachometerAlt;
        break;
      default:
        icon = Icons.help_outline; // Ícone padrão caso não seja encontrado
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Ícone da estatística
          Icon(
            icon,
            color: Colors.white, // Cor do ícone
            size: 20,
          ),
          const SizedBox(width: 8), // Espaçamento entre o ícone e o texto
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white, // Texto branco para contraste
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[300],
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getColorForStat(value)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Texto branco para contraste
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonImage(PokemonDetails pokemon) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.network(
          pokemon.imageUrl,
          fit: BoxFit.contain,
          height: 90,
          width: 90,
        ),
      ),
    );
  }

  Color _getColorForStat(int value) {
    if (value >= 80) {
      return Colors.green;
    } else if (value >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
