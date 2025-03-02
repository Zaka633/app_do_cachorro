import 'package:app_do_cachorro2/screens/creation_screen.dart';
import 'package:app_do_cachorro2/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:app_do_cachorro2/models/dog_model.dart';
import 'package:app_do_cachorro2/screens/detalhes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _dogs = [];

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Future<void> _loadDogs() async {
    final data = await DatabaseHelper().queryAllDogs();
    setState(() {
      _dogs = data;
    });
  }

  Future<void> _deleteDog(int id) async {
    await DatabaseHelper().deleteDog(id);
    _loadDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        title: Text(
          'App do Cachorro',
          style: TextStyle(color: Colors.lightBlue),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _dogs.length,
            itemBuilder: (context, index) {
              final dog = _dogs[index];
              return _buildDogTile(dog);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDogTile(Map<String, dynamic> dog) {
    return ListTile(
      leading: _buildDogImage(dog['imagem']),
      title: Text(dog['nome']),
      subtitle: Text('Raça: ${dog['raca']}'),
      trailing: _buildTileActions(dog),
      onTap: () => _navigateToDetalhesScreen(dog),
    );
  }

  Widget _buildDogImage(String? image) {
    return image != null
        ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
        : Icon(Icons.pets, size: 50);
  }

  Widget _buildTileActions(Map<String, dynamic> dog) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _navigateToCreationScreen(dog),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteDog(dog['id']),
        ),
      ],
    );
  }

  void _navigateToCreationScreen(Map<String, dynamic> dog) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreationScreen(dog: Dog.fromMap(dog)),
      ),
    ).then((_) => _loadDogs());
  }

  void _navigateToDetalhesScreen(Map<String, dynamic> dog) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesScreen(dog: Dog.fromMap(dog)),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreationScreen()),
        ).then((_) => _loadDogs());
      },
      backgroundColor: Colors.lightGreenAccent,
      child: Icon(Icons.add, color: Colors.lightBlue),
    );
  }
}
