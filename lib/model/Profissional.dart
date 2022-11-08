class Profissional {
  int? id;
  String? nome;
  String? cpf;
  String? endereco;
  String? telefone;
  String? dataNascimento;
  String? numero;
  String? status;
  String? email;
  String? senha;

  Profissional(
      {this.id,
        this.nome,
        this.cpf,
        this.endereco,
        this.telefone,
        this.dataNascimento,
        this.numero,
        this.status,
        this.email,
        this.senha
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
    email = json['email'];
    senha = json['senha'];
  }

  factory Profissional.fromJson1(dynamic json, Map<String, dynamic> doc) {
    return Profissional(
      id: int.parse(json['id']),
      nome: json['nome_profissional'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
      dataNascimento: json['data_nascimento'] as String,
      status: json['status'] as String,
      cpf: json['cpf'] as String,
      telefone: json['telefone'] as String,
      endereco: json['endereco'] as String,
      numero: json['numero'] as String,
    );
  }

  Profissional.fromSnapshot(String uid, Map<String, dynamic> snapshot){
    print("Profissional.fromSnapshot");
    this.id = int.parse(snapshot['id']);
    this.email = snapshot['email'];
    this.senha = snapshot['senha'];
    this.status = snapshot['status'];
    this.nome = snapshot['nome_profissional'];
    this.cpf = snapshot['cpf'];
    this.dataNascimento = snapshot['data_nascimento'];
    this.endereco = snapshot['endereco'];
    this.telefone = snapshot['telefone'];
    this.numero = snapshot['numero'];
  }

  Profissional.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.status = map['status'];
    this.telefone = map['telefone'];
    this.endereco = map['endereco'];
    this.nome = map['nome_profissional'];
    this.cpf = map['cpf'];
    this.dataNascimento = map['data_nascimento'];
    this.numero = map['numero'];
    this.email = map['email'];
    this.senha = map['senha'];
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
    data['email'] = this.status;
    data['senha'] = this.status;
    return data;
  }
}