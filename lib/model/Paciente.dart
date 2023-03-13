class Paciente {
  String? idPaciente;
  String? nome;
  String? nome_responsavel;
  String? cpf;
  String? endereco;
  String? telefone;
  String? dataNascimento;
  int? numero;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  Paciente(
      {this.idPaciente,
        this.nome,
        this.nome_responsavel,
        this.cpf,
        this.endereco,
        this.telefone,
        this.dataNascimento,
        this.numero
      });

  Paciente.fromMap(Map<String, dynamic> map, String id){
    this.idPaciente = id;
    this.nome = map['nome_paciente'];
    this.endereco = map['endereco'];
    this.dataNascimento = map['data_nascimento'];
    this.telefone = map['telefone'];
    this.cpf = map['cpf'];
    this.numero = map['numero'];
    this.nome_responsavel = map['nome_responsavel'];
  }

  factory Paciente.fromJson1(dynamic json) {
    return Paciente(
      // idPaciente: json['id'],
      nome: json['nome_paciente'],
      cpf: json['cpf'],
      endereco: json['endereco'],
      numero: json['numero'],
      telefone: json['telefone'],
      dataNascimento: json['data_nascimento'],
      nome_responsavel: json['nome_responsavel'],
    );
  }

  Paciente.fromJson(Map<String, dynamic> json) {
    // idPaciente = json.id;
    nome = json['nome_paciente'];
    cpf = json['cpf'];
    endereco = json['endereco'];
    numero = json['numero'];
    telefone = json['telefone'];
    dataNascimento = json['data_nascimento'];
    nome_responsavel = json['nome_responsavel'];
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
    data['nome_responsavel'] = this.nome_responsavel;
    return data;
  }
}
