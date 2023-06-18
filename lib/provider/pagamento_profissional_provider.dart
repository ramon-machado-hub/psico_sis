import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/categoria_despesa.dart';
import 'package:psico_sis/model/despesa.dart';
import 'package:psico_sis/model/pagamento_profissional.dart';

import '../model/Profissional.dart';
import '../model/comissao.dart';
import '../model/servico.dart';

class PagamentoProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<PagamentoProfissional> getPagamentoProfissionalById(String id) async{

    final documentSnapshhot = await db.collection('pagamento_profissional').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
        documentSnapshhot.data() as Map<String, dynamic>;
        final pagamento = PagamentoProfissional.fromJson(doc);
        pagamento.id1= documentSnapshhot.id;
        return pagamento;
    } else {
      return PagamentoProfissional(
          valor: '', idProfissional: '',
          hora: '', data: '');
    }
  }

  Future<List<PagamentoProfissional>> getListPagamentosProfissionais(String data)async{
    List<String> list = [];
    final querySnapshot = await db.collection('pagamento_profissional')
        .where("data", isEqualTo: data)
        .get();
    final allData = querySnapshot.docs.map((e) {
      final pagamento = PagamentoProfissional.fromJson(e.data());
      pagamento.id1 = e.id;
      return pagamento;
    }).toList();
    print(allData.length);
    print("listPagamentos");
    return allData;
  }

  Future<List<PagamentoProfissional>> getListPagamentosByIdProfissional(String id)async{
    List<String> list = [];
    final querySnapshot = await db.collection('pagamento_profissional')
        .where("id_profissional", isEqualTo: id)
        .get();
    final allData = querySnapshot.docs.map((e) {
      final pagamento = PagamentoProfissional.fromJson(e.data());
      pagamento.id1 = e.id;
      return pagamento;
    }).toList();
    print(allData.length);
    print("listPagamentos");
    return allData;
  }

  Future<List<Comissao>> getListPagamentos() async{
    final querySnapshot = await db.collection('pagamento_profissional').get();
    final allData = querySnapshot.docs.map((e) {
      final comissao = Comissao.fromJson(e.data());
      comissao.id1 = e.id;
      return comissao;
    }).toList();
    return allData;
  }

  Future<String> put(PagamentoProfissional pagamento) async {
      print("pagamento profissional provider");
      var itemRef = db.collection("pagamento_profissional");
      var doc = itemRef.doc().id;
      db.collection('pagamento_profissional').doc(doc).set({
        'id_profissional': pagamento.idProfissional,
        'data': pagamento.data,
        'hora': pagamento.hora,
        'valor': pagamento.valor,
      }).then((value) => print('Salvou Pagamento Profissional ${doc}'));
      return doc;
  }
}