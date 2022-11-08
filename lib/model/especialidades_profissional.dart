class EspecialidadeProfissional {
  int? id;
  int? idProfissional;
  String? idEspecialidade;
  String? codigoEspecialidade;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  EspecialidadeProfissional({this.id, this.idProfissional, this.idEspecialidade, this.codigoEspecialidade });

  EspecialidadeProfissional.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    idProfissional = int.parse(json['id_profissional']);
    idEspecialidade = json['id_especialidade'];
    codigoEspecialidade = json['codigo_especialidade'];
  }

  factory EspecialidadeProfissional.fromJson1(dynamic json) {
    print(json);
    print("json esp_prof");
    print(int.parse(json['id']));
    print(json['id_especialidade']);
    print(int.parse(json['id_profissional']));

    EspecialidadeProfissional esp = EspecialidadeProfissional(
      id: int.parse(json['id']),
      idEspecialidade:  json['id_especialidade'],
      idProfissional: int.parse(json['id_profissional']),
      codigoEspecialidade: json['codigo_especialidade']
    );

    print("esp ${esp.codigoEspecialidade}");
    return esp;
  }

  EspecialidadeProfissional.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.idProfissional = int.parse(map['id_profissional']);
    this.codigoEspecialidade = map['codigo_especialidade'];
    this.idEspecialidade = map['id_especialidade'];
  }

  EspecialidadeProfissional.fromSnapshot(int id, Map<String, dynamic> snapshot){
    print("fromSnapshot EspecialidadesProfissional");
    this.id = id;
    this.idEspecialidade = snapshot['id_especialidade'];
    this.idProfissional = snapshot['id_profissional'];
    this.codigoEspecialidade = snapshot['codigo_especialidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_especialidade'] = this.idEspecialidade;
    data['id_profissional'] = this.idProfissional;
    data['codigo_especialidade'] = this.idProfissional;
    return data;
  }
}
