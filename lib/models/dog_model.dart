class Dog {
  int? id;
  String nome;
  String raca;
  double peso;
  int idade;
  String telefone;
  String? imagem;
  DateTime dataAdicao;

  Dog({
    this.id,
    required this.nome,
    required this.raca,
    required this.peso,
    required this.idade,
    required this.telefone,
    this.imagem,
    required this.dataAdicao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'raca': raca,
      'peso': peso,
      'idade': idade,
      'telefone': telefone,
      'imagem': imagem,
      'dataAdicao': dataAdicao.toIso8601String(),
    };
  }

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'],
      nome: map['nome'],
      raca: map['raca'],
      peso: map['peso'],
      idade: map['idade'],
      telefone: map['telefone'],
      imagem: map['imagem'],
      dataAdicao: DateTime.parse(map['dataAdicao']),
    );
  }
}
