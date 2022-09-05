class PacientesParceiros {
  int? idPacientesParceiros;
  int? idPaciente;
  int? idParceiro;

  PacientesParceiros(
      {this.idPacientesParceiros, this.idPaciente, this.idParceiro});

  PacientesParceiros.fromJson(Map<String, dynamic> json) {
    idPacientesParceiros = json['id_pacientes_parceiros'];
    idPaciente = json['id_paciente'];
    idParceiro = json['id_parceiro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_pacientes_parceiros'] = this.idPacientesParceiros;
    data['id_paciente'] = this.idPaciente;
    data['id_parceiro'] = this.idParceiro;
    return data;
  }
}
