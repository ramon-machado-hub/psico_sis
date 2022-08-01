import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:psico_sis/atividade2/model/sistema_model.dart';
import 'package:psico_sis/atividade2/model/transacoes_model.dart';

class TransacaoWs {
  static TransacaoWs? _instance;
  TransacaoWs._internal() {}

  static TransacaoWs getInstance() {
    if (_instance == null) {
      _instance = TransacaoWs._internal();
    }
    return _instance!;
  }

  Future<List<TransacaoModel>> getTransacoes(String token) async {
    Response response = await http.post(
        Uri.parse('http://localhost:8080/transacao/gettransacoes'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({"token": token}));

    if (response.statusCode ==200){
      print("request gettransacoes validou");
      // print(response.body);
      var dados = jsonDecode(response.body);
      // print("dados = "+dados);
      List<TransacaoModel> ls = (dados as List).map((e) => TransacaoModel.fromJson(e)).toList();
      return ls;
    } else {
      print("request gettransacoes não validou");
      return [];
    }
  }

  Future<bool> saveTransacao(TransacaoModel transacao, String token) async {

    Response response = await http.post(
        Uri.parse('http://localhost:8080/transacao/createtransacao'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({
          "nome_transacao":transacao.nomeTransacao,
          "status_transacao":"A",
          "url_transacao":transacao.urlTransacao,
          "id_servico": 2,
          "token": token}));

    if (response.statusCode ==200){
      print("request createsistema validou");
      var dados = jsonDecode(response.body);
      return true;

    } else {
      print("request createsistema não validou");
      return false;
    }
  }

}