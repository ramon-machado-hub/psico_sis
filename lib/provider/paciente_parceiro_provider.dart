import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/pacientes_parceiros.dart';

class PacientesParceirosProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('pacientes_parceiros')
        .get();
    if (_myDoc.docs.isEmpty){
      return 0;
    } else {
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;
      return _myDocCount.length;
    }
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPacienteParceiroById(String id) {
    return db.collection('pacientes_parceiros').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListPacientesParceiros() {
    return db.collection('pacientes_parceiros').snapshots();
  }

  int getIdByRazao(String idPaciente,String idParceiro, List<PacientesParceiros> list){
    int result =0;
    print("idPaciente $idPaciente");
    print("idParceiro $idParceiro");
    print("List<PacientesParceiros> ${list.length}");
    list.forEach((element) {
      print("elementidPaciente ${element.idPaciente}");
      print("element idParceiro ${element.idParceiro}");
      print("element idParceiro ${element.idPacientesParceiros}");
      if ( (element.idPaciente == int.parse(idPaciente)) &&
          ((element.idParceiro)== int.parse(idParceiro)) &&
          (element.status?.compareTo("ATIVO")==0) ){
        print("ENTROU getIdByRazao");
        result = element.idPacientesParceiros!;
      }
    });
    print("result $result");
    return result;
  }

  Future<List<PacientesParceiros>> getListAll() async{
    List<PacientesParceiros> list = [];
    QuerySnapshot querySnapshot = await db.collection('pacientes_parceiros').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((element) {
            // Usuario usuario = Usuario.fromJson1(element);
            // _lu.add(usuario);

              PacientesParceiros paciente = PacientesParceiros.fromJson1(element);
              // if (paciente.status?.compareTo("ATIVO")==0)
                  list.add(paciente);
          });

    print("List<PacientesParceiros> ${list.length}");
    return list;
  }

  Future<bool> existParceiroByPaciente(int id,)async {

    bool result = false;
    List<PacientesParceiros> list = [];
    await getListAll().then((value) {
      list = value;
      list.forEach((element) {
        if (element.idPaciente==id){
          result = true;
        }
      });
    });

    print("result $result");
    return result;
  }

  Future<String> getParceiroByPaciente(int id,)async {
    String result = "0";
    List<PacientesParceiros> list = [];
    await getListAll().then((value) {
      list = value;
      list.forEach((element) {
        if ((element.idPaciente == id)&&
            (element.status?.compareTo("ATIVO")==0)) {
          result = element.idParceiro.toString();
        }
      });
    });
    return result;
  }

  Future<void> put(PacientesParceiros pacienteSParceiros) async {
    if (pacienteSParceiros.idPacientesParceiros == null) {
      int id = await getCount();
      db.collection('pacientes_parceiros').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'idPaciente': pacienteSParceiros.idPaciente.toString(),
        'idParceiro': pacienteSParceiros.idParceiro.toString(),
        'status': pacienteSParceiros.status,
      });

    } else {
      db.collection('pacientes_parceiros').doc(pacienteSParceiros.idPacientesParceiros.toString()).set({
        'id': pacienteSParceiros.idPacientesParceiros.toString(),
        'idPaciente': pacienteSParceiros.idPaciente.toString(),
        'idParceiro': pacienteSParceiros.idParceiro.toString(),
        'status': pacienteSParceiros.status,
      });
    }
  }

  void remove(BuildContext context, String id) async {
    db.collection("pacientes_parceiros").doc(id).delete();
    notifyListeners();
  }
}