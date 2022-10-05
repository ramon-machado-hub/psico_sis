import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/log_sistema.dart';

class LogProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('log')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    if (_myDocCount.isEmpty){
      return 0;
    }
    return _myDocCount.length;
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLogById(String id) {
    return db.collection('log').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListLogs() {
    return db.collection('log').snapshots();
  }

  Future<void> put(LogSistema log) async {
    if (log.id == null) {
      int id = await getCount();
      db.collection('log').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'uid_usuario': log.uid_usuario,
        'descricao': log.descricao,
        'id_transacao': log.id_transacao,
        'data': log.data,
      });
    }else {
      // log não pode ser alterado.......

      // db.collection('servicos').doc(servico.id.toString()).set({
      //   'descricao': servico.descricao,
      //   'qtd_pacientes': servico.qtd_pacientes,
      //   'qtd_sessoes': servico.qtd_sessoes,
      // });
    }
  }
}