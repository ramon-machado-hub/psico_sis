import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/tipo_pagamento.dart';

class TipoPagamentoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<TipoPagamento> tiposPagamento = [];


  Stream<DocumentSnapshot<Map<String, dynamic>>> getTipoPagamentoById(String id) {
    return db.collection('tipos_pagamento').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListTiposPagamentos() {
    return db.collection('tipos_pagamento').snapshots();
  }

  Future<List<TipoPagamento>> getTiposPagamentos()async{
    // if (tiposPagamento.length==0){
      final querySnapshot = await db.collection('tipos_pagamento').get();
      final allData = querySnapshot.docs.map((e) {
        final tipoPagamento = TipoPagamento.fromJson(e.data());
        tipoPagamento.id1 = e.id;
        return tipoPagamento;
      }).toList();
      tiposPagamento = allData;
      return allData;
    // }  else {
    //   return tiposPagamento;
    // }

  }

  Future<void> put(TipoPagamento tipoPagamento) async {
    var itemRef = db.collection("tipos_pagamento");
    var doc = itemRef.doc().id;
     db.collection('tipos_pagamento').doc(doc).set({
        'descricao': tipoPagamento.descricao,
     }).then((value) => print("inseriu tipo_pagamento id = $doc"));
     tipoPagamento.id1 = doc;
     tiposPagamento.add(tipoPagamento);
  }
}