class Profissional {
  int? id;
  String? nome;
  String? cpf;
  String? endereco;
  String? telefone;
  String? dataNascimento;
  String? numero;
  String? status;

  Profissional(
      {this.id,
        this.nome,
        this.cpf,
        this.endereco,
        this.telefone,
        this.dataNascimento,
        this.numero,
        this.status
      });

  Profissional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpf = json['cpf'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    dataNascimento = json['data_nascimento'];
    numero = json['numero'];
    status = json['status'];
  }
  Profissional.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.status = map['status'];
    this.telefone = map['telefone'];
    this.endereco = map['endereco'];
    this.nome = map['nome'];
    this.cpf = map['cpf'];
    this.dataNascimento = map['data_nascimento'];
    this.numero = map['numero'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['endereco'] = this.endereco;
    data['telefone'] = this.telefone;
    data['data_nascimento'] = this.dataNascimento;
    data['numero'] = this.numero;
    data['status'] = this.status;
    return data;
  }
}