import 'package:flutter/material.dart';
import 'package:app_do_cachorro2/models/dog_model.dart';

class DetalhesScreen extends StatelessWidget {
  final Dog dog;

  const DetalhesScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.lightBlue,
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        title: Text(
          'Detalhes do Cachorro',
          style: TextStyle(color: Colors.lightBlue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildDogImage(),
            SizedBox(height: 20),
            _buildDetailRow('Nome:', dog.nome),
            SizedBox(height: 10),
            _buildDetailRow('Raça:', dog.raca),
            SizedBox(height: 10),
            _buildDetailRow('Peso:', '${dog.peso} kg'),
            SizedBox(height: 10),
            _buildDetailRow('Idade:', '${dog.idade} anos'),
            SizedBox(height: 10),
            _buildDetailRow('Telefone:', dog.telefone),
          ],
        ),
      ),
    );
  }

  Widget _buildDogImage() {
    return dog.imagem != null
        ? Image.network(dog.imagem!, width: 150, height: 150, fit: BoxFit.cover)
        : Icon(Icons.pets, size: 150);
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: <Widget>[
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Text(value),
      ],
    );
  }
}
