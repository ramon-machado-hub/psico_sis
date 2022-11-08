class DiasSalasProfissionais {
  int? id;
  String? dia;
  String? sala;
  int? idProfissional;
  String? hora;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  DiasSalasProfissionais(
      {this.id, this.dia, this.sala, this.idProfissional, this.hora});

  DiasSalasProfissionais.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    dia = json['dia'];
    sala = json['sala'];
    idProfissional = int.parse(json['id_profissional']);
    hora = json['hora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dia'] = this.dia;
    data['sala'] = this.sala;
    data['id_profissional'] = this.idProfissional;
    data['hora'] = this.hora;
    return data;
  }


}
