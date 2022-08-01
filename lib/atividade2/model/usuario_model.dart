class UsuarioModel {
  late int idUsuario;
  late String nomeUsuario;
  late String loginUsuario;
  late String emailUsuario;
  late String senhaUsuario;
  late String statusUsuario;
  late String tokenUsuario;

  UsuarioModel({ required this.idUsuario, required this.nomeUsuario, required this.loginUsuario, required this.emailUsuario, required this.senhaUsuario, required this.statusUsuario, required this.tokenUsuario});


  UsuarioModel.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    nomeUsuario = json['nomeUsuario'];
    loginUsuario = json['loginUsuario'];
    emailUsuario = json['emailUsuario'];
    senhaUsuario = json['senhaUsuario'];
    statusUsuario = json['statusUsuario'];
    tokenUsuario = json['tokenUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idUsuario'] = idUsuario;
    data['nomeUsuario'] = nomeUsuario;
    data['loginUsuario'] = loginUsuario;
    data['emailUsuario'] = emailUsuario;
    data['senhaUsuario'] = senhaUsuario;
    data['statusUsuario'] = statusUsuario;
    data['tokenUsuario'] = tokenUsuario;
    return data;
  }
}

