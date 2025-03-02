import 'dart:convert';
import 'package:app_do_cachorro2/models/image_model.dart';
import 'package:http/http.dart' as http;

class DogImageService {
  final String _url = 'https://dog.ceo/api/breeds/image/random';

  Future<DogImage?> fetchDogImage() async {
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return DogImage.fromJson(data);
      } else {
        throw Exception('Deu ruim');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
