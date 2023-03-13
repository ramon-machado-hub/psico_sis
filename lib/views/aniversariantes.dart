import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/service/validator_service.dart';
import 'package:psico_sis/themes/app_text_styles.dart';

import '../model/Paciente.dart';
import '../model/Usuario.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget2.dart';

class Aniversariantes extends StatefulWidget {
  const Aniversariantes({Key? key}) : super(key: key);

  @override
  State<Aniversariantes> createState() => _AniversariantesState();
}

class _AniversariantesState extends State<Aniversariantes> {

  StreamSubscription<QuerySnapshot>? pacienteSubscription;
  List<bool> _selected = [true, false, false];
  List<Paciente> items = [];
  List<Paciente> exibe = [];
  List<Paciente> aniversariantes = [];
  List<Paciente> aniversariantesSemana = [];
  List<Paciente> aniversariantesMes = [];
  var db = FirebaseFirestore.instance;
  String _uid="";

  late Usuario _usuario = Usuario(
    idUsuario:1,
    senhaUsuario: "",
    loginUsuario: "",
    dataNascimentoUsuario: "",
    telefone: "",
    nomeUsuario: "",
    emailUsuario: "",
    statusUsuario:  "",
    tokenUsuario: "",
  );

  Future<Usuario> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty){
      print("empity");
      String _uidGet ="";
      print("_uidGet $_uidGet");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    } else{
      print(" not empity");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    }
  }

  bool isAniversariante(String data){
    int dia = DateTime.now().day;
    int mes = DateTime.now().month;

    if ((int.parse(data.substring(0,2))==dia)&&
        (int.parse(data.substring(3,5))==mes)){
      return true;
    }
    return false;
  }



  @override
  void initState(){
    super.initState();
    pacienteSubscription?.cancel();
    pacienteSubscription =
        db.collection("pacientes").snapshots().listen(
                (snapshot) {
              setState((){
                items = snapshot.docs.map(
                        (documentSnapshot) => Paciente.fromMap(
                      documentSnapshot.data(),
                      documentSnapshot.id,
                    )
                ).toList();
                if(this.mounted){
                  // items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                  items.forEach((element) {
                    if (ValidatorService.validateAniversariante(element.dataNascimento!)){
                      aniversariantes.add(element);
                      print("validou aniversariante");
                    }
                    if (ValidatorService.validateAniversarianteDaSemana(element.dataNascimento!)){
                      aniversariantesSemana.add(element);
                      print("validou aniversariante semana ${element.dataNascimento}");

                    }
                    if (ValidatorService.validarAniversarianteMes(element.dataNascimento!)){
                      aniversariantesMes.add(element);
                      print("validou aniversariante mes");

                    }

                  });
                  aniversariantes.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                  exibe = aniversariantes;
                  aniversariantesSemana.sort((a, b) => a.dataNascimento.toString().compareTo(b.dataNascimento.toString()));
                  aniversariantesMes.sort((a, b) => a.dataNascimento.toString().compareTo(b.dataNascimento.toString()));
                  setState((){
                    print("exibe ${exibe.length}");
                  });
                }
              });
            });
    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value){
          print("usuário autenticado");
          PrefsService.getUid().then((value) {
            _uid = value;
            print("_uid initState $_uid");
            getUsuarioByUid(_uid).then((value) {
              _usuario = value;
              print("Nome ${_usuario.nomeUsuario}");
              if (this.mounted){
                setState((){});
              }
            });

          });
        } else {
          print("usuário não conectado initState Home Assistente");
          ///nav
          Navigator.pushReplacementNamed(
              context, "/login");
        }
      }),
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pacienteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return SafeArea(

          child: Scaffold(
              appBar:  PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: AppBarWidget2(nomeUsuario: _usuario.nomeUsuario!),
              ),
              body: Container(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 2.0,
                      colors: [
                        AppColors.shape,
                        AppColors.primaryColor,
                      ],
                    )),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //abas = DO DIA / DA SEMANA / DO MES
                    Container(
                      width: size.width * 0.45,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                _selected[0]=true;
                                _selected[1]=false;
                                _selected[2]=false;
                                exibe = aniversariantes;
                                setState((){});
                              },
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.06,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft:  Radius.circular(3),
                                      topRight:  Radius.circular(3),
                                    ),
                                    color: _selected[0] ? AppColors.secondaryColor : AppColors.line),
                                child: Center(child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: Text("Do dia", style: AppTextStyles.labelBold16,),
                                    ))),
                              ),
                            ),
                            SizedBox(width: 2,),
                            InkWell(
                              onTap: (){
                                _selected[0]=false;
                                _selected[1]=true;
                                _selected[2]=false;
                                // exibe.clear();
                                print("aniver da semana");
                                print(aniversariantesSemana.length);
                                exibe = aniversariantesSemana;
                                setState((){});
                              },
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.06,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft:  Radius.circular(3),
                                      topRight:  Radius.circular(3),
                                    ),
                                    color: _selected[1] ? AppColors.secondaryColor : AppColors.line),
                                child: Center(child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: Text("Da semana", style: AppTextStyles.labelBold16,),
                                    ))),
                              ),
                            ),
                            SizedBox(width: 2,),
                            InkWell(
                              onTap: (){
                                _selected[0]=false;
                                _selected[1]=false;
                                _selected[2]=true;
                                // exibe.clear();
                                exibe = aniversariantesMes;
                                setState((){});
                              },
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.06,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft:  Radius.circular(3),
                                      topRight:  Radius.circular(3),
                                    ),
                                    color: _selected[2] ? AppColors.secondaryColor : AppColors.line),
                                child:  Center(child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: Text("Do mês", style: AppTextStyles.labelBold16,),
                                    ))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: size.width * 0.45,
                        height: size.height * 0.7,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.line,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.shape),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                for (var item in exibe)
                                  Card(
                                    elevation: 8,
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.nome.toString()),
                                          Text(item.dataNascimento!, style: AppTextStyles.labelBold16,),
                                        ],
                                      ),

                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ))
      );
    }
  }
