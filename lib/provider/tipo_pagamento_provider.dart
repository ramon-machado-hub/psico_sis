import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/Especialidade.dart';

class TipoPagamentoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('tipos_pagamento')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return int.parse(_myDocCount.last.id);
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getTipoPagamentoById(String id) {
    return db.collection('tipos_pagamento').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListTiposPagamentos() {
    return db.collection('tipos_pagamento').snapshots();
  }

  Future<void> put(Especialidade especialidade) async {
    if (especialidade.idEspecialidade == null) {
      int id = await getCount();
      db.collection('tipos_pagamento').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'descricao': especialidade.descricao,
      });
    }else {
      db.collection('tipos_pagamento').doc(especialidade.idEspecialidade.toString()).set({
        'descricao': especialidade.descricao,
      });
    }
  }
}