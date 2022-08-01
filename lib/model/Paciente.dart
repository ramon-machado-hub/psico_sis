class Paciente {
  int? idPaciente;
  String? nome;
  String? cpf;
  String? endereco;
  String? telefone;
  String? dataNascimento;

  Paciente(
      {this.idPaciente,
        this.nome,
        this.cpf,
        this.endereco,
        this.telefone,
        this.dataNascimento});

  Paciente.fromJson(Map<String, dynamic> json) {
    idPaciente = json['id_paciente'];
    nome = json['nome'];
    cpf = json['cpf'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    dataNascimento = json['data_nascimento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_paciente'] = this.idPaciente;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['endereco'] = this.endereco;
    data['telefone'] = this.telefone;
    data['data_nascimento'] = this.dataNascimento;
    return data;
  }
}
