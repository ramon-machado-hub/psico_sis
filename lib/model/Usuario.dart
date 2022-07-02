class Usuario {
  int? _idUsuario;
  String? _nomeUsuario;
  String? _loginUsuario;
  String? _emailUsuario;
  String? _senhaUsuario;
  String? _statusUsuario;
  String? _tokenUsuario;

  Usuario(
      {int? idUsuario,
        String? nomeUsuario,
        String? loginUsuario,
        String? emailUsuario,
        String? senhaUsuario,
        String? statusUsuario,
        String? tokenUsuario}) {
    if (idUsuario != null) {
      this._idUsuario = idUsuario;
    }
    if (nomeUsuario != null) {
      this._nomeUsuario = nomeUsuario;
    }
    if (loginUsuario != null) {
      this._loginUsuario = loginUsuario;
    }
    if (emailUsuario != null) {
      this._emailUsuario = emailUsuario;
    }
    if (senhaUsuario != null) {
      this._senhaUsuario = senhaUsuario;
    }
    if (statusUsuario != null) {
      this._statusUsuario = statusUsuario;
    }
    if (tokenUsuario != null) {
      this._tokenUsuario = tokenUsuario;
    }
  }

  int? get idUsuario => _idUsuario;
  set idUsuario(int? idUsuario) => _idUsuario = idUsuario;
  String? get nomeUsuario => _nomeUsuario;
  set nomeUsuario(String? nomeUsuario) => _nomeUsuario = nomeUsuario;
  String? get loginUsuario => _loginUsuario;
  set loginUsuario(String? loginUsuario) => _loginUsuario = loginUsuario;
  String? get emailUsuario => _emailUsuario;
  set emailUsuario(String? emailUsuario) => _emailUsuario = emailUsuario;
  String? get senhaUsuario => _senhaUsuario;
  set senhaUsuario(String? senhaUsuario) => _senhaUsuario = senhaUsuario;
  String? get statusUsuario => _statusUsuario;
  set statusUsuario(String? statusUsuario) => _statusUsuario = statusUsuario;
  String? get tokenUsuario => _tokenUsuario;
  set tokenUsuario(String? tokenUsuario) => _tokenUsuario = tokenUsuario;

  Usuario.fromJson(Map<String, dynamic> json) {
    _idUsuario = json['idUsuario'];
    _nomeUsuario = json['nomeUsuario'];
    _loginUsuario = json['loginUsuario'];
    _emailUsuario = json['emailUsuario'];
    _senhaUsuario = json['senhaUsuario'];
    _statusUsuario = json['statusUsuario'];
    _tokenUsuario = json['tokenUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this._idUsuario;
    data['nomeUsuario'] = this._nomeUsuario;
    data['loginUsuario'] = this._loginUsuario;
    data['emailUsuario'] = this._emailUsuario;
    data['senhaUsuario'] = this._senhaUsuario;
    data['statusUsuario'] = this._statusUsuario;
    data['tokenUsuario'] = this._tokenUsuario;
    return data;
  }
}
