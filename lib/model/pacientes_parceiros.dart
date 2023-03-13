class PacientesParceiros {
  int? idPacientesParceiros;
  String? idPaciente;
  int? idParceiro;
  String? status;

  PacientesParceiros(
      {this.idPacientesParceiros, this.idPaciente, this.idParceiro, this.status});

  PacientesParceiros.fromJson(Map<String, dynamic> json) {
    idPacientesParceiros = json['id_pacientes_parceiros'];
    idPaciente = json['id_paciente'];
    idParceiro = json['id_parceiro'];
    status = json['status'];
  }

  factory PacientesParceiros.fromJson1(dynamic json) {

    print("json['id'] ${json['id']}");
    print("json['id'] ${json['idPaciente']}");
    print("json['id'] ${json['idParceiro']}");
    return PacientesParceiros(
      idPacientesParceiros: int.parse(json['id']),
      idPaciente: json['idPaciente'],
      idParceiro: int.parse(json['idParceiro']),
      status: json['status'],
    );
  }

  PacientesParceiros.fromMap(Map<String, dynamic> map, int id){
    this.idPacientesParceiros = id;
    this.idParceiro = int.parse(map['idParceiro']);
    this.idPaciente = map['idPaciente'];
    this.status = map['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_pacientes_parceiros'] = this.idPacientesParceiros;
    data['id_paciente'] = this.idPaciente;
    data['id_parceiro'] = this.idParceiro;
    data['status'] = this.status;
    return data;
  }
}
