class Especialidade {
  String? idEspecialidade;
  String? descricao;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  Especialidade({
    this.idEspecialidade,
    this.descricao});

  // Usuario.fromJson(Map<String, dynamic> json) {

  Especialidade.fromJson(Map<String, dynamic> json) {
    // idEspecialidade = json['id_especialidade'];
    descricao = json['descricao'];
  }

  factory Especialidade.fromJson1(dynamic json) {
    return Especialidade(
      idEspecialidade: (json['id']),
      descricao: json['descricao'],
    );
  }

  Especialidade.fromMap(Map<String, dynamic> map, String id){
    this.idEspecialidade = id;
    this.descricao = map['descricao'];
  }

  Especialidade.fromSnapshot(String id, Map<String, dynamic> snapshot){
    print("fromSnapshot Especialidade");
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
