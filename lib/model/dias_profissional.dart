class DiasProfissional {
  String? id;
  String? idProfissional;
  String? dia;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  DiasProfissional({this.id, this.idProfissional, this.dia});

  DiasProfissional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProfissional = json['id_profissional'];
    dia = json['dia'];
  }

  factory DiasProfissional.fromJson1(dynamic json) {
    return DiasProfissional(
      idProfissional: (json['id']),
      dia: json['dia'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_profissional'] = this.idProfissional;
    data['dia'] = this.dia;
    return data;
  }
}
