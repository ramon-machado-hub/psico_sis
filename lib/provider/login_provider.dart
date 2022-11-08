import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/Usuario.dart';
import '../model/login.dart';

class LoginProvider  with ChangeNotifier{

  // List<Usuario> listUsuario = [];
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('users')
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUsuarioByUid(String uid) {
    return db.collection('users').doc(uid).snapshots();
  }

  Future<QuerySnapshot> getLogin2() async{
    return await db.collection('users').get();
  }



  Future<Login> getLoginByUid2(String uid) async {
        DocumentSnapshot documentSnapshot = await
          db.collection('users').doc(uid).get();
        if (documentSnapshot.exists){
          final Map<String, dynamic>
          doc = documentSnapshot.data() as Map<String, dynamic>;
          print("encontrou users getLoginByUid2");
          print(doc);
          return Login.fromSnapshot(documentSnapshot.id,doc);
        } else {
          return Login(
              id: 0,
              id_usuario: 0,
              tipo_usuario: "não encontrou",
          );
        }
  }

  Stream<QuerySnapshot> getListUsuario() {
    return db.collection('usuers').snapshots();
  }

  Future<List<Login>> getUsers() async {
    final querySnapshot = await db.collection('users').get();
    final usuario = querySnapshot.docs.map((e) {
      // Now here is where the magic happens.
      // We transform the data in to Product object.
    final user = Login.fromJson(e.data());
      // Setting the id value of the product object.
      user.id1 = e.id;
      return user;
    }).toList();
    return usuario;
  }

  Future<List<Login>> getListUsers()async {
    List<Login> list = [];
    var documents = await db.collection('users').get();

    // .then((QuerySnapshot snapshot) {
    //   snapshot.docs.forEach((f) {
    //     list.add(
    //
    //         Login(
    //           id: int.parse(f.id),
    //           id_usuario: documents.docs[i]['id_usuario'],
    //           tipo_usuario: documents.docs[i]['tipo_usuario'],
    //         )
    //     );
    //   });
    // });
    for(int i =0; i<documents.size; i++){
      // String id = documents.docs.;/
      list.add(Login(
        id: int.parse(documents.docs[i]['id']),
        id_usuario: documents.docs[i]['id_usuario'],
        tipo_usuario: documents.docs[i]['tipo_usuario'],
      ));
    }
    return list;
  }

  String getDataUid()  {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? uid = user?.uid.toString();
    print(uid.toString());
    return uid.toString();
  }

  Future<void> put2(Login login, String uid) async {
    // Usuario usuarioSave;
        db.collection('back_users').doc(uid).set({
          'id': login.id.toString(),
          'id_usuario': login.id_usuario.toString(),
          'tipo_usuario': login.tipo_usuario,
        });
  }

  Future<int?> put(Login login) async {
    // Usuario usuarioSave;
    if (login.id == null) {

      String uid = getDataUid();
      print("put provider uid = $uid");
      print("login ${login.id_usuario}");
      int id = 0;
      getCount().then((value) {
        print("entrou put");
        id=value+1;
        db.collection('users').doc((uid).toString()).set({
          'id': id.toString(),
          'id_usuario': login.id_usuario.toString(),
          'tipo_usuario': login.tipo_usuario,
        });
        return id;
      });

    }else {
      //alterar
      // db.collection('login').doc(uid).set({
      //   'idUsuario': usuario.idUsuario,
      //   'nomeUsuario': usuario.nomeUsuario,
      //   'loginUsuario': usuario.loginUsuario,
      //   'emailUsuario': usuario.emailUsuario,
      //   'senhaUsuario': usuario.senhaUsuario,
      //   'statusUsuario': usuario.statusUsuario,
      //   'tokenUsuario': usuario.tokenUsuario,
      //   'dataNascimentoUsuario': usuario.dataNascimentoUsuario,
      //   'telefone': usuario.telefone,
      //   'tipoUsuario': usuario.tipoUsuario
      // });
      return 0;
    }
  }
}