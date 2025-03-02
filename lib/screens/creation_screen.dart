import 'package:app_do_cachorro2/db/db_helper.dart';
import 'package:app_do_cachorro2/models/dog_model.dart';
import 'package:app_do_cachorro2/services/carregar_img.dart';
import 'package:flutter/material.dart';

class CreationScreen extends StatefulWidget {
  final Dog? dog;

  const CreationScreen({super.key, this.dog});

  @override
  CreationScreenState createState() => CreationScreenState();
}

class CreationScreenState extends State<CreationScreen> {
  String? _base64Image;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _idadeController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.dog != null) {
      _populateFields(widget.dog!);
    }
  }

  void _populateFields(Dog dog) {
    _nomeController.text = dog.nome;
    _racaController.text = dog.raca;
    _pesoController.text = dog.peso.toString();
    _idadeController.text = dog.idade.toString();
    _telefoneController.text = dog.telefone;
    _base64Image = dog.imagem;
  }

  Future<void> _fetchImageFromApi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dogImageService = DogImageService();
      final imageUrl = await dogImageService.fetchDogImage();
      setState(() {
        _base64Image = imageUrl?.url;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar imagem: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.lightBlue,
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        title: Text(
          'App do Cachorro',
          style: TextStyle(color: Colors.lightBlue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildImagePicker(),
              SizedBox(height: 20),
              _buildTextField(_nomeController, 'Nome do Cachorro'),
              SizedBox(height: 20),
              _buildTextField(_racaController, 'Raça do Cachorro'),
              SizedBox(height: 20),
              _buildTextField(
                _pesoController,
                'Peso do Cachorro (kg)',
                isNumeric: true,
              ),
              SizedBox(height: 20),
              _buildTextField(
                _idadeController,
                'Idade do Cachorro (anos)',
                isNumeric: true,
              ),
              SizedBox(height: 20),
              _buildTextField(
                _telefoneController,
                'Telefone do Dono',
                isPhone: true,
              ),
              SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _isLoading ? null : _fetchImageFromApi,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _base64Image != null
                ? Image.network(_base64Image!, fit: BoxFit.cover)
                : Icon(Icons.add_a_photo, color: Colors.grey, size: 50),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumeric = false,
    bool isPhone = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      keyboardType:
          isNumeric
              ? TextInputType.number
              : isPhone
              ? TextInputType.phone
              : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $label';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _saveDog();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreenAccent,
        foregroundColor: Colors.lightBlue,
      ),
      child: Text(widget.dog == null ? 'Cadastrar' : 'Atualizar'),
    );
  }

  void _saveDog() async {
    Dog dog = Dog(
      id: widget.dog?.id,
      nome: _nomeController.text,
      raca: _racaController.text,
      peso: double.tryParse(_pesoController.text) ?? 0.0,
      idade: int.tryParse(_idadeController.text) ?? 0,
      telefone: _telefoneController.text,
      imagem: _base64Image,
    );

    if (widget.dog == null) {
      await DatabaseHelper().insertDog(dog.toMap());
    } else {
      await DatabaseHelper().updateDog(dog.toMap());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.dog == null
              ? 'Dog cadastrado com sucesso!'
              : 'Dog atualizado com sucesso!',
          style: TextStyle(color: Colors.lightBlue),
        ),
        backgroundColor: Colors.lightGreenAccent,
      ),
    );
    Navigator.pop(context);
  }
}
