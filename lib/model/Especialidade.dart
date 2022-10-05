class Especialidade {
  int? idEspecialidade;
  late String descricao;

  Especialidade({this.idEspecialidade, required this.descricao});

  Especialidade.fromJson(Map<String, dynamic> json) {
    idEspecialidade = json['id_especialidade'];
    descricao = json['descricao'];
  }

  factory Especialidade.fromJson1(dynamic json) {
    return Especialidade(
      idEspecialidade: int.parse(json['id']),
      descricao: json['descricao'],
    );
  }

  Especialidade.fromMap(Map<String, dynamic> map, int id){
    this.idEspecialidade = id;
    this.descricao = map['descricao'];
  }

  Especialidade.fromSnapshot(int id, Map<String, dynamic> snapshot){
    print("fromSnapshot Especialidades");
    this.idEspecialidade = id;
    this.descricao = snapshot['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_especialidade'] = this.idEspecialidade;
    data['descricao'] = this.descricao;
    return data;
  }
}
