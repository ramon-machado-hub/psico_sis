import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/Paciente.dart';

class PacienteProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('pacientes')
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPacienteById(String id) {
    return db.collection('pacientes').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListPacientes() {
    return db.collection('pacientes').snapshots();
  }

  Future<bool> existByName(String nome) async {
    var documents = await db.collection('pacientes').where("nome_paciente", isEqualTo: nome).get();
    if (documents.size==0){
      return false;
    }else{
      return true;
    }
  }

  Future<List<Paciente>> getListByParteOfName(String parteName) async {
    print("parteName $parteName");
    List<Paciente> list = [];
    var documents = await db.collection('pacientes').where(
        "nome_paciente".substring(0, parteName.length), isEqualTo: parteName).get();
    if (documents.size>0){
      for (int i =0; i<documents.docs.length; i++) {
        list.add(
            Paciente(
              idPaciente: int.parse(documents.docs[i]['id']),
              numero: documents.docs[i]['numero'],
              endereco:documents.docs[i]['endereco'],
              telefone: documents.docs[i]['telefone'],
              cpf:documents.docs[i]['cpf'],
              dataNascimento:documents.docs[i]['data_nascimento'],
              nome:documents.docs[i]['nome_paciente'],
        ));
      };
    } else {
      print("não encontrou");
    }
    print(list.length.toString()+" return");
    return list;
  }

  Future<List<Paciente>> getListByName(String nome) async{
    List<Paciente> list = [];
    var documents = await db.collection('pacientes').where("nome_paciente", isEqualTo: nome).get();

    if (documents.size>0){
      list.add(Paciente(
        idPaciente: int.parse(documents.docs[0]['id']),
        numero: documents.docs[0]['numero'],
        endereco:documents.docs[0]['endereco'],
        telefone: documents.docs[0]['telefone'],
        cpf:documents.docs[0]['cpf'],
        dataNascimento:documents.docs[0]['data_nascimento'],
        nome:documents.docs[0]['nome_paciente'],
      ));
    }  else {
      print("lista vazia");
    }
    //     .snapshots().listen((event) {
    //       if(event.docs.isNotEmpty){
    //
    //         // event.docs.forEach((element) {
    //         print("adicionau");
    //           list.add(Paciente(
    //             idPaciente: int.parse(event.docs[0]['id']),
    //             numero: event.docs[0]['numero'],
    //             endereco:event.docs[0]['endereco'],
    //             telefone: event.docs[0]['telefone'],
    //             cpf:event.docs[0]['cpf'],
    //             dataNascimento:event.docs[0]['data_nascimento'],
    //             nome:event.docs[0]['nome_paciente'],
    //           ));
    //         print("list ${list.length}");
    //
    //         // });
    //       } else {
    //         print("lista vazia");
    //       }
    //
    // });
    print("list ${list.length}");
    return list;
  }

  Future<bool> existPaciente(String nome) async {
    bool result = false;
    await getListByName(nome).then((value) {
      if (value.isNotEmpty){
        result = true;
        print("entrou usuario");
        return true;
      } else {
        return false;
      }
    });
    print("entrou $result");

    return result;
    //       list = value;
    //       list.forEach((element) {
    //         if (element.idPaciente==id){
    //           result = true;
    //         }
    //       });
    //     });
    // await db.collection('pacientes').where("nome_paciente", isEqualTo: nome)
    // .snapshots().listen((event) {
    //   if (event.docs.isEmpty){
    //
    //     print("lista vazia");
    //   } else {
    //     print("encontrou");
    //     print(event.docs[0]['nome_paciente']);
    //     print("event");
    //     if (nome.compareTo(event.docs[0]['nome_paciente'])==0){
    //
    //       result = true;
    //
    //
    //     }
    //   }
    //
    // });

    // print("result ´= ${result}");
    // return result;
  }

  Future<void> put(Paciente paciente) async {
    if (paciente.idPaciente == null) {
      int id = await getCount();
      db.collection('pacientes').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'nome_paciente': paciente.nome,
        'cpf': paciente.cpf,
        'data_nascimento': paciente.dataNascimento,
        'endereco': paciente.endereco,
        'telefone': paciente.telefone,
        'numero': paciente.numero,
      });
    }else {
      db.collection('pacientes').doc(paciente.idPaciente.toString()).set({
        'id': paciente.idPaciente.toString(),
        'nome_paciente': paciente.nome,
        'cpf': paciente.cpf,
        'data_nascimento': paciente.dataNascimento,
        'endereco': paciente.endereco,
        'telefone': paciente.telefone,
        'numero': paciente.numero,
      });
    }
  }
}