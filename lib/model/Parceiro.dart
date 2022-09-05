class Parceiro {
  int? id;
  String? razaoSocial;
  String? cnpj;
  String? endereco;
  String? telefone;
  String? email;
  int? desconto;
  String? status;

  Parceiro(
      {this.id,
        this.razaoSocial,
        this.cnpj,
        this.endereco,
        this.telefone,
        this.email,
        this.desconto,
        this.status});

  Parceiro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    razaoSocial = json['razao_social'];
    cnpj = json['cnpj'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    email = json['email'];
    desconto = json['desconto'];
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
    data['status'] = this.status;
    return data;
  }
}
