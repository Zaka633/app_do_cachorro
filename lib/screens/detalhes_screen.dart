import 'package:flutter/material.dart';
import 'package:app_do_cachorro2/models/dog_model.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: _shareDogDetails),
        ],
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
        ? Image.memory(
          base64Decode(dog.imagem!),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        )
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

  Future<void> _shareDogDetails() async {
    final pdf = pw.Document();

    final image =
        dog.imagem != null ? pw.MemoryImage(base64Decode(dog.imagem!)) : null;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (image != null) pw.Image(image, width: 150, height: 150),
              pw.SizedBox(height: 20),
              _buildDetailText('Nome:', dog.nome),
              pw.SizedBox(height: 10),
              _buildDetailText('Raça:', dog.raca),
              pw.SizedBox(height: 10),
              _buildDetailText('Peso:', '${dog.peso} kg'),
              pw.SizedBox(height: 10),
              _buildDetailText('Idade:', '${dog.idade} anos'),
              pw.SizedBox(height: 10),
              _buildDetailText('Telefone:', dog.telefone),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/dog_details.pdf');
    await file.writeAsBytes(await pdf.save());

    Share.shareXFiles([XFile(file.path)], text: 'Detalhes do Cachorro');
  }

  pw.Widget _buildDetailText(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 10),
        pw.Text(value),
      ],
    );
  }
}
