import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart';
import 'package:psico_sis/model/Usuario.dart';

class UsuarioWS {

  static UsuarioWS? _instance;

  UsuarioWS._internal() {}

  static UsuarioWS getInstance() {
    if (_instance == null) {
      _instance = UsuarioWS._internal();
    }
    return _instance!;
  }

  // var header = {"content-type":"application/json; charset=utl-8"};
  // print("${url} ${param}");
  // String url = "localhost:8080/usuario/getbyloginsenha/";
  // Response response = await HttpUtils.getForFullResponse(url);
  // Response response = await HttpUtils.postForFullResponse(url, headers: header, queryParameters: param)
  // String url = "http://localhost:8080/usuario/getAtivos/";
  // Response response = await HttpUtils.getForFullResponse(url);
  // Response response = await HttpUtils.postForFullResponse(url, headers: header, body: param1);

  Future<List<Usuario>> getAll() async {

    var param = {'token': 'Mon May 16 20:54:35 BRT 2022'};
    var header = {"Content-type": "application/json"};
    String url = "http://localhost:8080/usuario/listarTodos/";
    Response response = await HttpUtils.getForFullResponse(url, headers: header, queryParameters: param);
    if (response.statusCode == 200) {
      var dados = jsonDecode(response.body);
      List<Usuario> ls = (dados as List).map((e) => Usuario.fromJson(e)).toList();
      return ls;
    }
    return [];
  }


  Future<List<Usuario>> getAtivos() async {

    String param = '{"login_usuario": "jean", "senha_usuario": "123123"}';
    var header = {"Content-type": "application/json"};
    String url = "http://localhost:8080/usuario/getbyloginsenha/";

    Response response = await HttpUtils.postForFullResponse(url, headers: header, body: param);
    print("response = "+response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var dados = jsonDecode(response.body);
      print("entrou");
      // List<Usuario> ls = (dados as List).map((e) => Usuario.fromJson(e)).toList();
      return [];
    }
    return [];
  }
}