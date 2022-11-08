import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/sessao.dart';

class SessaoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  late List<Sessao> listSessao = [];

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('sessoes')
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
    return db.collection('sessoes').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListServicos() {
    return db.collection('sessoes').snapshots();
  }

  Future<List<Sessao>> getListServicosProfissional() async {
    List<Sessao> _list = [];
    // Get docs from collection reference
    if(listSessao.length==0){
      QuerySnapshot querySnapshot = await db.collection('sessoes').get();
      notifyListeners();
      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      allData.forEach((element) {
        Sessao sessao = Sessao.fromJson1(element);
        _list.add(sessao);
      });
      listSessao = _list;
    } else {
      _list = listSessao;
    }

    print("_sessao provider ${_list.length}");
    // listServ = _list;
    return _list;
  }


  Future<void> put(Sessao sessao) async {
    if (sessao.idSessao == null) {
      int id = await getCount();
      db.collection('sessoes').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'id_profissional': sessao.idProfissional.toString(),
        'id_paciente': sessao.idPaciente.toString(),
        'valor_sessao': sessao.valorSessao,
        'status_sessao': sessao.statusSessao,
        'situacao_sessao': sessao.situacaoSessao,
        'sala_sessao': sessao.salaSessao,
        'data_sessao': sessao.dataSessao,
        'desc_sessao': sessao.descSessao,
        'tipo_sessao': sessao.tipoSessao,
        'horario_sessao': sessao.horarioSessao,
      });
    }else {
      db.collection('sessoes').doc(sessao.idSessao.toString()).set({
        'id': sessao.idSessao,
        'id_profissional': sessao.idProfissional.toString(),
        'id_servico': sessao.idPaciente.toString(),
        'valor_sessao': sessao.valorSessao,
        'status_sessao': sessao.statusSessao,
        'situacao_sessao': sessao.situacaoSessao,
        'sala_sessao': sessao.salaSessao,
        'data_sessao': sessao.dataSessao,
        'desc_sessao': sessao.descSessao,
        'tipo_sessao': sessao.tipoSessao,
        'horario_sessao': sessao.horarioSessao,
      });
    }

  }

  void remove(String id) async {
    // db.collection("sessao").doc(id).delete();
    // notifyListeners();
  }
}