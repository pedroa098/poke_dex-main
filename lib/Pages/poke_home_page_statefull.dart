import 'package:flutter/material.dart';

class PokeHomePageStatefull extends StatefulWidget {
  const PokeHomePageStatefull({super.key});

  @override
  State<PokeHomePageStatefull> createState() => _PokeHomePageStatefullState();
}

class _PokeHomePageStatefullState extends State<PokeHomePageStatefull> {
  bool isCarregando = true;

  List<String> listaDePokemon = [];

  @override
  void initState() {
    super.initState();
    _carregaDados;
  }

  Future<void> _carregaDados() async {
    await Future.delayed(Duration(seconds: 4));
    listaDePokemon = ["Charmander", "Pikachu", "MewTwo"];
    isCarregando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Pokemon")
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return isCarregando
        ? CircularProgressIndicator()
        : ListView.builder(
          itemCount: listaDePokemon.length, 
          itemBuilder: (context, index){
            return ListTile(
              title: Text(listaDePokemon[index],),
            );
          }
        ); 
  }
}
