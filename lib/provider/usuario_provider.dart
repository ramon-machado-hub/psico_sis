import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/Usuario.dart';

class UsuarioProvider  with ChangeNotifier{

  List<Usuario> listUsuario = [];
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('usuarios')
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
    return db.collection('usuarios').doc(uid).snapshots();
  }

  Future<QuerySnapshot> getUsuarios2() async{
    return await db.collection('usuarios').get();
  }

  void setListUsuarios(List<Usuario> list){
      this.listUsuario = list;
  }
  
  Future<Usuario> getUsuarioByUid2(String uid) async {
        DocumentSnapshot documentSnapshot = await
          db.collection('usuarios').doc(uid).get();
        if (documentSnapshot.exists){
          final Map<String, dynamic>
          doc = documentSnapshot.data() as Map<String, dynamic>;
          print("encontrou usuario Provider");
          return Usuario.fromSnapshot(documentSnapshot.id,doc);
        } else {
          return Usuario(
            idUsuario:1,
            senhaUsuario: "",
            loginUsuario: "",
            dataNascimentoUsuario: "",
            telefone: "",
            nomeUsuario: "NÃO ENTROU",
            emailUsuario: "",
            statusUsuario:  "",
            tokenUsuario: "",
            tipoUsuario: "",
          );
        }
  }

  Stream<QuerySnapshot> getListUsuario() {
    return db.collection('usuarios').snapshots();
  }





  String getDataUid()  {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? uid = user?.uid.toString();
    print(uid.toString());
    return uid.toString();
  }

  Future<List<Usuario>> getUsuarios() async {
    final querySnapshot = await db.collection('usuarios').get();
    final login = querySnapshot.docs.map((e) {
      final json = e.data();
      // Now here is where the magic happens.
      // We transform the data in to Product object.
      final user = Usuario.fromJson(e.data());
      // Setting the id value of the product object.
      user.id1 = e.id;
      return user;
    }).toList();
    return login;
  }

  Future<void> put2(Usuario usuario, String id) async {
    // Usuario usuarioSave;
        db.collection('back_usuarios').doc(id).set({
          'idUsuario': usuario.idUsuario,
          'nomeUsuario': usuario.nomeUsuario,
          'loginUsuario': usuario.loginUsuario,
          'emailUsuario': usuario.emailUsuario,
          'senhaUsuario': usuario.senhaUsuario,
          'statusUsuario': usuario.statusUsuario,
          'tokenUsuario': usuario.tokenUsuario,
          'dataNascimentoUsuario': usuario.dataNascimentoUsuario,
          'telefone': usuario.telefone,
          'tipoUsuario': usuario.tipoUsuario
        });
  }

  Future<int?> put(Usuario usuario) async {
    // Usuario usuarioSave;
    if (usuario.idUsuario == null) {
      String uid = getDataUid();
      print("uid putTTT $uid");
      int id = 0;
      getCount().then((value) {
        print("entrou put");
        id=value+1;
        db.collection('usuarios').doc((uid).toString()).set({
          'idUsuario': id.toString(),
          'nomeUsuario': usuario.nomeUsuario,
          'loginUsuario': usuario.loginUsuario,
          'emailUsuario': usuario.emailUsuario,
          'senhaUsuario': usuario.senhaUsuario,
          'statusUsuario': usuario.statusUsuario,
          'tokenUsuario': usuario.tokenUsuario,
          'dataNascimentoUsuario': usuario.dataNascimentoUsuario,
          'telefone': usuario.telefone,
          'tipoUsuario': usuario.tipoUsuario
        });
        return id;
      });

    }else {
      //alterar
      db.collection('usuarios').doc(usuario.idUsuario.toString()).set({
        'idUsuario': usuario.idUsuario,
        'nomeUsuario': usuario.nomeUsuario,
        'loginUsuario': usuario.loginUsuario,
        'emailUsuario': usuario.emailUsuario,
        'senhaUsuario': usuario.senhaUsuario,
        'statusUsuario': usuario.statusUsuario,
        'tokenUsuario': usuario.tokenUsuario,
        'dataNascimentoUsuario': usuario.dataNascimentoUsuario,
        'telefone': usuario.telefone,
        'tipoUsuario': usuario.tipoUsuario
      });
      return usuario.idUsuario!;
    }
  }
}