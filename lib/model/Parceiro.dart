class Parceiro {
  int? id;
  String? razaoSocial;
  String? cnpj;
  String? endereco;
  String? telefone;
  String? email;
  int? desconto;
  int? numero;
  String? status;

  Parceiro(
      {this.id,
        this.razaoSocial,
        this.cnpj,
        this.endereco,
        this.telefone,
        this.email,
        this.desconto,
        this.numero,
        this.status});


  factory Parceiro.fromJson1(dynamic json) {
    return Parceiro(
      id:  int.parse(json['id']),
      razaoSocial: json['razaoSocial'] as String,
      cnpj: json['cnpj'] as String,
      endereco: json['endereco'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      desconto: json['desconto'],
      numero: json['numero'],
      status: json['status'] as String,
    );
  }
  Parceiro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    razaoSocial = json['razao_social'];
    cnpj = json['cnpj'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    email = json['email'];
    desconto = json['desconto'];
    numero = json['numero'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['razao_social'] = this.razaoSocial;
    data['cnpj'] = this.cnpj;
    data['endereco'] = this.endereco;
    data['telefone'] = this.telefone;
    data['email'] = this.email;
    data['desconto'] = this.desconto;
    data['numero'] = this.numero;
    data['status'] = this.status;
    return data;
  }

  Parceiro.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.status = map['status'];
    this.desconto = map['desconto'];
    this.numero = map['numero'];
    this.email = map['email'];
    this.telefone = map['telefone'];
    this.endereco = map['endereco'];
    this.razaoSocial = map['razaoSocial'];
    this.cnpj = map['cnpj'];
  }
}
