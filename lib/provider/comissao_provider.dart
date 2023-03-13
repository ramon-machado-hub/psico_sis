import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/categoria_despesa.dart';
import 'package:psico_sis/model/despesa.dart';

import '../model/Profissional.dart';
import '../model/comissao.dart';
import '../model/servico.dart';

class ComissaoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<Comissao> getComissaoById(String id) async{

    final documentSnapshhot = await db.collection('comissao').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
        documentSnapshhot.data() as Map<String, dynamic>;
        final comissao = Comissao.fromJson(doc);
        comissao.id1= documentSnapshhot.id;
        return comissao;
    } else {
      return Comissao(
          valor: '', idProfissional: '', dataGerada: '',
          dataPagamento: '', idTransacao: '',situacao: '', idPagamento: '');
    }
  }

  Future<List<String>> getListIdProfissionaisAReceber() async{
    List<String> list = [];
    final querySnapshot = await db.collection('comissao')
        .where("situacao", isEqualTo: "PENDENTE")
        .get();
    final allData = querySnapshot.docs.map((e) {
      final comissao = Comissao.fromJson(e.data());
      comissao.id1 = e.id;
      return comissao;
    }).toList();
    allData.forEach((element) {
      if (list.contains(element.idProfissional)==false){
        list.add(element.idProfissional);
      }
    });
    return list;
  }

  Future<List<Comissao>> getListComissaoPendenteByProfissional(String idProfissional)async{
    final querySnapshot = await db.collection('comissao')
        .where("id_profissional", isEqualTo: idProfissional)
        .where("situacao", isEqualTo: "PENDENTE")
        .get();
    print("getListComissaoPendenteByProfissional length  ${querySnapshot.docs.length}");
    final allData = await querySnapshot.docs.map((e) {
      final comissao = Comissao.fromJson(e.data());
      comissao.id1 = e.id;
      return comissao;
    }).toList();
    return allData;
  }

  Future<String> getValorComissaoByProfissional(String idProfissional) async {
    double valor =0.00;
    print("idProfissional");
    print(idProfissional);
    final querySnapshot = await db.collection('comissao')
        .where("id_profissional", isEqualTo: idProfissional)
        .where("situacao", isEqualTo: "PENDENTE")
        .get();
    print("length ${querySnapshot.docs.length}");
    final allData = await querySnapshot.docs.map((e) {
      final comissao = Comissao.fromJson(e.data());
      comissao.id1 = e.id;
      // valor+=double.parse(comissao.valor.replaceAll(',', '.'));
      // _comissaoClinica = (double.parse(valorSessao)*0.3).toStringAsFixed(2).replaceAll('.', ',');
      print(comissao.valor);
      print("comissao.valor");
      return comissao;
    }).toList();
    allData.forEach((element) {
      valor+=double.parse(element.valor.replaceAll(',', '.'));
    });
    print("valor  aaa");
    print(valor);
    return valor.toStringAsFixed(2).replaceAll('.', ',');
  }

  Future<List<Comissao>> getComissaoByProfissional(String idProfissional) async {
    final querySnapshot = await db.collection('comissao')
        .where("id_profissional", isEqualTo: idProfissional)
        .where("situacao", isEqualTo: "PENDENTE")
        .get();
    final allData = querySnapshot.docs.map((e) {
      final comissao = Comissao.fromJson(e.data());
      comissao.id1 = e.id;
      return comissao;
    }).toList();

    return allData;
  }

  Future<List<Comissao>> getListComissao() async{
    final querySnapshot = await db.collection('comissao').get();
    final allData = querySnapshot.docs.map((e) {
      final comissao = Comissao.fromJson(e.data());
      comissao.id1 = e.id;
      return comissao;
    }).toList();
    return allData;
  }


  Future<String> put(Comissao comissao) async {
      print("comissao provider");
      var itemRef = db.collection("comissao");
      var doc = itemRef.doc().id;
      db.collection('comissao').doc(doc).set({
        'id_profissional': comissao.idProfissional,
        'id_transacao': comissao.idTransacao,
        'id_pagamento': "",
        'data_gerada': comissao.dataGerada,
        'data_pagamento': comissao.dataPagamento,
        'valor': comissao.valor,
        'situacao': comissao.situacao,
      }).then((value) => print('Salvou comissao ${doc}'));
      return doc;
  }

  Future<void> PagarComissoes(String id_profissional, String idPagamento)async{
    List<Comissao> list = [];
    await getComissaoByProfissional(id_profissional).then((value) {
        list = value;
        list.forEach((element) {
           update(element.id1, idPagamento);
        });
    });
  }

  Future<void> update(String id, String idPagamento) async {
    var collection = db.collection('comissao');
    collection.doc(id).update({
      'situacao':'PAGO',
      'id_pagamento':idPagamento,
      'data_pagamento': UtilData.obterDataDDMMAAAA(DateTime.now())
    }).then((value) => print('Update comissao $id'))
    .catchError((error)=>print("update failed: $error"));
  }

  void remove(String id) async {
    db.collection("comissao").doc(id).delete();
    notifyListeners();
  }
}