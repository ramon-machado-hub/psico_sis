import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/servico.dart';

class ServicoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  late List<Servico> listServ = [];



  Future<Servico> getServicoById(String id) async{
    if(listServ.length>0){
       return listServ.firstWhere((element) => element.id1.compareTo(id)==0);
    }

    final documentSnapshhot = await db.collection('servicos').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
        documentSnapshhot.data() as Map<String, dynamic>;
        final serv = Servico.fromJson(doc);
        serv.id1= documentSnapshhot.id;
        return serv;
    } else {
      return Servico(descricao: "não existe", qtd_sessoes:0, qtd_pacientes: 0);
    }
  }

  Future<Servico> getServicoByDesc(String desc) async{
    if(listServ.length>0){
      return listServ.firstWhere((element) => element.descricao!.compareTo(desc)==0);
    }
    final querySnapshot = await db.collection('servicos')
        .where("descricao", isEqualTo: desc)
        .get();
    final allData = querySnapshot.docs.map((e) {
      final serv = Servico.fromJson(e.data());
      serv.id1 = e.id;
      return serv;
    }).toList();
    return allData.first;
  }

  Future<List<Servico>> getListServicos() async{
    if (listServ.length==0){
      final querySnapshot = await db.collection('servicos').get();
      final allData = querySnapshot.docs.map((e) {
        final json = e.data();
        final serv = Servico.fromJson(e.data());
        serv.id1 = e.id;
        listServ.add(serv);
        return serv;
      }).toList();
      return allData;
    }  else {
      return listServ;
    }

  }

  // Future<List<Servico>> getListServicos1() async {
  //   List<Servico> _list = [];
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await db.collection('servicos').get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //
  //   allData.forEach((element) {
  //     // print("aqui");
  //     Servico servico = Servico.fromJson1(element);
  //     _list.add(servico);
  //   });
  //   print("_list.l serv ${_list.length}");
  //   return _list;
  // }


  // Future<void> put2(Servico servico) async {
  //   // if (servico.id == null) {
  //   //   int id = await getCount();
  //     db.collection('back_servicos').doc(servico.id.toString()).set({
  //       'id': servico.id,
  //       'descricao': servico.descricao,
  //       'qtd_pacientes': servico.qtd_pacientes,
  //       'qtd_sessoes': servico.qtd_sessoes,
  //     }).then((value) => print('cadastrou novo back serviço'));
  //   // }
  //
  // }
  //
  // Future<String> put3(Servico servico) async {
  //
  //   if (servico.id == null) {
  //     print("serv provider");
  //     var itemRef = db.collection("servicos");
  //     var doc = itemRef.doc().id;
  //     // int id = await getCount();
  //     db.collection('servicos').doc(doc).set({
  //       'descricao': servico.descricao,
  //       'qtd_pacientes': servico.qtd_pacientes,
  //       'qtd_sessoes': servico.qtd_sessoes,
  //     }).then((value) => print('salvou uhru ${doc}'));
  //     return doc;
  //   }else {
  //     db.collection('servicos').doc(servico.id).set({
  //       'id': servico.id,
  //       'descricao': servico.descricao,
  //       'qtd_pacientes': servico.qtd_pacientes,
  //       'qtd_sessoes': servico.qtd_sessoes,
  //     }).then((value) => print("alterou serviços ${servico.id}"));
  //   }
  //   return "não salvou";
  // }

  Future<String> put(Servico servico) async {
    // if (servico.id == null) {
      var itemRef = db.collection("servicos");
      var doc = itemRef.doc().id;
      db.collection('servicos').doc(doc).set({
        'descricao': servico.descricao,
        'qtd_pacientes': servico.qtd_pacientes,
        'qtd_sessoes': servico.qtd_sessoes,
      }).then((value) => print("inseriu serviço = $doc"));
      servico.id1 = doc;
      listServ.add(servico);
      return doc;

    // }
    // else {
    //   db.collection('servicos').doc(servico.id).set({
    //     'descricao': servico.descricao,
    //     'qtd_pacientes': servico.qtd_pacientes,
    //     'qtd_sessoes': servico.qtd_sessoes,
    //   });
    //   return servico.id1!;
    // }

  }

  void remove(String id) async {
    db.collection("servicos").doc(id).delete();
    notifyListeners();
  }
}