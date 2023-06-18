import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/Paciente.dart';

class PacienteProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<Paciente> pacientes = [];
  DocumentSnapshot? last = null;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPacienteById(String id) {
    return db.collection('pacientes').doc(id).snapshots();
  }

  Future<Paciente> getPaciente(String id) async{

    print(id);
    print("id.");
    print(pacientes.length);


    Paciente paciente = Paciente();
    if (pacientes.length==0){
      final querySnapshot = await db.collection('pacientes').doc(id).get();
      final paciente = Paciente.fromJson1(querySnapshot.data());
      paciente.id1 = querySnapshot.id;
      return paciente;
    } else {
      pacientes.forEach((element) {
        if(element.id1.compareTo(id)==0){
          paciente = element;
        }
      });
      // print(paciente.nome!);
      if (paciente.nome==null){
        final querySnapshot = await db.collection('pacientes').doc(id).get();
        final paciente = Paciente.fromJson1(querySnapshot.data());
        paciente.id1 = querySnapshot.id;
        return paciente;
      }
      return paciente;
    }
  }

  Future<List<Paciente>> getListPacientes() async {
    if (pacientes.length==0){
      final querySnapshot = await db.collection('pacientes').get();
      // final querySnapshot = await db.collection('pacientes').orderBy("nome_paciente").limit(10);

      final allData = querySnapshot.docs.map((doc) {
        final paciente = Paciente.fromJson(doc.data());
        paciente.id1 = doc.id;
        return paciente;
      }).toList();
      print("paciente provider list = ${allData.length}");
      pacientes = allData;
      print("Pacientes retornou allData ${pacientes.length}");
      return allData;
    } else {
      print("Pacientes retornou pacientes ${pacientes.length}");
      return pacientes;
    }

  }

  Future<List<Paciente>> getListPacientes2() async {
    if (pacientes.length==0){
      print("pacientes = 0");
      final querySnapshot = await db.collection('pacientes').orderBy("nome_paciente")
          .limit(10).snapshots().listen((event) {
          pacientes.clear();
          for (var doc in event.docs){
            final data = doc.data();
            final pac = Paciente.fromJson(data);
            pac.id1 = doc.id;
            pacientes.add(pac);
          }
          print("last");
          last = event.docs.last;
          // return pacientes;
      });
      print("PacientesProvider retornou AllData ${pacientes.length}");

      return pacientes;
    } else {
      print("elseeeee");
      final querySnapshot = await db.collection('pacientes').orderBy("nome_paciente")
          .limit(10).startAfterDocument(last!).snapshots().listen((event) {
        // pacientes.clear();
        for (var doc in event.docs){
          final data = doc.data();
          final pac = Paciente.fromJson(data);
          pac.id1 = doc.id;
          print("adicionou ${pac.nome}");
          pacientes.add(pac);
        }
        last = event.docs.last;
        print("last = ${event.docs.last.data()['nome_paciente']}") ;
      });
      print("Pacientes retornou pacientes +10 ${pacientes.length}");
      return pacientes;
    }

  }

  Future<bool> existByName(String nome) async {
    var documents = await db.collection('pacientes').where("nome_paciente", isEqualTo: nome).get();
    if (documents.size==0){
      return false;
    }else{
      return true;
    }
  }

  Future<Paciente?> getPacienteById2(String id)async{
    final documentSnapshhot = await db.collection('pacientes').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
      documentSnapshhot.data() as Map<String, dynamic>;
      final paciente = Paciente.fromJson(doc);
      paciente.id1= documentSnapshhot.id;
      return paciente;
    } else {
      return null;
    }
  }

  Future<List<Paciente>> getListByParteOfName(String parteName) async {
    List<Paciente> result = [];
    print("parteName $parteName");
    print(parteName.length);
    if (pacientes.length>0) {
      for (var value in pacientes) {
        if (value.nome!.substring(0, parteName.length).compareTo(parteName) ==
            0) {
          result.add(value);
        }
      }
    }
    if (result.length>0){
      return result;
    } else{
      var querySnapshot = await db.collection('pacientes')
          .where('nome_paciente', isGreaterThanOrEqualTo: parteName)
          .where('nome_paciente', isLessThanOrEqualTo: parteName+"\uF7FF")
          .get();
      final allData = querySnapshot.docs.map((doc) {
        final paciente = Paciente.fromJson(doc.data());
        paciente.id1 = doc.id;
        return paciente;
      }).toList();
      print("getListByParteOfName list = ${allData.length}");
      return allData;
    }
  }

  Future<List<Paciente>> getListByName(String nome) async{
    List<Paciente> list = [];
    var documents = await db.collection('pacientes').where("nome_paciente", isEqualTo: nome).get();

    if (documents.size>0){
      list.add(Paciente(
        idPaciente: documents.docs[0]['id'],
        numero: documents.docs[0]['numero'],
        endereco:documents.docs[0]['endereco'],
        telefone: documents.docs[0]['telefone'],
        cpf:documents.docs[0]['cpf'],
        dataNascimento:documents.docs[0]['data_nascimento'],
        nome:documents.docs[0]['nome_paciente'],
        nome_responsavel:documents.docs[0]['nome_responsabel'],
      ));
    }  else {
      print("lista vazia");
    }
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
  }

  //backup pacientes
  // Future<void> put2(Paciente paciente) async {
  //   var itemRef = db.collection("back_pacientes");
  //   var doc = itemRef.doc().id;
  //     db.collection('back_pacientes').doc(doc).set({
  //       'nome_paciente': paciente.nome,
  //       'cpf': paciente.cpf,
  //       'data_nascimento': paciente.dataNascimento,
  //       'endereco': paciente.endereco,
  //       'telefone': paciente.telefone,
  //       'numero': paciente.numero,
  //     }).then((value) => print('inseriu back_paciente ${paciente.idPaciente} = $doc'));
  // }

  // Stream<QuerySnapshot> getPac() {
    // CollectionReference colRef = db.collection('pacientes');
    // QuerySnapshot docs =  colRef.orderBy('nome_paciente').limit(20).get();
    // docs.docs.forEach((element) => print(element.id));
    // DocumentSnapshot lastDoc = docs.docs.last;
    // if (_idLastPaciente.compareTo("")==0){
    //   var query = db.collection('pacientes').limit(20).orderBy('nome_paciente').snapshots();
    //
    // }else {
    //
    // }
    //
    // return db.collection('pacientes').limit(20).orderBy('nome_paciente').snapshots();
  // }

  Future<String> put(Paciente paciente) async {
      var itemRef = db.collection("pacientes");
      var doc = itemRef.doc().id;
      db.collection('pacientes').doc(doc).set({
        'nome_paciente': paciente.nome,
        'nome_responsavel': paciente.nome_responsavel,
        'cpf': paciente.cpf,
        'data_nascimento': paciente.dataNascimento,
        'endereco': paciente.endereco,
        'telefone': paciente.telefone,
        'numero': paciente.numero,
      }).then((value) {
        // paciente.id1=doc;
        // pacientes.add(paciente);
        print("inseriu paciente $doc");
      } );
      return doc;
  }

  Future<void> updateNomeResponsavel(String id, String nomeResponsavel) async {
    var collection = db.collection('pacientes');
    collection.doc(id).update({
      'nome_responsavel': nomeResponsavel,
    }).then((value) => print('Update paciente $id'))
        .catchError((error)=>print("update failed: $error"));
  }

  Future<void> updatePaciente(String id, Paciente paciente) async {
    var collection = db.collection('pacientes');
    collection.doc(id).update({
      'nome_paciente': paciente.nome,
      'cpf': paciente.cpf,
      'data_nascimento': paciente.dataNascimento,
      'endereco': paciente.endereco,
      'telefone': paciente.telefone,
      'numero': paciente.numero,
      'nome_responsavel': paciente.nome_responsavel,
    }).then((value) => print('Update paciente $id'))
        .catchError((error)=>print("update failed: $error"));
    pacientes.forEach((element) {
      if (element.id1.compareTo(id)==0){
        element = paciente;
      }
    });
  }

}