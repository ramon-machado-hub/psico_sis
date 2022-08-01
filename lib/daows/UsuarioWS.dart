import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
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

  Future<List<Usuario>> getAtivos(String token) async {
    final response = await HttpUtils.getForFullResponse(
      "http://localhost:8080/usuario/getAtivos/",
      queryParameters: {
        'token': token
      },
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print("${response.statusCode} code getAtivos");
    if (response.statusCode == 200) {
      var dados = jsonDecode(response.body);
      List<Usuario> ls = (dados as List).map((e) => Usuario.fromJson(e)).toList();
      return ls;
    } else {
      print("miou");
    }

    return [];



  }

  Future<String>LoginPage(String login, String password) async{
    String token = "";
    print("$login - $password");
    // String param = '{"login": "$login", "senha": "$password"}';
    var header = {"Content-type": "application/json"};
    Response response = await http.post(
        Uri.parse('http://localhost:8080/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"loginUsuario": login, "senhaUsuario": password}));

    if (response.statusCode == 200) {
      print("Login validou");
      var dados = response.body;
      token = dados.toString();
    } else {
      print("não validou");
      print(response.statusCode);
    }
    print(token);
    return token;
  }

  Future<Usuario>GetByToken(String token) async{
    print("TOKEN $token");
    Usuario usu= new Usuario(
      emailUsuario: "tttttt",

    );
    // String token = "";
    // print("$token - token");
    // String param = '{"login": "$login", "senha": "$password"}';
    // var header = {"Content-type": "application/json"};
    Response response = await http.post(
        Uri.parse('http://localhost:8080/usuario/postGetUser'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({"token": token}));

    if (response.statusCode == 200) {
      print("Token valido");
      return usu = Usuario.fromJson(jsonDecode(response.body));
    } else {

      print("não validou");
      print("token $token");
      print(response.statusCode);
      return usu;
    }

  }

  Future<List<Usuario>> getAll(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/usuario/listarTodos/'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
        var dados = jsonDecode(response.body);
        List<Usuario> ls = (dados as List).map((e) => Usuario.fromJson(e)).toList();
        return ls;
      }
    return [];
  }

  Future<Usuario> getUserByToken(String token) async {
    print("getUserByToken ====| $token");
    var params = {
      "token": token,
    };

        Usuario usu = new Usuario();
    Uri uri = Uri.http('localhost:8080', '/usuario/getUserByToken',{"token": token});
    print("${uri} = uri ");

    final response = await http.get( uri,
        headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token'}
    );

    if (response.statusCode == 200) {
          var dados = jsonDecode(response.body);
          usu = Usuario.fromJson(dados);
          return usu;
    } else {
      print("deu erro no getUserByToken ${response.statusCode}");
    }
    return usu;
  }

}