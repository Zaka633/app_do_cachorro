class DogImage {
  final String url;

  DogImage({required this.url});

  factory DogImage.fromJson(Map<String, dynamic> json) {
    return DogImage(url: json['message']);
  }
}
