import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/servico.dart';

class FormaPagamentoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('formas_pagamento')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    if (_myDocCount.length==0){
      return 0;
    }
    return int.parse(_myDocCount.last.id);
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getFormaPagamentoById(String id) {
    return db.collection('formas_pagamento').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListFormasPagamento() {
    return db.collection('formas_pagamento').snapshots();
  }

  Future<void> put(Servico servico) async {
    if (servico.id == null) {
      int id = await getCount();
      db.collection('formas_pagamento').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'descricao': servico.descricao,
      });
    }else {
      db.collection('formas_pagamento').doc(servico.id.toString()).set({
        'descricao': servico.descricao,
      });
    }
  }
}