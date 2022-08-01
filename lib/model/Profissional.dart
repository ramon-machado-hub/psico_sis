class Profissional {
  int? id;
  String? nome;
  String? cpf;
  String? endereco;
  String? telefone;
  String? dataNascimento;
  String? especialidade;
  String? codigoEspecialidade;

  Profissional(
      {this.id,
        this.nome,
        this.cpf,
        this.endereco,
        this.telefone,
        this.dataNascimento,
        this.especialidade,
        this.codigoEspecialidade});

  Profissional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpf = json['cpf'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    dataNascimento = json['data_nascimento'];
    especialidade = json['especialidade'];
    codigoEspecialidade = json['codigo_especialidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['endereco'] = this.endereco;
    data['telefone'] = this.telefone;
    data['data_nascimento'] = this.dataNascimento;
    data['especialidade'] = this.especialidade;
    data['codigo_especialidade'] = this.codigoEspecialidade;
    return data;
  }
}