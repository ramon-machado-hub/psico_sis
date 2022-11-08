import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/provider/especialidade_profissional_provider.dart';

import '../model/Especialidade.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/especialidades_profissional.dart';
import '../model/servico.dart';
import '../model/servicos_profissional.dart';
import '../provider/especialidade_provider.dart';
import '../provider/profissional_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_uper_widget.dart';

class Profissionais extends StatefulWidget {
  const Profissionais({Key? key}) : super(key: key);

  @override
  State<Profissionais> createState() => _ProfissionaisState();
}

class _ProfissionaisState extends State<Profissionais> {
  // var controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // final ScrollController _scrollController2 = ScrollController();
  String _parteName = "";
  List<Profissional> items = [];
  List<Especialidade> itemsEsp = [];
  List<EspecialidadeProfissional> itemsEspProf = [];
  List<ServicosProfissional> itemsServProf = [];
  List<Servico> itemsServ = [];
  List<Profissional> _lProfFinal = [];
  StreamSubscription<QuerySnapshot>? profissionalSubscription;
  StreamSubscription<QuerySnapshot>? especialidadeSubscription;
  StreamSubscription<QuerySnapshot>? especialidadeProfissionalSubscription;
  StreamSubscription<QuerySnapshot>? servicoSubscription;
  StreamSubscription<QuerySnapshot>? servicosProfissionalSubscription;
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

  List<Profissional> getProfByEsp(String especialidade){
    if (especialidade.compareTo("TODAS")==0){
      return _lProfFinal;
    }
    List<Profissional> list =[];
    //recuperar id da especialidade
    String idEsp ="";
    itemsEsp.forEach((element) {
      if (element.descricao!.compareTo(especialidade)==0){
         idEsp = element.idEspecialidade!;
      }
    });
    //recuperar quais profissionais possuem aquela especialidade
    itemsEspProf.forEach((element) {
      if (element.idEspecialidade==idEsp){
        list.add(_lProfFinal.firstWhere((element2) => element2.id==element.idProfissional));
      }
    });
    return list;
  }

  List<Profissional> getProfParteName(String parteName){
    List<Profissional> list = [];
    if (parteName.length==0) {
      list = _lProfFinal;
    } else {
      _lProfFinal.forEach((element) {
        if (element.nome?.substring(0,parteName.length).compareTo(parteName)==0)
          list.add(element);
      });
    }
    return list;
  }



  String dropdown = "TODAS";
  List<DropdownMenuItem<String>> getDropdownEspecialidades(
      List<Especialidade> list) {
    List<String> distinct =[];
    List<DropdownMenuItem<String>> dropDownItems = [];
    dropDownItems.add(DropdownMenuItem(
      value: "TODAS",
      child: Text("TODAS")),
    );

    //filtra quais especialidades possuem profissinal
    for (var espProf in itemsEspProf){
      if (distinct.contains(espProf.idEspecialidade)==false){
        distinct.add(espProf.idEspecialidade!);
      }
    }

    for (int i = 0; i < list.length; i++) {
      if (distinct.contains(list[i].idEspecialidade)){
        var newDropdown = DropdownMenuItem(
          value: list[i].descricao.toString(),
          child: Text(list[i].descricao.toString()),
        );
        dropDownItems.add(newDropdown);
      }

    }
    return dropDownItems;
  }

  // itemsEsp.first.descricao!;

  @override
  void initState(){
      super.initState();
      profissionalSubscription?.cancel();
      profissionalSubscription =
          db.collection("profissional").snapshots().listen(
                  (snapshot) {
                items = snapshot.docs.map(
                        (documentSnapshot) => Profissional.fromMap(
                      documentSnapshot.data(),
                      int.parse(documentSnapshot.id),
                    )
                ).toList();
                if(this.mounted){
                  items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                  _lProfFinal = items;
                  setState((){});
                }
              });
      especialidadeSubscription?.cancel();
      especialidadeSubscription =
          db.collection("especialidades").snapshots().listen((snapshot) {
            itemsEsp = snapshot.docs
                .map((documentSnapshot) =>
                Especialidade.fromMap(
                  documentSnapshot.data(),
                  documentSnapshot.id,
                )).toList();

            itemsEsp.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
            // dropdown = itemsEsp.first.descricao!;
          });

      servicosProfissionalSubscription?.cancel();
      servicosProfissionalSubscription =
          db.collection("servicos_profissional").snapshots().listen((snapshot) {
            itemsServProf = snapshot.docs
                .map((documentSnapshot) =>
                ServicosProfissional.fromMap(
                    documentSnapshot.data(),
                    int.parse(documentSnapshot.id),
                )).toList();
          });
      servicoSubscription?.cancel();
      servicoSubscription =
          db.collection("servicos").snapshots().listen((snapshot) {
            itemsServ = snapshot.docs
                .map((documentSnapshot) =>
                Servico.fromMap(
                  documentSnapshot.data(),
                  documentSnapshot.id,
                )).toList();
          });

      especialidadeProfissionalSubscription?.cancel();
      especialidadeProfissionalSubscription =
        db.collection("especialidades_profissional").snapshots().listen((snapshot) {
          itemsEspProf = snapshot.docs
              .map((documentSnapshot) =>
              EspecialidadeProfissional.fromMap(
                documentSnapshot.data(),
                int.parse(documentSnapshot.id),
              )).toList();
        });

        Future.wait([
        PrefsService.isAuth().then((value) {
          if (value){
            print("usuário autenticado profissionais");
            PrefsService.getUid().then((value) {
              _uid = value;
              print("_uid initState profissionais $_uid");
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

  Especialidade getEspById(String id){
    Especialidade esp = Especialidade(idEspecialidade: "0", descricao: "");
    itemsEsp.forEach((element) {
      if (element.idEspecialidade==id){
        esp=  element;
      }
    });
    return esp;
  }

  String getNomeServicoById(String id){
    print("getnome $id");

    String result ="";
    var nome = itemsServ.firstWhere((element) => element.id==id,);
    // itemsServ.forEach((element) {
    //   print("element.id = ${element.id}");
    //   if (element.id==id){
    //     result = element.descricao!;
    //   }
    // });
    print("result $result");
    print("nome $nome");
    return nome.descricao!;
  }

  List<ServicosProfissional> getListServProf(int id){
    List<ServicosProfissional> result = [];
    itemsServProf.forEach((element) {
      print(element);
      if (element.idProfissional==id){
        result.add(element);
      }
    });

    print("result = ${result.length}");
    return result;
  }

  List<Especialidade> getListEspById(int? id) {
    List<Especialidade> result = [];
    itemsEspProf.forEach((element) {
        if (element.idProfissional==id){
          result.add(getEspById(element.idEspecialidade!));
        }
    });
    return result;
  }

  int getCountServProf(int id){
    int count =0;
    itemsServProf.forEach((element) {
      if(element.idProfissional==id){
        count++;
      }
    });
    return count;
  }

  double getHeigth(int id){
    // print(getCountEspProf(id));
    // print(getCountServProf(id));
    int count = 0;
    if (getCountServProf(id)>getCountEspProf(id)){
      count = getCountServProf(id);
    } else {
      count = getCountEspProf(id);
    }

    // print("LLLLL");
    // print(MediaQuery.of(context).size.height*0.05);

    double result = count*(MediaQuery.of(context).size.height*0.035)+(MediaQuery.of(context).size.height*0.15);
    print(result);
    print("ID");
    return result;
  }

  double getHeigthSerEsp(int id){
    // print(getCountEspProf(id));
    // print(getCountServProf(id));
    int count = 0;
    if (getCountServProf(id)>getCountEspProf(id)){
      count = getCountServProf(id);
    } else {
      count = getCountEspProf(id);
    }
    if (count==0) {
      count++;
    }
    // print("LLLLL");
    // print(MediaQuery.of(context).size.height*0.05);
    if (count==0) {
      count=2;
    }
    double result = count*(MediaQuery.of(context).size.height*0.035)+(MediaQuery.of(context).size.height*0.05);;
    // print(result);
    return result;
  }

  int getCountEspProf(int? id) {
    int count = 0;
    // print("id");
    // print(itemsEspProf.length);
    itemsEspProf.forEach((element) {

      if(element.idProfissional==id){
        count++;
      }
    });
    if (count==0) {
      count++;
    }
    // print("Id = $id Count ${count}");
    return count;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    profissionalSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    print(items.length);
    return SafeArea(child: Scaffold(
        appBar: PreferredSize(
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.22,
                                height: size.height * 0.08,
                                child: InputTextUperWidget(
                                  label: "Pesquisar por nome", icon: Icons.search_rounded,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  onChanged: (value) async{
                                    print("------------------------");
                                    _parteName = value;
                                    print("_parteName $_parteName length ${_parteName.length}");
                                    print("_lpFinal length ${_lProfFinal.length}");
                                    if(_parteName.length==0){
                                      print("parteName = 0 $_parteName");
                                      // items.clear();
                                      print("items = getPaciParteName($_parteName)");
                                      items = getProfParteName(_parteName);
                                      print(items.length.toString()+"aaa");
                                    } else {
                                      print("getPaciParteName");
                                      print("items = getPaciParteName($_parteName)");
                                      items = getProfParteName(_parteName);
                                      print("items.length "+items.length.toString()+" aaa");
                                    }
                                    setState((){});
                                  },
                                  backgroundColor: AppColors.secondaryColor,
                                  borderColor: AppColors.line,
                                  textStyle:  AppTextStyles.subTitleBlack12,
                                  iconColor: AppColors.labelBlack,),
                              ),
                              SizedBox(
                                width: size.width * 0.2,
                                height: size.height * 0.08,
                                // child: Text("Filtrar por Especialidade"),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: size.height * 0.02,
                                        width: size.width * 0.2,

                                        child: FittedBox(
                                            alignment: Alignment.centerLeft,
                                            fit: BoxFit.scaleDown,
                                            child: Text("Especialidade"))),
                                    SizedBox(
                                      height: size.height * 0.06,
                                      width: size.width * 0.2,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButton<String>(
                                          value: dropdown,
                                          icon: const Icon(Icons.arrow_drop_down_sharp),
                                          elevation: 16,
                                          style: TextStyle(color: AppColors.labelBlack),
                                          underline: Container(
                                            height: 2,
                                            width: size.width * 0.2,
                                            color: AppColors.line,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdown = newValue!;
                                              items = getProfByEsp(dropdown);
                                              setState((){});
                                            });
                                          },
                                          items: getDropdownEspecialidades(itemsEsp),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: size.height * 0.56,
                          width: size.width * 0.55,
                          child: SingleChildScrollView(
                            controller: _scrollController,

                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                                child: Column(

                                  children: [
                                    // ListView.builder(
                                    //     itemCount: items.length,
                                    //     itemBuilder: (context,index){
                                    //       return Row(
                                    //         children: [
                                    //           //imagem
                                    //           Card(
                                    //             elevation: 8,
                                    //             child: Container(
                                    //               width: size.width * 0.05,
                                    //               height: size.width * 0.05,
                                    //               decoration: BoxDecoration(
                                    //                   borderRadius: BorderRadius.circular(6.0),
                                    //                   color: AppColors.labelWhite
                                    //               ),
                                    //               child: FittedBox(
                                    //                 fit: BoxFit.contain,
                                    //                 child: Icon(
                                    //                     color: AppColors.labelBlack.withOpacity(0.5),
                                    //                     Icons.person),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             width: size.width * 0.38,
                                    //             height: getHeigth(item.id!),
                                    //             child: Card(
                                    //                 elevation: 8,
                                    //                 child: ListTile(
                                    //                   trailing: Column(
                                    //                     children: [
                                    //                       Icon(Icons.edit_rounded),
                                    //                     ],
                                    //                   ),
                                    //                   title: Column(
                                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                                    //                     children: [
                                    //                       FittedBox(
                                    //                           fit: BoxFit.scaleDown,                                        //
                                    //                           child: Text(item.nome.toString(), style: AppTextStyles.labelBlack16Lex,)),
                                    //                       Divider(),
                                    //                       Row(
                                    //                         children: [
                                    //                           //ESPECIALIDADES
                                    //                           Padding(
                                    //                             padding: const EdgeInsets.only(right: 15.0),
                                    //                             child: Container(
                                    //                               height: getHeigthSerEsp(item.id!),
                                    //                               width: size.width * 0.15,
                                    //                               decoration: BoxDecoration(
                                    //                                 // color: AppColors.red,
                                    //                                   border: Border.all(color: AppColors.line)
                                    //                               ),
                                    //                               child: Padding(
                                    //                                 padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                                    //                                 child: Column(
                                    //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                    //                                   children: [
                                    //                                     Text("Especialidades:", style: AppTextStyles.labelBlack14Lex,),
                                    //                                     Divider(
                                    //                                       color: AppColors.line,
                                    //                                     ),
                                    //                                     for (var items in getListEspById(item.id))
                                    //                                       FittedBox(
                                    //                                           fit: BoxFit.scaleDown,
                                    //                                           child: Text(items.descricao!, style: AppTextStyles.labelBlack12Lex,))
                                    //                                   ],
                                    //                                 ),
                                    //                               ),
                                    //
                                    //                             ),
                                    //                           ),
                                    //
                                    //                           // SERVIÇOS
                                    //                           Padding(
                                    //                             padding: const EdgeInsets.only(left: 15.0),
                                    //                             child: Container(
                                    //                               height: getHeigthSerEsp(item.id!),
                                    //                               width: size.width * 0.15,
                                    //                               decoration: BoxDecoration(
                                    //                                   border: Border.all(color: AppColors.line)
                                    //                               ),
                                    //                               // color: AppColors.green,
                                    //                               child: Padding(
                                    //                                 padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                    //                                 child: Column(
                                    //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                    //                                   children: [
                                    //                                     Text("Serviços Ofertados:",style: AppTextStyles.labelBlack14Lex,),
                                    //                                     Divider(
                                    //                                       color: AppColors.line,
                                    //                                     ),
                                    //                                     for (var items in getListServProf(item.id!))
                                    //                                       Row(
                                    //                                         mainAxisAlignment: MainAxisAlignment.start,
                                    //                                         children: [
                                    //                                           SizedBox(
                                    //                                             width: size.width * 0.1,
                                    //                                             child: Padding(
                                    //                                               padding: const EdgeInsets.only(right: 3.0),
                                    //                                               child: FittedBox(
                                    //                                                   fit: BoxFit.scaleDown,
                                    //                                                   alignment: Alignment.centerLeft,
                                    //                                                   child: Text(getNomeServicoById(items.idServico!), style: AppTextStyles.labelBlack12Lex,)),
                                    //                                             ),
                                    //                                           ),
                                    //
                                    //                                           SizedBox(
                                    //                                             width: size.width * 0.04,
                                    //                                             child: FittedBox(
                                    //                                                 fit: BoxFit.scaleDown,
                                    //                                                 child: Text("R\$ ${items.valor!}")),
                                    //                                           ),
                                    //                                         ],
                                    //                                       )
                                    //
                                    //                                   ],
                                    //                                 ),
                                    //                               ),
                                    //                             ),
                                    //                           )
                                    //                         ],
                                    //                       ),
                                    //
                                    //
                                    //                     ],
                                    //                   ),
                                    //
                                    //                 )
                                    //             ),
                                    //           )
                                    //         ],
                                    //       );
                                    //     }),
                                    for (var item in items)
                                      Row(
                                        children: [
                                          //imagem
                                          Card(
                                            elevation: 8,
                                            child: Container(
                                              width: size.width * 0.05,
                                              height: size.width * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6.0),
                                                color: AppColors.labelWhite
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Icon(
                                                    color: AppColors.labelBlack.withOpacity(0.5),
                                                    Icons.person),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: size.width * 0.38,
                                            height: getHeigth(item.id!),
                                            child: Card(
                                              elevation: 8,
                                              child: ListTile(
                                                trailing: Icon(Icons.edit_rounded),
                                                title: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,                                        //
                                                      child: Text(item.nome.toString(), style: AppTextStyles.labelBlack16Lex,)),
                                                    Divider(),
                                                    Row(
                                                      children: [
                                                        //ESPECIALIDADES
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 15.0),
                                                          child: Container(
                                                            height: getHeigthSerEsp(item.id!),
                                                            width: size.width * 0.15,
                                                            decoration: BoxDecoration(
                                                              // color: AppColors.red,
                                                              border: Border.all(color: AppColors.line)
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Especialidades:", style: AppTextStyles.labelBlack14Lex,),
                                                                  Divider(
                                                                    color: AppColors.line,
                                                                  ),
                                                                  for (var items in getListEspById(item.id))
                                                                    FittedBox(
                                                                        fit: BoxFit.scaleDown,
                                                                        child: Text(items.descricao!, style: AppTextStyles.labelBlack12Lex,))
                                                                ],
                                                              ),
                                                            ),

                                                          ),
                                                        ),

                                                        // SERVIÇOS
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 15.0),
                                                          child: Container(
                                                            height: getHeigthSerEsp(item.id!),
                                                            width: size.width * 0.15,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: AppColors.line)
                                                            ),
                                                            // color: AppColors.green,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Serviços Ofertados:",style: AppTextStyles.labelBlack14Lex,),
                                                                  Divider(
                                                                    color: AppColors.line,
                                                                  ),
                                                                  for (var items in getListServProf(item.id!))
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: size.width * 0.1,
                                                                          height: size.height*0.025,
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(right: 3.0),
                                                                            child: FittedBox(
                                                                                fit: BoxFit.scaleDown,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(getNomeServicoById(items.idServico!), style: AppTextStyles.labelBlack12Lex,)),
                                                                          ),
                                                                        ),

                                                                        SizedBox(
                                                                          width: size.width * 0.04,
                                                                          height: size.height*0.025,

                                                                          child: FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              child: Text("R\$ ${items.valor!}")),
                                                                        ),
                                                                      ],
                                                                    )

                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),


                                                  ],
                                                ),

                                              )
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
              ),
              ButtonWidget(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.2,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
                label: "Cadastrar Profissional",
                onTap: () {

                  Provider.of<ProfissionalProvider>(context, listen: false).setListProfissional(items);
                  Navigator.pushReplacementNamed(
                      context, "/cadastro_profissional");
                },
              ),
            ],
          ),
        )));
  }



}
