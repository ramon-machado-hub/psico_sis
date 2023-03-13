import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/sessao.dart';

class SessaoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<Sessao> sessoes = [];

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSessaoById(String id) {
    return db.collection('sessoes').doc(id).snapshots();
  }

  Future<String> getProximoHorarioDisponivel(String data, String hora, String sala)async{
    print(data);
    print(hora);
    print(sala);
    hora = (int.parse(hora.substring(0,2))+1).toString();
    int hora1=   int.parse(hora.substring(0,2));
    String horaS1 = "";
    if (hora1<10){
      horaS1 = "0$hora1:00";
    } else {
      horaS1 = "$hora1:00";

    }
      print(hora1);
      print("hora1");
    for (int i = hora1; i<19; i++){
      print(horaS1);
      print("horaS1");
      final querySnapshot = await db.collection('sessoes')
          .where('data_sessao', isEqualTo: data)
          .where('horario_sessao', isEqualTo: horaS1)
          .where('sala_sessao', isEqualTo: sala)
          .get();
      if (querySnapshot.docs.isEmpty){
        return horaS1;
      }
      if (hora1<11){
        horaS1 = "0$i:00";
      } else {
        horaS1 = "$i:00";
      }
      // horaS1=
      if (i==18){
        return "";
      }
    }
    return "";

  }




  Future<bool> getSessaoByDataSalaHora(String data, String hora, String sala)async{
    final querySnapshot = await db.collection('sessoes')
        .where('data_sessao', isEqualTo: data)
        .where('horario_sessao', isEqualTo: hora)
        .where('sala_sessao', isEqualTo: sala)
        .get();
    final allData = querySnapshot.docs.map((e) {
      final sessao = Sessao.fromJson(e.data());
      sessao.id1 = e.id;
      return sessao;
    }).toList();
      
    if (allData.length>=1) {
      return true;
    } else {
      return false;
    }
    // return allData;
  }

  Future<List<Sessao>> getListSessoesDoDia(String data)async{
    print(data);
    print("data");
    final querySnapshot = await db.collection('sessoes')
        .where('data_sessao', isEqualTo: data)
        .get();
    final allData = querySnapshot.docs.map((e) {
      final sessao = Sessao.fromJson(e.data());
      sessao.id1 = e.id;
      return sessao;
    }).toList();
    print("querySnapshot.docs.length");

    print(querySnapshot.docs.length);
    print(allData.length);
    print("allData.length");
    return allData;

  }



  Future<List<Sessao>> getSessoesByDiaSalaHora(String dia,String sala, String horario, String idProfissional)async{
    List<Sessao> result = [];
    String getDiaCorrente(DateTime data) {
      String dia = DateFormat('EEEE').format(data);
      switch (dia) {
        case 'Monday':
          {
            return "SEGUNDA";
          }
        case 'Tuesday':
          {
            return "TERÇA";
          }
        case 'Wednesday':
          {
            return "QUARTA";
          }
        case 'Thursday':
          {
            return "QUINTA";
          }
        case 'Friday':
          {
            return "SEXTA";
          }
        case 'Saturday':
          {
            return "SÁBADO";
          }
        case 'Sunday':
          {
            return "Domingo";
          }
      }
      return "";
    }
    print("id = $idProfissional");
    final querySnapshot = await db.collection('sessoes')
        .where('sala_sessao', isEqualTo: sala)
        .where('status_sessao', isEqualTo: 'AGENDADA')
        .where('horario_sessao', isEqualTo: horario)
        .where('id_profissional', isEqualTo: idProfissional)
        .get();

    final allData = querySnapshot.docs.map((e) {
      final sessao = Sessao.fromJson(e.data());
      sessao.id1 = e.id;

      // if(getDia(sessao.dataSessao!).compareTo(dia)==0){
      //   return sessao;
      // }
      // if (dia.compareTo(getDia(sessao.dataSessao!))==0){
      //
      // }
      return sessao;

    }).toList();
    result = allData;
    result.forEach((element) {
      print(element.dataSessao);
      print(element.horarioSessao);
      print(element.descSessao);
      String diaa = getDiaCorrente(DateTime(
        int.parse(element.dataSessao!.substring(7,10)),
        int.parse(element.dataSessao!.substring(4,5)),
        int.parse(element.dataSessao!.substring(1,2)),
      ));
      print (diaa+" sessao");
      print (dia+" remover");

    });
    List<int> ints = [];
    for (int i =0; i<allData.length;i++){
      print("------");

      print(allData[i].dataSessao!);
      print(allData[i].descSessao!);
      print(allData[i].horarioSessao!);
      // print(getDia(allData[i].dataSessao!));
      String diaa = getDiaCorrente(DateTime(
          int.parse(allData[i].dataSessao!.substring(7,10)),
          int.parse(allData[i].dataSessao!.substring(4,5)),
          int.parse(allData[i].dataSessao!.substring(1,2)),
      ));
      print(diaa);
      print(dia);
      print(dia.compareTo(diaa)==0);
      print(allData.length);
      if (dia.compareTo(diaa)!=0){
        // ints.add(i);
        print("removeu");
        print(allData[i].dataSessao);
        allData.remove(allData[i]);
        i=i-1;
        // result.removeAt(allData[i]);
      }
    }

    print("alldata ${allData.length}");
    print("alldata ${result.length}");
    return allData;
  }


  Future<List<Sessao>> getListSessoesDoDiaByProfissional(String data, String idProfissional)async{
    print("id = $idProfissional");
    print("data = $data");
    final querySnapshot = await db.collection('sessoes')
        .where('data_sessao', isEqualTo: data)
        .where('id_profissional', isEqualTo: idProfissional)
        .get();

    final allData = querySnapshot.docs.map((e) {
      final sessao = Sessao.fromJson(e.data());
      sessao.id1 = e.id;
      return sessao;
    }).toList();
    return allData;
  }


  Future<List<Sessao>> getSessoesByTransacaoPacienteProfissional(String idPaciente, String idProfissional)async {
    final querySnapshot = await db.collection('sessoes')
        .where('id_paciente', isEqualTo: idPaciente)
        .where('id_profissional', isEqualTo: idProfissional)
        // .where('id_transacao', isEqualTo: idTransacao)
        .where('status_sessao', isEqualTo: "AGENDADA")
        .get();
    final allData = querySnapshot.docs.map((e) {
      final sessao = Sessao.fromJson(e.data());
      sessao.id1 = e.id;
      return sessao;
    }).toList();
    return allData;
  }


  Future<List<Sessao>> getSessoesByTransacao(String idTransacao)async {
    final querySnapshot = await db.collection('sessoes')
        .where('id_transacao', isEqualTo: idTransacao)
        .where('status_sessao', isEqualTo: "AGENDADA")
        .get();
    final allData = querySnapshot.docs.map((e) {
      final sessao = Sessao.fromJson(e.data());
      sessao.id1 = e.id;
      return sessao;
    }).toList();
    return allData;
  }

  Future<List<Sessao>> getListSessoes() async {
      final querySnapshot = await db.collection('sessoes').get();
      final allData = querySnapshot.docs.map((e) {
        final sessao = Sessao.fromJson(e.data());
        sessao.id1 = e.id;
        return sessao;
      }).toList();
    return allData;
  }

  Future<bool> existeSessaoByData(String data, String idPaciente,String hora,) async {
    print(data);
    print(hora);
    print(idPaciente);
    final querySnapshot = await db.collection('sessoes')
        .where('data_sessao', isEqualTo: data)
        .where('horario_sessao', isEqualTo: hora)
        .where('id_paciente', isEqualTo: idPaciente)
        .get();
    if (querySnapshot.size>0) {
      return true;
    } else {
      return false;
    }
    // final allData = querySnapshot.docs.map((e) {
    //   final sessao = Sessao.fromJson(e.data());
    //   sessao.id1 = e.id;
    //   return sessao;
    // }).toList();
    // return allData;

  }

  Future<void> put(Sessao sessao) async {
    print("put sessao");
    print("id Transação");
    print("id Transação${sessao.idTransacao}");

    var itemRef = db.collection("sessoes");
    var doc = itemRef.doc().id;
      db.collection('sessoes').doc(doc).set({
        'id_transacao': sessao.idTransacao,
        'status_sessao': sessao.statusSessao,
        'sala_sessao': sessao.salaSessao,
        'data_sessao': sessao.dataSessao,
        'desc_sessao': sessao.descSessao,
        'tipo_sessao': sessao.tipoSessao,
        'horario_sessao': sessao.horarioSessao,
        'id_paciente': sessao.idPaciente,
        'id_profissional': sessao.idProfissional,
        'situacao': sessao.situacaoSessao,
      }).then((value) => print("inseriu sessao $doc"));
  }



  Future<void> update(String id) async {
    var collection = db.collection('sessoes');
    collection.doc(id).update({
      'status_sessao':'FINALIZADA',
    }).then((value) {
      print('Update sessoes $id');
      notifyListeners();
    }).catchError((error)=>print("update failed: $error"));
  }

  Future<void> updateDataEHora(String id, String data, String hora) async {
    var collection = db.collection('sessoes');
    collection.doc(id).update({
      'data_sessao': data,
      'horario_sessao': hora,
    }).then((value) => print('Update sessoes $id'))
        .catchError((error)=>print("update failed: $error"));
  }


  void remove(String id) async {
    // db.collection("sessao").doc(id).delete();
    // notifyListeners();
  }
}