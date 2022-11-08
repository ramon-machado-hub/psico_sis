import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/servicos_profissional.dart';

import '../model/servico.dart';

class ServicoProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  late List<ServicosProfissional> listServProf = [];

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('servicos_profissional')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    if (_myDocCount.length==0){
      return 0;
    }
    return _myDocCount.length;
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getServicoById(String id) {
    return db.collection('servicos_profissional').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListServicos() {
    return db.collection('servicos_profissional').snapshots();
  }

  Future<List<ServicosProfissional>> getListServicosProfissional() async {
    List<ServicosProfissional> _list = [];
    // Get docs from collection reference
    if(listServProf.length==0){
      QuerySnapshot querySnapshot = await db.collection('servicos_profissional').get();
      notifyListeners();
      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      allData.forEach((element) {
        print(element);
        ServicosProfissional servico = ServicosProfissional.fromJson1(element);
        // servico.
        _list.add(servico);
        print("add");
      });
    } else {
      _list = listServProf;
    }

    print("_list.hhl ${_list.length}");
    // listServ = _list;
    return _list;
  }

  Future<void> put2(ServicosProfissional servico) async {
      db.collection('back_servicos_profissional').doc(servico.id.toString()).set({
        'id': servico.id.toString(),
        'id_profissional': servico.idProfissional.toString(),
        'id_servico': servico.idServico.toString(),
        'valor': servico.valor,
      }).then((value) => print("inseriu back serv profissional ${servico.id}"));
  }

  Future<void> put(ServicosProfissional servico) async {
    if (servico.id == null) {
      int id = await getCount();
      db.collection('servicos_profissional').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'id_profissional': servico.idProfissional.toString(),
        'id_servico': servico.idServico.toString(),
        'valor': servico.valor,
      });
    }else {
      db.collection('servicos_profissional').doc(servico.id.toString()).set({
        'id': servico.id.toString(),
        'id_profissional': servico.idProfissional.toString(),
        'id_servico': servico.idServico.toString(),
        'valor': servico.valor,
      }).then((value) => print("alterou serv profissional"));
    }

  }

  void remove(String id) async {
    db.collection("servicos").doc(id).delete();
    notifyListeners();
  }
}