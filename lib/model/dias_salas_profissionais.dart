class DiasSalasProfissionais {
  int? id;
  String? descDia;
  String? descSala;
  int? idProfissional;
  String? hora;

  DiasSalasProfissionais(
      {this.id, this.descDia, this.descSala, this.idProfissional, this.hora});

  DiasSalasProfissionais.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descDia = json['desc_dia'];
    descSala = json['desc_sala'];
    idProfissional = json['id_profissional'];
    hora = json['hora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['desc_dia'] = this.descDia;
    data['desc_sala'] = this.descSala;
    data['id_profissional'] = this.idProfissional;
    data['hora'] = this.hora;
    return data;
  }
}
