import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/transacao_caixa.dart';

class TransacaoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;


  Stream<DocumentSnapshot<Map<String, dynamic>>> getTransacaoById(String id) {
    return db.collection('transacoes').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListTransacoes() {
    return db.collection('transacoes').snapshots();
  }
  
  Future<TransacaoCaixa?> getTransacaoById2(String id)async{
    final documentSnapshhot = await db.collection('transacoes').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
      documentSnapshhot.data() as Map<String, dynamic>;
      final transacao = TransacaoCaixa.fromJson(doc);
      transacao.id1= documentSnapshhot.id;
      return transacao;
    } else {
      return null;
    }
  }

  Future<List<TransacaoCaixa>> getTransacoes()async{
    final querySnapshot = await db.collection('transacoes').get();
    final allData = querySnapshot.docs.map((e) {
      final transacoes = TransacaoCaixa.fromJson(e.data());
      transacoes.id1 = e.id;
      return transacoes;
    }).toList();
    return allData;
  }

  Future<List<TransacaoCaixa>> getTransacoesDoDia(DateTime dia)async{
    String data = UtilData.obterDataDDMMAAAA(dia);
    print("data");
    print(data);
    final querySnapshot = await db.collection('transacoes')
        .where("data", isEqualTo: data)
        .where("tipo_transacao", isEqualTo: "PAGAMENTO EFETUADO")
        .get();
    final allData = querySnapshot.docs.map((e) {
      final transacoes = TransacaoCaixa.fromJson(e.data());
      transacoes.id1 = e.id;
      return transacoes;
    }).toList();
    return allData;
  }

  Future<String> put(TransacaoCaixa transacaoCaixa) async {
    var itemRef = db.collection("transacoes");
    var doc = itemRef.doc().id;
     await db.collection('transacoes').doc(doc).set({
        'data': transacaoCaixa.dataTransacao,
        'valor': transacaoCaixa.valorTransacao,
        'hora_transacao': UtilData.obterHoraHHMM(DateTime.now()),
        'descricao': transacaoCaixa.descricaoTransacao,
        'tipo_pagamento': transacaoCaixa.tpPagamento,
        'tipo_transacao': transacaoCaixa.tpTransacao,
        'id_paciente': transacaoCaixa.idPaciente,
        'id_profissional': transacaoCaixa.idProfissional,
        'desconto_profissional': transacaoCaixa.descontoProfissional,
        'desconto_clinica': transacaoCaixa.descontoClinica,
     }).then((value) => print("inseriu transacao id = $doc"));
     return doc;
  }

  Future<String> putBack(TransacaoCaixa transacaoCaixa) async {
    // var itemRef = db.collection("back_transacoes");
    // var doc = itemRef.doc().id;
    await db.collection('back_transacoes').doc(transacaoCaixa.id1).set({
      'data': transacaoCaixa.dataTransacao,
      'valor': transacaoCaixa.valorTransacao,
      'hora_transacao': UtilData.obterHoraHHMM(DateTime.now()),
      'descricao': transacaoCaixa.descricaoTransacao,
      'tipo_pagamento': transacaoCaixa.tpPagamento,
      'tipo_transacao': transacaoCaixa.tpTransacao,
      'id_paciente': transacaoCaixa.idPaciente,
      'id_profissional': transacaoCaixa.idProfissional,
      'desconto_profissional': transacaoCaixa.descontoProfissional,
      'desconto_clinica': transacaoCaixa.descontoClinica,
    }).then((value) => print("inseriu transacao id = ${transacaoCaixa.id1}"));
    return transacaoCaixa.id1;
  }

  Future<void> updateBack(String id,) async {
    var collection = db.collection('transacoes');
    collection.doc(id).update({
      'desconto_profissional': "0,00",
      'desconto_clinica': "0,00",
    }).then((value) => print('Update transacoes $id'))
        .catchError((error)=>print("update failed: $error"));
  }
}