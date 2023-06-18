import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_profissional.dart';
import 'package:psico_sis/model/dias_profissional.dart';
import 'package:psico_sis/provider/dias_profissional_provider.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/especialidade_profissional_provider.dart';
import 'package:psico_sis/provider/servico_profissional_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';

import '../model/Especialidade.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/dias_salas_profissionais.dart';
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
  List<DiasProfissional> itemsDiasProf = [];
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
         idEsp = element.id1;
      }
    });
    //recuperar quais profissionais possuem aquela especialidade
    itemsEspProf.forEach((element) {
      if (element.idEspecialidade==idEsp){
        list.add(_lProfFinal.firstWhere((element2) => element2.id1==element.idProfissional));
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
      print(list[i].id1);
      print("{list[$i].id1}");

      if (distinct.contains(list[i].id1)){
        var newDropdown = DropdownMenuItem(
          value: list[i].descricao.toString(),
          child: Text(list[i].descricao.toString()),
        );
        dropDownItems.add(newDropdown);
      }

    }
    return dropDownItems;
  }


  @override
  void initState(){
      super.initState();
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

      if (items.length==0){
        Provider.of<ProfissionalProvider>(context, listen: false)
            .getListProfissionais().then((value) {

                if(this.mounted){
                    items = value;
                    print("items = ${items.length}");
                    print("profissionais = ${items.length}");
                    items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                    _lProfFinal = items;
                }
        });
      }


      if (itemsEsp.length==0){
        Provider.of<EspecialidadeProvider>(context, listen: false)
            .getEspecialidades().then((value) {
            if(this.mounted){
              itemsEsp = value;
              // print("profissionais = ${items.length}");

              print("itemsEsp = ${itemsEsp.length}");
              itemsEsp.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
            }
        });
      }

      if (itemsServProf.length==0){
         Provider.of<ServicoProfissionalProvider>(context, listen: false)
            .getListServicosProfissional().then((value) {
              if(this.mounted){
                itemsServProf = value;
                print("ServProf = ${itemsServProf.length}");
                setState((){});
              }
        });
      }

      if (itemsServ.length==0){
        Provider.of<ServicoProvider>(context, listen: false)
            .getListServicos().then((value) {
          if(this.mounted){
            itemsServ = value;
            print("itemsServ = ${itemsServ.length}");

            setState((){});
          }
        });
      }


      if (itemsEspProf.length==0){
        Provider.of<EspecialidadeProfissionalProvider>(context, listen: false)
            .getListEspecialidades().then((value) {
          if(this.mounted){
            itemsEspProf = value;
            print("itemsEspProf = ${itemsEspProf.length}");

            setState((){});
          }
        });
      }

      if (itemsDiasProf.length==0){
        Provider.of<DiasProfissionalProvider>(context, listen: false)
            .getListDiasProfissional().then((value) {
              if(this.mounted){
                itemsDiasProf = value;
                print("itemsDiasProf = ${itemsDiasProf.length}");

                setState((){});
              }
        });
      }

  }

  Especialidade getEspById(String id){
    Especialidade esp = Especialidade(descricao: "");
    itemsEsp.forEach((element) {
      if (element.id1==id){
        esp=  element;
      }
    });
    return esp;
  }

  String getNomeServicoById(String id){
    // String result ="";
    if (itemsServ.length>0){
      Servico nome = itemsServ.firstWhere((element) => element.id1==id);
      if (nome.id1!=null){
        return nome.descricao!;

      }
    }
      return "";
  }

  List<ServicosProfissional> getListServProf(String id){
    // print("iddd = $id");
    var result = itemsServProf.where((element) =>
        element.idProfissional!.compareTo(id)==0);
    // print("aaaa ${result.length}");
    return result.toList();
  }

  List<Especialidade> getListEspById(String id) {
    List<Especialidade> result = [];
    itemsEspProf.forEach((element) {
        if (element.idProfissional!.compareTo(id)==0){
          result.add(getEspById(element.idEspecialidade!));
        }
    });
    return result;
  }

  int getCountServProf(String id){
    int count =0;
    itemsServProf.forEach((element) {
      if(element.idProfissional!.compareTo(id)==0){
        count++;
      }
    });
    print("getCountServProf $id = $count");
    return count;
  }

  double getHeigth(String id){
    // print(getCountEspProf(id));
    // print(getCountServProf(id));
    int count = 0;
    print(id);
    if (getCountServProf(id)>getCountEspProf(id)){
      count = getCountServProf(id);
    } else {
      count = getCountEspProf(id);
    }
    double result = count*(MediaQuery.of(context).size.height*0.035)+(MediaQuery.of(context).size.height*0.15);
    return result;
  }

  double getHeigthSerEsp(String id){
    int count = 0;
    if (getCountServProf(id)>getCountEspProf(id)){
      count = getCountServProf(id);
      print("count 1 = $count");
    } else {
      count = getCountEspProf(id);
      print("count 2 = $count");
    }
    if (count==0) {
      count++;
    }
    if (count==0) {
      count=2;
    }
    double result = count*(MediaQuery.of(context).size.height*0.035)+(MediaQuery.of(context).size.height*0.05);;
    return result;
  }

  int indiceDia(String dia){
    switch(dia){
      case "SEGUNDA":
        return 1;
      case "TERÇA":
        return 2;
      case "QUARTA":
        return 3;
      case "QUINTA":
        return 4;
      case "SEXTA":
        return 5;
      case "SÁBADO":
        return 6;
      case "DOMINGO":
        return 7;
    }
    return 0;
  }

  List<String> getDiasTrabalhoProfissional(String id){
    List<String> lista = [];
    itemsDiasProf.forEach((element) {
        if(element.idProfissional!.compareTo(id)==0){
          lista.add(element.dia!);
        }
    });
    lista.sort((a,b)=>indiceDia(a).compareTo(indiceDia(b)));

    return lista;
  }

  int getCountEspProf(String id) {
    int count = 0;
    itemsEspProf.forEach((element) {
      if(element.idProfissional!.compareTo(id)==0){
        count++;
      }
    });
    if (count==0) {
      count++;
    }
    print("getCountEspProf $id = $count");
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

                    // width: size.width * 0.45,
                    width: size.width * 0.55,
                    height: size.height * 0.71,
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
                              //cabeçalho
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
                              //Especialidade
                              SizedBox(
                                width: size.width * 0.2,
                                height: size.height * 0.08,
                                child: Column(
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
                          height: size.height * 0.57,
                          width: size.width * 0.55,
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.0, right: 6.0),
                            child: ListView.builder(
                                itemCount: items.length,
                                controller: _scrollController,
                                itemBuilder: (context, index){

                                  return ((items.length>0)&&(itemsEsp.length>0))?
                                    Card(
                                    child: SizedBox(
                                      width: size.width * 0.44,
                                      height: size.height *0.15,
                                      child: Row(
                                        children: [
                                          //detalhes profissionais
                                          SizedBox(
                                              width: (size.width * 0.18),
                                              height: size.height *0.15,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 4.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    //nome
                                                    SizedBox(
                                                        width: (size.width * 0.19),
                                                        height: size.height *0.05,
                                                        child: FittedBox(
                                                          alignment: Alignment.centerLeft,
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(items[index].nome!,
                                                            style: AppTextStyles.labelBold16,),
                                                        )
                                                    ),
                                                    //especialidade
                                                    SizedBox(
                                                        width: size.width * 0.19,
                                                        height: size.height *0.03,
                                                        child: ListView.builder(
                                                            itemCount: getListEspById(items[index].id1).length,
                                                            itemBuilder: (context, index1){
                                                              List<Especialidade> esp = getListEspById(items[index].id1);
                                                              return Text("${esp[index1].descricao!} ",
                                                                style: AppTextStyles.subTitleBlack14,);
                                                            })
                                                    ),
                                                    //dias
                                                    Container(
                                                      // color: AppColors.red,
                                                        width: size.width * 0.19,
                                                        height: size.height *0.06,
                                                        child:
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                          SizedBox(
                                                          width: size.width * 0.19,
                                                          height: size.height *0.03,
                                                            child:  Row(
                                                              children: [
                                                                SizedBox(
                                                                    width: size.width * 0.02,
                                                                    height: size.height *0.03,
                                                                    child: FittedBox(
                                                                      fit: BoxFit.scaleDown,
                                                                      alignment: Alignment.centerLeft,
                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          List<DiasSalasProfissionais> listProf = [];
                                                                          List<DiasSalasProfissionais> listAll = [];

                                                                          Provider.of<DiasSalasProfissionaisProvider>(context, listen: false)
                                                                              .getListDiasSalasByProfissional(items[index].id1).then((value) {
                                                                             listProf = value;
                                                                             print(listProf.length);
                                                                             print("listProf.length");
                                                                             Provider.of<DiasSalasProfissionaisProvider>(context,listen: false)
                                                                                 .getList().then((value) {
                                                                               listAll = value;
                                                                               print(listAll.length);
                                                                               print("listAll.length");
                                                                               DialogsProfissional.AlertDialogCronograma(context, _uid,
                                                                                   listProf, listAll, itemsDiasProf, items[index], itemsServProf, itemsServ);
                                                                             });

                                                                          });

                                                                        },
                                                                        child: CircleAvatar(
                                                                          backgroundColor: AppColors.primaryColor,
                                                                          child: Icon(Icons.edit, color: AppColors.shape,),
                                                                        )
                                                                      )
                                                                    )
                                                                ),
                                                                SizedBox(
                                                                  width: size.width * 0.14,
                                                                  height: size.height *0.03,
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text("Atua nos dias:",style: AppTextStyles.subTitleBlack14,),
                                                                  )
                                                                ),
                                                                
                                                              ],
                                                            )
                                                          ),
                                                            SizedBox(
                                                              width: size.width * 0.19,
                                                              height: size.height *0.03,
                                                              child: FittedBox(
                                                                fit: BoxFit.contain,
                                                                alignment: Alignment.centerLeft,
                                                                child: Row(
                                                                  children: [
                                                                    for (var dias in getDiasTrabalhoProfissional(items[index].id1) )
                                                                      Text("${dias.substring(0,3)}  ", style: AppTextStyles.subTitleBlack14,),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        )

                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                          VerticalDivider(
                                            thickness: 2,
                                          ),
                                          //serviços profissionais
                                          SizedBox(
                                            width: (size.width * 0.403)/2+(size.width*0.1),
                                            height: size.height *0.2,
                                            child: ListView.builder(
                                              itemCount: getListServProf(items[index].id1).length,
                                              itemBuilder: (context,index1){
                                                List<ServicosProfissional> servProf = getListServProf(items[index].id1);
                                                servProf.sort((a,b)=> a.valor!.compareTo(b.valor!));
                                                return (itemsServProf.length==0) ?
                                                  Center()
                                                    :
                                                  Row(
                                                  children: [
                                                    SizedBox(
                                                      width: ((size.width * 0.403)/2)*0.8+(size.width*0.1),
                                                      height: size.height *0.03,
                                                      child: FittedBox(
                                                        alignment: Alignment.centerLeft,
                                                        fit: BoxFit.scaleDown,
                                                        child: Text("${getNomeServicoById(servProf[index1].idServico!)} ", style: AppTextStyles.subTitleBlack12,),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: ((size.width * 0.403)/2)*0.2,
                                                      height: size.height *0.03,
                                                      child: FittedBox(
                                                        alignment: Alignment.centerRight,
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(servProf[index1].valor!, style: AppTextStyles.subTitleBlack14,),
                                                      ),
                                                    ),
                                                  ],
                                                );

                                              },
                                            )

                                            // Column(
                                            //   children: [
                                            //     for (var item in getListServProf(items[index].id1))
                                            //       Row(
                                            //         children: [
                                            //           SizedBox(
                                            //             width: ((size.width * 0.403)/2)*0.8,
                                            //             height: size.height *0.03,
                                            //             child: FittedBox(
                                            //               alignment: Alignment.centerLeft,
                                            //               fit: BoxFit.scaleDown,
                                            //               child: Text(getNomeServicoById(item.idServico!)),
                                            //             ),
                                            //           ),
                                            //           SizedBox(
                                            //             width: ((size.width * 0.403)/2)*0.2,
                                            //             height: size.height *0.03,
                                            //             child: FittedBox(
                                            //               fit: BoxFit.scaleDown,
                                            //               child: Text(item.valor!),
                                            //             ),
                                            //           )
                                            //         ],
                                            //
                                            //       )
                                            //   ],
                                            // ),

                                          //----------
                                            // child:
                                            // ListView.builder(
                                            //       itemCount: getListServProf(items[index].id1).length,
                                            //       itemBuilder: (context, index1){
                                            //         List<ServicosProfissional> servProf = getListServProf(items[index].id1);
                                            //         return Row(
                                            //           children: [
                                            //             Container(
                                            //               color: Colors.blue,
                                            //               width: ((size.width * 0.37)/2)*0.8,
                                            //               height: size.height *0.05,
                                            //               child: FittedBox(
                                            //                 fit: BoxFit.scaleDown,
                                            //                 child: Text(getNomeServicoById(servProf[index1].idServico!)),
                                            //               ),
                                            //             ),
                                            //             Container(
                                            //               color: Colors.red,
                                            //               width: ((size.width * 0.37)/2)*0.2,
                                            //               height: size.height *0.05,
                                            //               child: FittedBox(
                                            //                 fit: BoxFit.scaleDown,
                                            //                 child: Text(servProf[index1].valor!,style: AppTextStyles.subTitleBlack14,)
                                            //
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         );
                                            //       })
                                          ),
                                          //botão
                                          SizedBox(
                                              width: (size.width * 0.03),
                                              height: size.height *0.1,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child:  InkWell(
                                                  onTap: ()async{
                                                   await DialogsProfissional.AlertAlterarProfissional(
                                                        context, _uid, items[index], getListServProf(items[index].id1), getListEspById(items[index].id1),
                                                        itemsServ);
                                                  },
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    alignment: Alignment.topRight,
                                                    child: Icon(
                                                      Icons.edit_rounded,
                                                      color: AppColors.labelBlack.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              )

                                            // Column(
                                            //   children: [
                                            //     for (var item in getListServProf(items[index].id1))
                                            //       Row(
                                            //         children: [
                                            //           SizedBox(
                                            //             width: ((size.width * 0.403)/2)*0.8,
                                            //             height: size.height *0.03,
                                            //             child: FittedBox(
                                            //               alignment: Alignment.centerLeft,
                                            //               fit: BoxFit.scaleDown,
                                            //               child: Text(getNomeServicoById(item.idServico!)),
                                            //             ),
                                            //           ),
                                            //           SizedBox(
                                            //             width: ((size.width * 0.403)/2)*0.2,
                                            //             height: size.height *0.03,
                                            //             child: FittedBox(
                                            //               fit: BoxFit.scaleDown,
                                            //               child: Text(item.valor!),
                                            //             ),
                                            //           )
                                            //         ],
                                            //
                                            //       )
                                            //   ],
                                            // ),

                                            //----------
                                            // child:
                                            // ListView.builder(
                                            //       itemCount: getListServProf(items[index].id1).length,
                                            //       itemBuilder: (context, index1){
                                            //         List<ServicosProfissional> servProf = getListServProf(items[index].id1);
                                            //         return Row(
                                            //           children: [
                                            //             Container(
                                            //               color: Colors.blue,
                                            //               width: ((size.width * 0.37)/2)*0.8,
                                            //               height: size.height *0.05,
                                            //               child: FittedBox(
                                            //                 fit: BoxFit.scaleDown,
                                            //                 child: Text(getNomeServicoById(servProf[index1].idServico!)),
                                            //               ),
                                            //             ),
                                            //             Container(
                                            //               color: Colors.red,
                                            //               width: ((size.width * 0.37)/2)*0.2,
                                            //               height: size.height *0.05,
                                            //               child: FittedBox(
                                            //                 fit: BoxFit.scaleDown,
                                            //                 child: Text(servProf[index1].valor!,style: AppTextStyles.subTitleBlack14,)
                                            //
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         );
                                            //       })
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  :
                                    CircularProgressIndicator();
                                }),
                          )

                          // SingleChildScrollView(
                          //   controller: _scrollController,
                          //   child: Scrollbar(
                          //     controller: _scrollController,
                          //     thumbVisibility: true,
                          //     trackVisibility: true,
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                          //       child:
                          //         Column(
                          //         children: [
                          //
                          //
                                    // if (items.length>0)
                                    // for (var item in items)
                                    //   Row(
                                    //     children: [
                                    //       //imagem
                                    //       Card(
                                    //         elevation: 8,
                                    //         child: Container(
                                    //           width: size.width * 0.05,
                                    //           height: size.width * 0.05,
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(6.0),
                                    //             color: AppColors.labelWhite
                                    //           ),
                                    //           child: FittedBox(
                                    //             fit: BoxFit.contain,
                                    //             child: Icon(
                                    //                 color: AppColors.labelBlack.withOpacity(0.5),
                                    //                 Icons.person),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       //informações
                                    //       Container(
                                    //         width: size.width * 0.38,
                                    //         height: getHeigth(item.id1),
                                    //         child: Card(
                                    //           elevation: 8,
                                    //           child: ListTile(
                                    //             trailing: Icon(Icons.edit_rounded),
                                    //             title: Column(
                                    //               crossAxisAlignment: CrossAxisAlignment.start,
                                    //               children: [
                                    //                 FittedBox(
                                    //                   fit: BoxFit.scaleDown,                                        //
                                    //                   child: Text(item.nome.toString(), style: AppTextStyles.labelBlack16Lex,)),
                                    //                 Divider(),
                                    //                 Row(
                                    //                   children: [
                                    //                     //ESPECIALIDADES
                                    //                     Padding(
                                    //                       padding: const EdgeInsets.only(right: 15.0),
                                    //                       child: Container(
                                    //                         height: getHeigthSerEsp(item.id1),
                                    //                         width: size.width * 0.15,
                                    //                         decoration: BoxDecoration(
                                    //                           // color: AppColors.red,
                                    //                           border: Border.all(color: AppColors.line)
                                    //                         ),
                                    //                         child: Padding(
                                    //                           padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                                    //                           child: Column(
                                    //                             crossAxisAlignment: CrossAxisAlignment.start,
                                    //                             children: [
                                    //                               Text("Especialidades:", style: AppTextStyles.labelBlack14Lex,),
                                    //                               Divider(
                                    //                                 color: AppColors.line,
                                    //                               ),
                                    //                               for (var items in getListEspById(item.id1))
                                    //                                 FittedBox(
                                    //                                     fit: BoxFit.scaleDown,
                                    //                                     child: Text(items.descricao!, style: AppTextStyles.labelBlack12Lex,))
                                    //                             ],
                                    //                           ),
                                    //                         ),
                                    //
                                    //                       ),
                                    //                     ),
                                    //
                                    //                     // SERVIÇOS
                                    //                     Padding(
                                    //                       padding: const EdgeInsets.only(left: 15.0),
                                    //                       child: Container(
                                    //                         height: getHeigthSerEsp(item.id1),
                                    //                         width: size.width * 0.15,
                                    //                         decoration: BoxDecoration(
                                    //                           border: Border.all(color: AppColors.line)
                                    //                         ),
                                    //                         // color: AppColors.green,
                                    //                         child: Padding(
                                    //                           padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                    //                           child: Column(
                                    //                             crossAxisAlignment: CrossAxisAlignment.start,
                                    //                             children: [
                                    //                               Text("Serviços Ofertados:",style: AppTextStyles.labelBlack14Lex,),
                                    //                               Divider(
                                    //                                 color: AppColors.line,
                                    //                               ),
                                    //                               for (var items in getListServProf(item.id1))
                                    //                                 Row(
                                    //                                   mainAxisAlignment: MainAxisAlignment.start,
                                    //                                   children: [
                                    //                                     SizedBox(
                                    //                                       width: size.width * 0.1,
                                    //                                       height: size.height*0.025,
                                    //                                       child: Padding(
                                    //                                         padding: const EdgeInsets.only(right: 3.0),
                                    //                                         child: FittedBox(
                                    //                                             fit: BoxFit.scaleDown,
                                    //                                             alignment: Alignment.centerLeft,
                                    //                                             child: Text(getNomeServicoById(items.idServico!), style: AppTextStyles.labelBlack12Lex,)),
                                    //                                       ),
                                    //                                     ),
                                    //
                                    //                                     SizedBox(
                                    //                                       width: size.width * 0.04,
                                    //                                       height: size.height*0.025,
                                    //
                                    //                                       child: FittedBox(
                                    //                                           fit: BoxFit.scaleDown,
                                    //                                           child: Text("R\$ ${items.valor!}")),
                                    //                                     ),
                                    //                                   ],
                                    //                                 )
                                    //
                                    //                             ],
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                     )
                                    //                   ],
                                    //                 ),
                                    //
                                    //
                                    //               ],
                                    //             ),
                                    //
                                    //           )
                                    //         ),
                                    //       )
                                    //     ],
                                    //   )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
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

                  // Provider.of<ProfissionalProvider>(context, listen: false).setListProfissional(items);
                  Navigator.pushReplacementNamed(
                      context, "/cadastro_profissional");
                },
              ),
            ],
          ),
        )));
  }



}
