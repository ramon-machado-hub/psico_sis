class Paciente {
  int? idPaciente;
  String? nome;
  String? cpf;
  String? endereco;
  String? telefone;
  String? dataNascimento;
  int? numero;

  Paciente(
      {this.idPaciente,
        this.nome,
        this.cpf,
        this.endereco,
        this.telefone,
        this.dataNascimento,
        this.numero
      });

  Paciente.fromMap(Map<String, dynamic> map, int id){
    this.idPaciente = id;
    this.nome = map['nome_paciente'];
    this.endereco = map['endereco'];
    this.dataNascimento = map['data_nascimento'];
    this.telefone = map['telefone'];
    this.cpf = map['cpf'];
    this.numero = map['numero'];
  }

  Paciente.fromJson(Map<String, dynamic> json) {
    idPaciente = json['id_paciente'];
    nome = json['nome'];
    cpf = json['cpf'];
    endereco = json['endereco'];
    numero = json['numero'];
    telefone = json['telefone'];
    dataNascimento = json['data_nascimento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_paciente'] = this.idPaciente;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['endereco'] = this.endereco;
    data['numero'] = this.numero;
    data['telefone'] = this.telefone;
    data['data_nascimento'] = this.dataNascimento;
    return data;
  }
}
