class Usuario {
  int? idUsuario;
  String? UidUsuario;
  String? nomeUsuario;
  String? loginUsuario;
  String? emailUsuario;
  String? senhaUsuario;
  String? statusUsuario;
  String? tokenUsuario;
  String? dataNascimentoUsuario;
  String? telefone;
  String? tipoUsuario;

  Usuario(
      {int? idUsuario,
        String? nomeUsuario,
        String? loginUsuario,
        String? emailUsuario,
        String? senhaUsuario,
        String? statusUsuario,
        String? tokenUsuario,
        String? dataNascimentoUsuario,
        String? telefone,
        String? tipoUsuario
      }) {
    if (idUsuario != null) {
      this.idUsuario = idUsuario;
    }
    if (nomeUsuario != null) {
      this.nomeUsuario = nomeUsuario;
    }
    if (loginUsuario != null) {
      this.loginUsuario = loginUsuario;
    }
    if (emailUsuario != null) {
      this.emailUsuario = emailUsuario;
    }
    if (senhaUsuario != null) {
      this.senhaUsuario = senhaUsuario;
    }
    if (statusUsuario != null) {
      this.statusUsuario = statusUsuario;
    }
    if (tokenUsuario != null) {
      this.tokenUsuario = tokenUsuario;
    }
    if (dataNascimentoUsuario != null) {
      this.dataNascimentoUsuario = dataNascimentoUsuario;
    }
    if (telefone != null) {
      this.telefone = telefone;}
    if (tipoUsuario != null) {
      this.tipoUsuario = tipoUsuario;
    }

  }


  Usuario.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    nomeUsuario = json['nomeUsuario'];
    loginUsuario = json['loginUsuario'];
    emailUsuario = json['emailUsuario'];
    senhaUsuario = json['senhaUsuario'];
    statusUsuario = json['statusUsuario'];
    tokenUsuario = json['tokenUsuario'];
    dataNascimentoUsuario = json['dataNascimentoUsuario'];
    telefone = json['telefone'];
    tipoUsuario = json['tipoUsuario'];
  }

  factory Usuario.fromJson1(dynamic json) {
    return Usuario(
        idUsuario: int.parse(json['idUsuario']),
        nomeUsuario: json['nomeUsuario'] as String,
        loginUsuario: json['loginUsuario'] as String,
        emailUsuario: json['emailUsuario'] as String,
        senhaUsuario: json['senhaUsuario'] as String,
        statusUsuario: json['statusUsuario'] as String,
        tokenUsuario: json['tokenUsuario'] as String,
        dataNascimentoUsuario: json['dataNascimentoUsuario'] as String,
        telefone: json['telefone'] as String,
        tipoUsuario: json['tipoUsuario'] as String,
    );
  }

    Usuario.fromSnapshot(String uid, Map<String, dynamic> snapshot){
    print("Usuario.fromSnapshot");
    this.idUsuario = int.parse(snapshot['idUsuario']);
    this.emailUsuario = snapshot['emailUsuario'];
    this.senhaUsuario = snapshot['senhaUsuario'];
    this.statusUsuario = snapshot['statusUsuario'];
    this.nomeUsuario = snapshot['nomeUsuario'];
    this.loginUsuario = snapshot['loginUsuario'];
    this.tokenUsuario = snapshot['tokenUsuario'];
    this.dataNascimentoUsuario = snapshot['dataNascimentoUsuario'];
    this.telefone = snapshot['telefone'];
    this.tipoUsuario = snapshot['tipoUsuario'];
  }

  Usuario.fromMap(Map<String, dynamic> map, int id){
    this.idUsuario = id;
    this.emailUsuario = map['emailUsuario'];
    this.senhaUsuario = map['senhaUsuario'];
    this.statusUsuario = map['statusUsuario'];
    this.nomeUsuario = map['nomeUsuario'];
    this.loginUsuario = map['loginUsuario'];
    this.tokenUsuario = map['tokenUsuario'];
    this.dataNascimentoUsuario = map['dataNascimentoUsuario'];
    this.telefone = map['telefone'];
    this.tipoUsuario = map['tipoUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['nomeUsuario'] = this.nomeUsuario;
    data['loginUsuario'] = this.loginUsuario;
    data['emailUsuario'] = this.emailUsuario;
    data['senhaUsuario'] = this.senhaUsuario;
    data['statusUsuario'] = this.statusUsuario;
    data['tokenUsuario'] = this.tokenUsuario;
    data['dataNascimentoUsuario'] = this.dataNascimentoUsuario;
    data['telefone'] = this.telefone;
    data['tipoUsuario'] = this.tipoUsuario;
    return data;
  }
}
