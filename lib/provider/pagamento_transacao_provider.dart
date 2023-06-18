import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/pagamento_transacao.dart';
import '../model/transacao_caixa.dart';

class PagamentoTransacaoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;


  Stream<DocumentSnapshot<Map<String, dynamic>>> getPagamentoTransacaoById(String id) {
    return db.collection('pagamento_transacao').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListPagamentoTransacoes() {
    return db.collection('pagamento_transacao').snapshots();
  }
  
  Future<PagamentoTransacao?> getPagamentoTransacaoById2(String id)async{
    final documentSnapshhot = await db.collection('pagamento_transacao').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
      documentSnapshhot.data() as Map<String, dynamic>;
      final transacao = PagamentoTransacao.fromJson(doc);
      transacao.id1= documentSnapshhot.id;
      return transacao;
    } else {
      return null;
    }
  }

  Future<List<PagamentoTransacao>> getPagamentoTransacoes()async{
    final querySnapshot = await db.collection('pagamento_transacao').get();
    final allData = querySnapshot.docs.map((e) {
      final transacoes = PagamentoTransacao.fromJson(e.data());
      transacoes.id1 = e.id;
      return transacoes;
    }).toList();
    return allData;
  }

  Future<List<PagamentoTransacao>> getPagamentoTransacoesDoDia(DateTime dia)async{
    String data = UtilData.obterDataDDMMAAAA(dia);
    print("data");
    print(data);
    final querySnapshot = await db.collection('pagamento_transacao')
        .where("data", isEqualTo: data)
        // .where("tipo_transacao", isEqualTo: "PAGAMENTO EFETUADO")
        .get();
    final allData = querySnapshot.docs.map((e) {
      final transacoes = PagamentoTransacao.fromJson(e.data());
      transacoes.id1 = e.id;
      return transacoes;
    }).toList();
    return allData;
  }

  Future<String> putTransacao(PagamentoTransacao pagamentoTransacao) async {
    var itemRef = db.collection("pagamento_transacao");
    var doc = itemRef.doc().id;
     await db.collection('pagamento_transacao').doc(doc).set({
        'data': pagamentoTransacao.dataPagamento,
        'hora': pagamentoTransacao.horaPagamento,
       // UtilData.obterHoraHHMM(DateTime.now()),
        'valor': pagamentoTransacao.valorPagamento,
        'valor_transacao': pagamentoTransacao.valorTotalPagamento,
        'tipo_pagamento': pagamentoTransacao.tipoPagamento,
        'id_transacao': pagamentoTransacao.idTransacao,
        // 'hora_transacao': UtilData.obterHoraHHMM(DateTime.now()),
        'descricao': pagamentoTransacao.descServico,
     }).then((value) => print("inseriu pagamento_transacao id = $doc"));
     return doc;
  }

}