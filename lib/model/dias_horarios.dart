class DiasHorarios {
  int? id;
  String? dia;
  String? hora;

  DiasHorarios(
      {this.id, this.dia, this.hora});

  factory DiasHorarios.fromJson1(dynamic json) {
    return DiasHorarios(
      id:  int.parse(json['id']),
      dia: json['dia'],
      hora: json['hora'],
    );
  }

  DiasHorarios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dia = json['dia'];
    hora = json['hora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dia'] = this.dia;
    data['hora'] = this.hora;
    return data;
  }
}
