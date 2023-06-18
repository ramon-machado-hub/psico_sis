import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/servicos_profissional.dart';

import '../model/servico.dart';

class ServicoProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  late List<ServicosProfissional> listServProf = [];

  

 

  Stream<DocumentSnapshot<Map<String, dynamic>>> getServicoById(String id) {
    return db.collection('servicos_profissional').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListServicos() {
    return db.collection('servicos_profissional').snapshots();
  }

  Future<List<ServicosProfissional>> getListServicosProfissional() async {

    if (listServProf.length==0){
      // final querySnapshot = await db.collection('servicos_profissional').get();
      final querySnapshot = await db.collection('servicos_profissional')
          .snapshots().listen((event) {   
            print("ServProf");
            listServProf.clear();
            for (var doc in event.docs){
              final data = doc.data();
              final serv = ServicosProfissional.fromJson(data);
              serv.id1 = doc.id;
              listServProf.add(serv);
            }

      });

      // final allData = querySnapshot..map((doc) {
      //   final serv = ServicosProfissional.fromJson(doc.data());
      //   serv.id1 = doc.id;
      //   return serv;
      // }).toList();
      print("serv Profissional return from snapshot = ${listServProf.length}");
      return listServProf;
    } else{
      print("Serv Profissional retornou list");
      return listServProf;
    }
    
  }

  Future<ServicosProfissional> getServByServicoProfissional(String idProf, String idServ)async{
     print(idProf);
     print(idServ);
     // print(idProf);
    final querySnapshot = await db.collection('servicos_profissional')
        .where("id_servico", isEqualTo: idServ)
        .where("id_profissional", isEqualTo: idProf)
        .get();
    final allData = querySnapshot.docs.map((e) {
      final serv = ServicosProfissional.fromJson(e.data());
      serv.id1 = e.id;
      return serv;
    }).toList();
    return allData.first;
  }

  Future<List<ServicosProfissional>> getListServicosByIdProfissional(String id) async {
    List<ServicosProfissional> result = [];
    if (listServProf.length>0){
      listServProf.forEach((element) {
         if (element.idProfissional!.compareTo(id)==0){
            result.add(element);
         }
      });
    }
    if (result.length==0){
      final querySnapshot = await db.collection('servicos_profissional')
          .where("id_profissional", isEqualTo: id).get();
      final allData = querySnapshot.docs.map((doc) {
        final serv = ServicosProfissional.fromJson(doc.data());
        serv.id1 = doc.id;
        return serv;
      }).toList();

      print("serv provider getListServicosProfissional = ${allData.length}");
      return allData;
    } else {
      return result;
    }

  }

  Future<void> updateValorServicoProfissional(String id, String valor) async {
    db.collection('servicos_profissional').doc(id)
        .update({
      'valor': valor,
    }).then((value) {
      print("ALTEROU VALOR SERVIÇO $id valor $valor");
      notifyListeners();
    });
  }

  Future<void> updateIdProf(ServicosProfissional servico) async {
    db.collection('servicos_profissional').doc(servico.id.toString())
        .update({
      'id_profissional': servico.idProfissional.toString(),
    });
  }

  Future<void> put2(ServicosProfissional servico) async {
    var itemRef = db.collection("servicos_profissional");
    var doc = itemRef.doc().id;
      db.collection('servicos_profissional').doc(doc).set({
        // 'id': servico.id.toString(),
        'id_profissional': servico.idProfissional.toString(),
        'id_servico': servico.idServico.toString(),
        'valor': servico.valor,
      }).then((value) => print("inseriu back serv profissional ${doc}"));
  }

  Future<void> put(ServicosProfissional servico) async {
    if (servico.id == null) {
      // int id = await getCount();
      var itemRef = db.collection("servicos_profissional");
      var doc = itemRef.doc().id;
      print("id =");
      print(servico.idServico);
      db.collection('servicos_profissional').doc(doc).set({
        // 'id': doc,
        'id_profissional': servico.idProfissional.toString(),
        'id_servico': servico.idServico.toString(),
        'valor': servico.valor,
      }).then((value) => print("inseriu servProf = $doc"));
    }else {
      db.collection('servicos_profissional').doc(servico.id.toString()).set({
        // 'id': servico.id.toString(),
        'id_profissional': servico.idProfissional.toString(),
        'id_servico': servico.idServico.toString(),
        'valor': servico.valor,
      }).then((value) => print("alterou serv profissional"));
    }

  }

  void remove(String id) async {
    db.collection("servicos_profissional").doc(id).delete().then((value) => print("removeu servico profissional $id"));
    notifyListeners();
  }
}