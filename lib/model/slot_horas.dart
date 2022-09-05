class SlotHoras {
  int? id;
  int? idEmpresa;
  String? horario;

  SlotHoras({this.id, this.idEmpresa, this.horario});

  SlotHoras.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEmpresa = json['id_empresa'];
    horario = json['horario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_empresa'] = this.idEmpresa;
    data['horario'] = this.horario;
    return data;
  }
}
