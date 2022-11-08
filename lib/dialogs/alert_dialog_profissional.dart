import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/especialidade_profissional_provider.dart';
import 'package:psico_sis/provider/especialidade_provider.dart';
import 'package:psico_sis/provider/log_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/widgets/button_widget.dart';
import 'package:psico_sis/widgets/input_text_uper_widget.dart';
import 'package:psico_sis/widgets/input_text_widget_mask.dart';
import '../model/Especialidade.dart';
import '../model/Profissional.dart';
import '../model/especialidades_profissional.dart';
import '../model/log_sistema.dart';
import '../model/login.dart';
import '../model/servico.dart';
import '../model/servicos_profissional.dart';
import '../provider/login_provider.dart';
import '../provider/servico_profissional_provider.dart';
import '../service/authenticate_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/button_disable_widget.dart';

class DialogsProfissional {
  //CONFIRMAR DADOS PROFISSIONAL
  static Future<void> AlertDialogConfirmarProfissional(
      parentContext, String uid, Profissional profissional) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: SizedBox(
            width: MediaQuery
                .of(parentContext)
                .size
                .width * 0.6,
            height: MediaQuery
                .of(parentContext)
                .size
                .height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Confirme os dados do Profissional"),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                //nome
                Row(
                  children: [
                    Text("Nome: "),
                    Text("${profissional.nome}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Email: "),
                    Text("${profissional.email}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Data nascimento: "),
                    Text("${profissional.dataNascimento}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Endereço: "),
                    Text("${profissional.endereco}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Número: "),
                    Text("${profissional.numero}"),
                  ],
                ),
                Row(
                  children: [
                    Text("CPF: "),
                    Text("${profissional.cpf}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Telefone: "),
                    Text("${profissional.telefone}"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[

            ButtonWidget(
                onTap: (){
                    DialogsProfissional.AlertDialogConfirmarEspecialidadeProfissional(
                    parentContext, uid, profissional);
                  },
                label: "Avançar >>",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.065,),
            ButtonWidget(
              onTap: (){
                Navigator.pop(parentContext);
              },
              label: "Cancelar >>",
              width: MediaQuery.of(context).size.width * 0.07,
              height: MediaQuery.of(context).size.height * 0.065,),
          ],
        );
      },
    );
  }

  //ADICIONA ESPECIALIDADES AO PROFISSIONAL
  static Future<void> AlertDialogConfirmarEspecialidadeProfissional(
      parentContext, String uid, Profissional profissional) async {

    List<Especialidade> _listAdd = [];
    List<String> _listCodigo = [];
    String _codigoProfissional = "";
    List<Especialidade> _listEsp = [];
    var controller = TextEditingController();
    await Provider.of<EspecialidadeProvider>(parentContext, listen: false)
        .getListEspecialidades1()
        .then((value) {
      _listEsp = value;
      _listEsp.sort(
          (a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
    });

    String dropdown = _listEsp.first.descricao!;
    List<DropdownMenuItem<String>> getDropdownEspecialidades(
        List<Especialidade> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].descricao.toString(),
          child: Text(list[i].descricao.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    return showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context1, setState) => AlertDialog(
            title: Column(
              children: [
                // Text("Adicione uma Especialidade ao Profissional"),
                Divider(
                  thickness: 2,
                ),
                //nome
                Row(
                  children: [
                    Text("Nome: "),
                    Text("${profissional.nome}"),
                  ],
                ),
                //email
                Row(
                  children: [
                    Text("Email: "),
                    Text("${profissional.email}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Data nascimento: "),
                    Text("${profissional.dataNascimento}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Endereço: "),
                    Text("${profissional.endereco}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Número: "),
                    Text("${profissional.numero}"),
                  ],
                ),
                Row(
                  children: [
                    Text("CPF: "),
                    Text("${profissional.cpf}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Telefone: "),
                    Text("${profissional.telefone}"),
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Adicione ao menos uma especialidade: "),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(parentContext).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.labelWhite),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DropdownButton<String>(
                                value: dropdown,
                                icon: const Icon(Icons.arrow_drop_down_sharp),
                                elevation: 16,
                                style: TextStyle(color: AppColors.labelBlack),
                                underline: Container(
                                  height: 2,
                                  color: AppColors.line,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdown = newValue!;
                                  });
                                },
                                items: getDropdownEspecialidades(_listEsp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(parentContext).size.width * 0.2,
                      child: InputTextUperWidget(
                        label: "CÓDIGO (OPCIONAL)",
                        controller: controller,
                        icon: Icons.onetwothree,
                        validator: (value) {
                          return null;
                        },
                        onChanged: (value) {
                          _codigoProfissional = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle: AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,
                      ),
                    ),
                    InkWell(
                      onTap: () async{
                        Especialidade esp = await Provider.of<EspecialidadeProvider>(
                                parentContext,
                                listen: false)
                            .getEspByDesc(dropdown, _listEsp);
                        print("erro");

                          if (_listAdd.contains(esp) == false) {
                            _listAdd.add(esp);
                            if (_codigoProfissional.compareTo("") != 0) {
                              print("add");
                              _listCodigo.add(_codigoProfissional);
                              _codigoProfissional = "";
                              controller.clear();
                            } else {
                              print("entrou add");
                              _listCodigo.add("");
                            }
                          }


                        setState(() {});
                      },
                      child: Icon(
                          color: AppColors.primaryColor,
                          size: 45, Icons.add_circle),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(parentContext).size.width * 0.6,
                  height: MediaQuery.of(parentContext).size.height * 0.3,
                  child: ListView.builder(
                      itemCount: _listAdd.length,
                      itemBuilder: (context,index){
                        return Row(
                          children: [
                            Text("Especialidade ${index + 1}:"),
                            Text(
                              " ${_listAdd[index].descricao}",
                              style: AppTextStyles.labelBlack16Lex,
                            ),
                            Text(
                              " ${_listCodigo[index]}",
                              style: AppTextStyles.labelBlack16Lex,
                            ),
                          ],
                        );
                      }),
                ),
                // Column(
                //   children: [
                //     for (int i = 0; i < _listAdd.length; i++)
                //       Row(
                //         children: [
                //           Text("Especialidade ${i + 1}:"),
                //           Text(
                //             " ${_listAdd[i].descricao}",
                //             style: AppTextStyles.labelBlack16Lex,
                //           ),
                //           Text(
                //             " ${_listCodigo[i]}",
                //             style: AppTextStyles.labelBlack16Lex,
                //           ),
                //         ],
                //       )
                //   ],
                // )
              ],
            ),
            actions: <Widget>[
              ButtonWidget(
                onTap: () async {
                  if (_listAdd.length>0){
                    List<DiasSalasProfissionais> _listOcupados = [];
                    await Provider.of<DiasSalasProfissionaisProvider>
                      (context, listen: false).getListOcupadas().then((value) {
                      _listOcupados = value;
                    });
                    print(_listAdd.length);
                    List<EspecialidadeProfissional> listEspProf=[];
                    for (int i =0; i<_listAdd.length; i++){
                      listEspProf.add(EspecialidadeProfissional(
                          codigoEspecialidade: _listCodigo[i],
                          idEspecialidade: _listAdd[i].idEspecialidade
                      ));
                    }
                    DialogsProfissional.AlertCadastroServicosProfissional(parentContext,
                       uid, _listOcupados, profissional,listEspProf, _listAdd, _listCodigo);
                  }
                },
                label: "Avançar >>",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.065,),

              ButtonWidget(
                onTap: () async {
                  Navigator.pop(parentContext);
                },
                label: "Cancelar >>",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.065,),
            ],
          ),
        );
      },
    );
  }

  //HORARIO PROFISSIONAL
  static Future<void> AlertDialogConfirmarDiasProfissional(
      parentContext, String uid, List<DiasSalasProfissionais> listOcupados,
      Profissional profissional, List<ServicosProfissional> servicosProfissional,
      List<EspecialidadeProfissional> especialidadesProfissional,
      List<Especialidade> especialidades, List<String> listCodigos,
      List<Servico> servicos, List<String> valoresServico) async {
    print("ocupados ${listOcupados.length}");
    print("nome ${profissional.nome}");
    print("especialidades ${especialidades.length}");
    print("especialidades ${especialidades[0].descricao}");
    print("servico ${servicos[0].descricao}");
    String _selectDay = "SEGUNDA";
    int jota = 12;
    List<DiasSalasProfissionais> _listSelectDay = [];
    final ScrollController _scrollController = ScrollController();
    //HORARIO SÁBADO
    final List<String> _listSabado = [
      "07:00",
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "12:00",
      "13:00",
    ];
    //HORARIO SEMANA
    final List<String> _listHoras = [
      "07:00",
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "12:00",
      "13:00",
      "14:00",
      "15:00",
      "16:00",
      "17:00",
      "18:00",
      // "19:00"
    ];
    List<bool> _listDias = [
      true,
      false,
      false,
      false,
      false,
      false,
    ];

    List<bool> _listSalas = [
      false,
      false,
      false,
      false,
      false,
      false,
    ];
    List<String> _listDescSalas = [
      "SALA 01",
      "SALA 02",
      "SALA 03",
      "SALA 04",
      "SALA 05",
      "SALA 06",
    ];
    List<String> _dias = [
      "SEGUNDA",
      "TERÇA",
      "QUARTA",
      "QUINTA",
      "SEXTA",
      "SÁBADO",
      "DOMINGO",
    ];


    //retorna se o profissional ja possui algum slot com aquele mesmo horario
    bool containHoursBusy(int j){
      bool result = false;
      _listSelectDay.forEach((element) {
        if ((element.dia?.compareTo(_selectDay)==0) &&
            (element.hora?.compareTo(_listHoras[j])==0)){
          result = true;
        }
      });
      return result;
    }

    bool busySelect(int i, int j){
      bool result = false;
      _listSelectDay.forEach((element) {
        if ((element.sala?.compareTo(_listDescSalas[i])==0)&&
            (element.hora?.compareTo(_listHoras[j])==0) &&
            (element.dia?.compareTo(_selectDay)==0)){
          result = true;
        }
      });
      return result;
    }

    bool busy(int i, int j) {
      bool result = false;
      listOcupados.forEach((element) {
        if ((element.sala?.compareTo(_listDescSalas[i]) == 0) &&
            (element.dia?.compareTo(_selectDay) == 0) &&
            (element.hora?.compareTo(_listHoras[j]) == 0)) {
          result = true;
        }
      });
      return result;
    }

    DiasSalasProfissionais? getDay(String day, int i, int j,
        List<DiasSalasProfissionais> list) {
      DiasSalasProfissionais? dias;
      for (var value in list) {
        if ((value.dia?.compareTo(day)==0) &&
            (value.hora?.compareTo(_listHoras[j])==0) &&
            (value.sala?.compareTo(_listDescSalas[i])==0)
        ){
          dias = value;
        }
      }
      return dias;
    }

    int getIndexDia(String? dia) {
      switch (dia) {
        case 'DOMINGO':
          {
            return 7;
          }
        case 'SEGUNDA':
          {
            return 1;
          }
        case 'TERÇA':
          {
            return 2;
          }
        case 'QUARTA':
          {
            return 3;
          }
        case 'QUINTA':
          {
            return 4;
          }
        case 'SEXTA':
          {
            return 5;
          }
        case 'SÁBADO':
          {
            return 6;
          }
    }

      return -1;
    }

    Future<String?>getNome(int i, int j) async {
      int idProfissional = 0;
      String? nomeProfissional = "";
      listOcupados.forEach((element) {
        if ((element.sala?.compareTo(_listDescSalas[i]) == 0) &&
            (element.dia?.compareTo(_selectDay) == 0) &&
            (element.hora?.compareTo(_listHoras[j]) == 0)) {
          idProfissional = element.idProfissional!;
        }
      });

      await Provider.of<ProfissionalProvider>(parentContext, listen: false)
          .getProfById(idProfissional.toString())
          .then((value) {
        // nomeProfissional = value?.nome;
        print(value?.nome);
        print('nome Profissional $nomeProfissional');
        if (value != null){
          String profissional = value.nome!;
          // retorna o primeiro nome
          for (int i =0; i< profissional.length; i++){
            if (profissional.substring(i,i+1).compareTo(" ")==0){
              break;
            } else {
              nomeProfissional="$nomeProfissional${value.nome?.substring(i,i+1)}";
            }
          }
        }

        print('nome Profissional $nomeProfissional');
      });


      return nomeProfissional;
    }


    return showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: SizedBox(
              width: MediaQuery.of(parentContext).size.width * 0.9,
              height: MediaQuery.of(parentContext).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                          "Selecione os dias e horários que o Profissional irá atuar. ")),
                  Divider(
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          //list horas
                          Container(
                            height:
                                MediaQuery.of(parentContext).size.height * 0.06,
                            width:
                                MediaQuery.of(parentContext).size.width * 0.718,
                            // color: AppColors.blue,
                            child: Row(
                              children: [
                                Card(
                                  elevation: 8,
                                  color: AppColors.line,
                                  child: Container(
                                    width: MediaQuery.of(parentContext)
                                            .size
                                            .width *
                                        0.114,
                                    height: MediaQuery.of(parentContext)
                                            .size
                                            .height *
                                        0.06,
                                    child: Center(
                                        child: Text(
                                      _selectDay,
                                      style: AppTextStyles.labelBlack16Lex,
                                    )),
                                  ),
                                ),
                                for (int i = 0; i < jota; i++)
                                  Column(
                                    children: [
                                      Card(
                                        elevation: 8,
                                        color: ((i % 2) != 0)
                                            ? AppColors.shape
                                            : AppColors.labelWhite,
                                        child: Container(
                                          width: MediaQuery.of(parentContext)
                                                  .size
                                                  .width *
                                              0.04,
                                          height: MediaQuery.of(parentContext)
                                                  .size
                                                  .height *
                                              0.045,
                                          child: Center(
                                              child: Text(
                                            _listHoras[i],
                                            style:
                                                AppTextStyles.labelBlack16Lex,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          //Salas e agenda
                          Container(
                            height: MediaQuery.of(parentContext).size.height *
                                0.465,
                            width:
                                MediaQuery.of(parentContext).size.width * 0.718,
                            // color: AppColors.green,
                            child: Row(
                              children: [
                                //salas
                                Container(
                                  height:
                                      MediaQuery.of(parentContext).size.height *
                                          0.465,
                                  width:
                                      MediaQuery.of(parentContext).size.width *
                                          0.12,
                                  // color: AppColors.shape,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: 6,
                                      itemBuilder: (context, index) {
                                        return Card(
                                            elevation: 8,
                                            color: _listSalas[index]
                                                ? AppColors.line
                                                : AppColors.green,
                                            child: SizedBox(
                                                height:
                                                    MediaQuery.of(parentContext)
                                                            .size
                                                            .height *
                                                        0.065,
                                                width:
                                                    MediaQuery.of(parentContext)
                                                            .size
                                                            .width *
                                                        0.07,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .door_back_door_outlined,
                                                      color:
                                                          AppColors.labelBlack,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 6.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          "${_listDescSalas[index]}",
                                                          style: AppTextStyles
                                                              .subTitleBlack14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )));
                                      }),
                                ),

                                //horários
                                Container(
                                  height:
                                      MediaQuery.of(parentContext).size.height *
                                          0.465,
                                  width:
                                      MediaQuery.of(parentContext).size.width *
                                          0.598,
                                  // color: AppColors.red,
                                  child: Column(
                                    children: [
                                      //horários dos dias da semana
                                      for (int i = 0; i < 6; i++)
                                        Row(
                                          children: [
                                            for (int j = 0; j < jota; j++)
                                             busy(i, j) ?
                                                 //card ocupado
                                                Card(
                                                  color: AppColors.red,
                                                  child: SizedBox(
                                                    width: MediaQuery.of(
                                                                parentContext)
                                                            .size
                                                            .width *
                                                        0.04,
                                                    height: MediaQuery.of(
                                                                parentContext)
                                                            .size
                                                            .height *
                                                        0.065,
                                                    child: Center(
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 3.0,
                                                                      right:
                                                                          3.0),
                                                              child: Column(
                                                                children: [
                                                                  Text("OCUPADO"),
                                                                  FutureBuilder(
                                                                      future: getNome(i, j),
                                                                      builder: (BuildContext parentContext, AsyncSnapshot snapshot) {
                                                                        if (snapshot.hasData) {
                                                                          return Text(snapshot.data);
                                                                        }else {
                                                                          return Center(
                                                                            child: Text("")
                                                                          );
                                                                        }

                                                                      }),
                                                                  // Text(
                                                                  //     "nome"),
                                                                ],
                                                              ),
                                                            ))),
                                                  ),
                                                ) :
                                                 busySelect(i, j)?
                                                 //card selecionado
                                                 InkWell(
                                                   onTap: (){
                                                     // getSelectDay(i,j)
                                                     if (getDay(_selectDay, i, j, _listSelectDay)!=null){
                                                       _listSelectDay.remove(getDay(_selectDay, i, j, _listSelectDay));
                                                       setState((){});
                                                     }

                                                   },
                                                   child: Card(
                                                     elevation: 8,
                                                     color: AppColors.primaryColor,
                                                     child: SizedBox(
                                                         width: MediaQuery.of(parentContext).size.width * 0.04,
                                                         height: MediaQuery.of(parentContext).size.height * 0.065,
                                                         child: Center(child: Icon(
                                                             Icons.check_circle,
                                                           color: AppColors.labelWhite,
                                                         ))),
                                                   ),
                                                 ) :
                                               //card hora livre
                                               InkWell(
                                                 onTap: (){
                                                   if (containHoursBusy(j)){

                                                   } else {
                                                     _listSelectDay.add(
                                                         DiasSalasProfissionais(
                                                             dia: _selectDay,
                                                             hora: _listHoras[j],
                                                             sala: _listDescSalas[i]
                                                         )
                                                     );
                                                     // _listEsp.sort(
                                                     //         (a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
                                                     _listSelectDay.sort(
                                                             (a,b) {
                                                               if (a.dia! == b.dia!) {
                                                                 // if (getIndex(a.dia)<)
                                                                 print("${b.hora!}.compareTo(${a.hora!}))");
                                                                 print(b.hora!.compareTo(a.hora!));

                                                                 print("${a.hora!}.compareTo(${b.hora!}))");
                                                                 print(a.hora!.compareTo(b.hora!));
                                                                 return a.hora!.compareTo(b.hora!);
                                                               } else {
                                                                  if(getIndexDia(a.dia)<getIndexDia(b.dia)){
                                                                     return -1;
                                                                  } else {
                                                                    return 1;
                                                                  }

                                                               }
                                                             }

                                                     );
                                                     setState((){});
                                                   }


                                                 },
                                                 child: Card(
                                                   elevation: 8,
                                                   color: ((i % 2) != 0) ? AppColors.shape : AppColors.labelWhite,
                                                   child: SizedBox(
                                                       width: MediaQuery.of(parentContext).size.width * 0.04,
                                                       height: MediaQuery.of(parentContext).size.height * 0.065,
                                                       child: Center(child:
                                                       Text(_listHoras[j],
                                                         style: AppTextStyles.labelBold16,))),
                                                 ),
                                               ),


                                            // for (int j=0; j<13;j++)
                                            //   getWidget(context,i,j),
                                          ],
                                        )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      //lista cards horários selecionados
                      Container(
                        height:
                            MediaQuery.of(parentContext).size.height * 0.525,
                        width: MediaQuery.of(parentContext).size.width * 0.18,
                        // color: AppColors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                                  child: Text("HORÁRIOS SELECIONADOS", style: AppTextStyles.labelBlack14Lex,),
                                )),
                            //lista cards dias selecionados
                            Card(
                              elevation: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.labelWhite,
                                  borderRadius: BorderRadius.circular(3.0)
                                ),
                                height:
                                MediaQuery.of(parentContext).size.height * 0.475,
                                width: MediaQuery.of(parentContext).size.width * 0.18,
                                child: Scrollbar(
                                  controller: _scrollController,
                                  thumbVisibility: true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: _listSelectDay.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 10.0),
                                          child: Card(
                                            elevation: 8,
                                            color: AppColors.labelWhite,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    // width: MediaQuery.of(parentContext).size.width * 0.18,
                                                    Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: SizedBox(
                                                          width: MediaQuery.of(parentContext).size.width * 0.03,
                                                          child: FittedBox(
                                                              fit: BoxFit.contain,
                                                              child: Text(_listSelectDay[index].hora!))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: SizedBox(
                                                          width: MediaQuery.of(parentContext).size.width * 0.05,
                                                          child: FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text(_listSelectDay[index].dia!))),
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(parentContext).size.width * 0.04,
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(_listSelectDay[index].sala!))),
                                                    SizedBox(
                                                        width: MediaQuery.of(parentContext).size.width * 0.02,
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: InkWell(
                                                                onTap: (){
                                                                  _listSelectDay.removeAt(index);
                                                                  setState((){});
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: Icon(Icons.delete),
                                                                ))))
                                                  ],
                                                ),


                                              ],
                                            )
                                          ),
                                        );
                                      }

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  //lista com os botões dos dias da semana
                  Center(
                    child: Container(
                      height: MediaQuery.of(parentContext).size.height * 0.08,
                      width: MediaQuery.of(parentContext).size.width * 0.464,
                      // color: AppColors.green,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              for (int i = 0; i < 6; i++) {
                                _listDias[i] = false;
                              }
                              _listDias[index] = true;
                              _selectDay = _dias[index];
                              if(_selectDay.compareTo("SÁBADO")==0){
                                jota = 7;
                              } else {
                                jota = 12;
                              }
                              setState(() {});
                            },
                            child: Card(
                              elevation: 8,
                              color: _listDias[index]
                                  ? AppColors.line
                                  : AppColors.green,
                              child: Container(
                                height:
                                    MediaQuery.of(parentContext).size.height *
                                        0.08,
                                width:
                                    MediaQuery.of(parentContext).size.height *
                                        0.15,
                                child: Center(
                                    child: Text(
                                  _dias[index],
                                  style: AppTextStyles.labelBlack16Lex,
                                )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              ButtonWidget(
                onTap: () async {
                  if (_listSelectDay.length>0){
                    DialogsProfissional.AlertConfirmarCadastroProfissional(parentContext,
                        uid,listOcupados,profissional, servicosProfissional,especialidadesProfissional, especialidades, listCodigos, servicos, valoresServico, _listSelectDay);
                  }

                },
                label: "Avançar >>",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.065,),
              ButtonWidget(
                onTap: () {
                  Navigator.pop(parentContext);
                },
                label: "Cancelar >>",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.065,),
              // SimpleDialogOption(child: Text("Avançar >>"), onPressed: () async {
              //
              //   //checa se existe algum dia selecionado.
              //   if (_listSelectDay.length>0){
              //     print("Entrou aaa");
              //     // List<Servico> listServ = [];
              //     // await Provider.of<ServicoProvider>(parentContext, listen: false)
              //     //   .getListServicos1().then((value) {
              //     //   print("Entrou bbb ");
              //     //
              //     //   listServ=value;
              //     //   //  items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
              //     //     listServ.sort((a,b)=> a.descricao.toString().compareTo(b.descricao.toString()));
              //     //   });
              //     // print("Entrou ccc");
              //
              //     // Navigator.pop(parentContext);
              //     print("selectDay.length ${_listSelectDay.length}");
              //     _listSelectDay.forEach((element) {
              //       print("selectDay.length ${element.sala}");
              //
              //     });
              //     DialogsProfissional.AlertConfirmarCadastroProfissional(parentContext,
              //         listOcupados,profissional, especialidades, listCodigos, servicos, valoresServico, _listSelectDay);
              //
              //     // int id = 0;
              //     // //salvar profissional
              //     // await Provider.of<ProfissionalProvider>
              //     //     (parentContext, listen: false).putInt(profissional).then((value) => id = value);
              //     //
              //     //
              //     // for (int i =0; i<especialidades.length; i++){
              //     //   await Provider.of<EspecialidadeProfissionalProvider>
              //     //     (parentContext, listen: false).put(EspecialidadeProfissional(
              //     //     idProfissional: id,
              //     //     idEspecialidade: especialidades[i].idEspecialidade,
              //     //     codigoEspecialidade: listCodigos[i]
              //     //   ));
              //     // }
              //     //
              //     // //insere item dos dias selecionados
              //     // for (int i=0; i<_listSelectDay.length; i++){
              //     //   if (_listSelectDay[i].idProfissional==null){
              //     //     print("entrou se __listSelectDay $i + $id");
              //     //     _listSelectDay[i].idProfissional = id;
              //     //   } else {
              //     //     print("saiu se __listSelectDay $i + $id");
              //     //     print("idProf =${_listSelectDay[i].idProfissional}");
              //     //   }
              //     //  await Provider.of<DiasSalasProfissionaisProvider>(
              //     //       parentContext,
              //     //       listen: false)
              //     //       .put(_listSelectDay[i]);
              //     // }
              //     //
              //     // listOcupados.addAll(_listSelectDay);
              //     // _listSelectDay.clear();
              //     // setState((){});
              //
              //   }
              //   //else showSnackbar...
              //
              // }),
              // SimpleDialogOption(
              //     child: Text("Cancelar"),
              //     onPressed: () {
              //       Navigator.pop(parentContext);
              //     }),
            ],
          ),
        );
      },
    );
  }

  static Future<void> AlertCadastroServicosProfissional(
      parentContext, String uid, List<DiasSalasProfissionais> listOcupados,
      Profissional profissional, List<EspecialidadeProfissional> especialidadesProfissional, List<Especialidade> especialidades,
      List<String> listCodigos
      ) async{
    final _form = GlobalKey<FormState>();
    List<ServicosProfissional> _listServProf = [];
    List<Servico> _listServ = [];
    await Provider.of<ServicoProvider>(parentContext, listen: false)
        .getListServicos1()
        .then((value) {
      _listServ = value.cast<Servico>();
      _listServ.sort(
              (a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
    });

    String dropdown = _listServ.first.descricao!;
    String valor = "0";
    List<String> valoresServico = [];
    List<Servico> servSelecionados = [];
    var controller = TextEditingController();


    Servico getServicoByDesc(String desc, List<Servico> listServ){
          Servico servico = Servico(qtd_pacientes: 0, qtd_sessoes: 0);
          listServ.forEach((element) {
            if (element.descricao?.compareTo(desc)==0){
              servico = element;
            }
          });
          return servico;
    }

    List<DropdownMenuItem<String>> getDropdownServicos(
        List<Servico> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].descricao.toString(),
          child: Text(list[i].descricao.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }
    print("Entrou servico");
    especialidades.forEach((element) {
      print(element.descricao);
    });

    return showDialog(
      context: parentContext,
      builder: (context){
        return StatefulBuilder(builder: (context, setState) =>
          AlertDialog(
            title: SizedBox(
              width: MediaQuery
                  .of(parentContext)
                  .size
                  .width * 0.9,
              height: MediaQuery
                  .of(parentContext)
                  .size
                  .height * 0.7,
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Center(
                        child: Text(
                            "Adicione os SERVIÇOS do profissional!")),
                    Divider(
                      thickness: 2,
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(parentContext).size.width * 0.31,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.labelWhite),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DropdownButton<String>(
                                    value: dropdown,
                                    icon: const Icon(Icons.arrow_drop_down_sharp),
                                    elevation: 16,
                                    style: TextStyle(color: AppColors.labelBlack),
                                    underline: Container(
                                      height: 2,
                                      color: AppColors.line,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdown = newValue!;
                                      });
                                    },
                                    items: getDropdownServicos(_listServ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(parentContext).size.width * 0.2,
                          child: InputTextWidgetMask(
                            controller: controller,
                            // initalValue: valor,
                            label: "Valor",
                            icon: Icons.onetwothree,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Insira um valor';
                              }
                              if (servSelecionados.contains(getServicoByDesc(dropdown, _listServ))){
                                return 'Serviço já cadastrado';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              valor = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle: AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,
                            input: CentavosInputFormatter(),
                          ),
                        ),
                        InkWell(
                          onTap: () async{
                            if (_form.currentState!.validate()){
                                //adicionando servico a lista
                                servSelecionados.add(getServicoByDesc(dropdown, _listServ));
                                //adicionando valor a lista de valores
                                valoresServico.add(valor);
                                valor = "0";
                                controller.clear();
                            }
                            setState(() {});
                          },
                          child: Icon(size: 50, Icons.add_circle, color: AppColors.primaryColor,),
                        ),
                      ],
                    ),
                    // lista serviços selecionados
                    Center(
                      child: Container(
                        height: MediaQuery
                            .of(parentContext)
                            .size
                            .height * 0.45,
                        width: MediaQuery
                            .of(parentContext)
                            .size
                            .width * 0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.shape,
                        ),
                        child:
                        ListView.builder(
                            itemCount: servSelecionados.length,
                            itemBuilder: (context, index){
                          return Card(
                                      elevation: 8,
                                      child: ListTile(
                                        title: Text(servSelecionados[index].descricao.toString()),
                                        subtitle: Text(valoresServico[index]),
                                        trailing: InkWell(
                                            onTap: (){
                                              servSelecionados.removeAt(index);
                                              valoresServico.removeAt(index);
                                              setState((){});
                                            },
                                            child: Icon(Icons.delete)),
                                      ),
                                    );
                        })
                        // Column(
                        //   children: [
                        //     for (int i =0; i< servSelecionados.length;i++)
                        //       Card(
                        //         elevation: 8,
                        //         child: ListTile(
                        //           title: Text(servSelecionados[i].descricao.toString()),
                        //           subtitle: Text(valoresServico[i]),
                        //           trailing: InkWell(
                        //               onTap: (){
                        //                 servSelecionados.removeAt(i);
                        //                 valoresServico.removeAt(i);
                        //                 setState((){});
                        //               },
                        //               child: Icon(Icons.delete)),
                        //         ),
                        //       )
                        //   ],
                        // ),
                      ),
                    )
                  ],
                ),
              ),
            ),
              actions: <Widget>[
                ButtonWidget(
                  onTap: () async {
                    print(servSelecionados.length);
                    for (int i =0; i<servSelecionados.length; i++){
                      bool result = false;
                      _listServProf.forEach((element) {
                        if (element.idServico==servSelecionados[i].id){
                          result = true;
                        }

                      });
                      if (result==false){
                        _listServProf.add(ServicosProfissional(
                            valor: valoresServico[i],
                            idServico: servSelecionados[i].id.toString()
                        ));
                      }

                    }
                    DialogsProfissional.AlertDialogConfirmarDiasProfissional(parentContext,
                        uid, listOcupados, profissional, _listServProf, especialidadesProfissional, especialidades, listCodigos, servSelecionados, valoresServico);
                    // _listServProf.clear();
                  },
                  label: "Avançar >>",
                  width: MediaQuery.of(context).size.width * 0.07,
                  height: MediaQuery.of(context).size.height * 0.065,),

                ButtonWidget(
                  onTap: () {
                    Navigator.pop(parentContext);
                  },
                  label: "Cancelar >>",
                  width: MediaQuery.of(context).size.width * 0.07,
                  height: MediaQuery.of(context).size.height * 0.065,),
                // SimpleDialogOption(child: Text("Avançar >>"),
                //     onPressed: () async {
                //
                //       print(servSelecionados.length);
                //       DialogsProfissional.AlertDialogConfirmarDiasProfissional(parentContext,
                //           listOcupados, profissional, especialidades, listCodigos, servSelecionados, valoresServico);
                //       // DialogsProfissional.AlertConfirmarCadastroProfissional(
                //       //     parentContext, listOcupados, profissional,
                //       //     especialidades, listCodigos, servSelecionados,
                //       //     valoresServico);
                // }),
                // SimpleDialogOption(
                //     child: Text("Cancelar"),
                //     onPressed: () {
                //       Navigator.pop(parentContext);
                //     }),
              ]
          )
        );
      }
    );
  }

  static Future<void> AlertConfirmarCadastroProfissional(
      parentContext, String uid, List<DiasSalasProfissionais> listOcupados,
      Profissional profissional, List<ServicosProfissional> servicosProfissional,List<EspecialidadeProfissional> especialidadesProfissional, List<Especialidade> especialidades,
      List<String> listCodigos, List<Servico> listServicos, List<String> valores, List<DiasSalasProfissionais> listSelectDay
      ) {
    final ScrollController _scrollController = ScrollController();
    final ScrollController _scrollController2 = ScrollController();
    late bool isButtonDisable = false;
    // print("selectDay.length ${listSelectDay.length}");
    // listSelectDay.forEach((element) {
    //   print("selectDay.length ${element.sala}");
    // });
    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) =>
              AlertDialog(
                title: SizedBox(
                  width: MediaQuery
                      .of(parentContext)
                      .size
                      .width * 0.9,
                  height: MediaQuery
                      .of(parentContext)
                      .size
                      .height * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                              "Confirme os dados e finalize o cadastro Profissional.")),
                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          //dados profissionais
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Row(
                                  children: [
                                    Text("Nome: ", style: AppTextStyles.labelBlack14Lex,),
                                    Text("${profissional.nome}", style: AppTextStyles.labelBold16,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Email: ", style: AppTextStyles.labelBlack14Lex,),
                                    Text("${profissional.email}, ${profissional.numero}", style: AppTextStyles.labelBold16,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("CPF: ", style: AppTextStyles.labelBlack14Lex,),
                                    Text("${profissional.cpf}", style: AppTextStyles.labelBold16,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Data Nascimento: ", style: AppTextStyles.labelBlack14Lex,),
                                    Text("${profissional.dataNascimento}", style: AppTextStyles.labelBold16,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Fone: ", style: AppTextStyles.labelBlack14Lex,),
                                    Text("${profissional.telefone}", style: AppTextStyles.labelBold16,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Endereço: ", style: AppTextStyles.labelBlack14Lex,),
                                    Text("${profissional.endereco}, ${profissional.numero}", style: AppTextStyles.labelBold16,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // especialidades
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (especialidades.length==1)
                                  Text("Especialidades: ", style: AppTextStyles.labelBlack14Lex,)
                                else
                                  Text("Especialidade: ", style: AppTextStyles.labelBlack14Lex,),

                                for (int i =0; i<especialidades.length; i++)
                                  Row(
                                    children: [
                                      Text(" - ${especialidades[i].descricao}, ", style: AppTextStyles.labelBlack16Lex,),
                                      Text("${listCodigos[i]} ", style: AppTextStyles.labelBlack16Lex,),
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),



                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text("Horários:"),
                              Container(
                                width: MediaQuery
                                    .of(parentContext)
                                    .size
                                    .width * 0.3,
                                height: MediaQuery
                                    .of(parentContext)
                                    .size
                                    .height * 0.3,
                                color: AppColors.line,
                                child: Scrollbar(
                                  controller: _scrollController,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: listSelectDay.length,
                                    itemBuilder: (context, index){
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        child: Card(
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                SizedBox(
                                                    width: MediaQuery
                                                        .of(parentContext)
                                                        .size
                                                        .width * 0.09,
                                                    child: Text("${listSelectDay[index].dia} ", style: AppTextStyles.labelBlack16Lex,)),
                                                SizedBox(
                                                    width: MediaQuery
                                                        .of(parentContext)
                                                        .size
                                                        .width * 0.05,
                                                    child: Text("${listSelectDay[index].hora} ", style: AppTextStyles.labelBlack16Lex,)),
                                                SizedBox(
                                                    width: MediaQuery
                                                        .of(parentContext)
                                                        .size
                                                        .width * 0.09,
                                                    child: Text("${listSelectDay[index].sala} ", style: AppTextStyles.labelBlack16Lex,)),


                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text("Serviços:"),
                              Container(
                                width: MediaQuery
                                    .of(parentContext)
                                    .size
                                    .width * 0.3,
                                height: MediaQuery
                                    .of(parentContext)
                                    .size
                                    .height * 0.3,
                                color: AppColors.line,
                                child: Scrollbar(
                                  controller: _scrollController2,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  child: ListView.builder(
                                    controller: _scrollController2,
                                    itemCount: listServicos.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        child: Card(
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                SizedBox(
                                                    width: MediaQuery
                                                        .of(parentContext)
                                                        .size
                                                        .width * 0.14,
                                                    child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text("${listServicos[index].descricao} ", style: AppTextStyles.labelBlack16Lex,))),
                                                SizedBox(
                                                    width: MediaQuery
                                                        .of(parentContext)
                                                        .size
                                                        .width * 0.08,
                                                    child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: (listServicos[index].qtd_sessoes==1)?
                                                          Text("${listServicos[index].qtd_sessoes} sessão ", style: AppTextStyles.labelBlack16Lex,)
                                                            :
                                                          Text("${listServicos[index].qtd_sessoes} sessões ", style: AppTextStyles.labelBlack16Lex,)
                                                    )
                                                ),
                                                SizedBox(
                                                    width: MediaQuery
                                                        .of(parentContext)
                                                        .size
                                                        .width * 0.04,
                                                    child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text("R\$ ${valores[index]} ", style: AppTextStyles.labelBlack16Lex,))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),


                    ],
                  ),
                ),
                actions: <Widget> [
                  ButtonDisableWidget(
                    isButtonDisabled: isButtonDisable,
                    onTap: () async {
                      isButtonDisable = !isButtonDisable;
                      setState((){});
                      //salvando primeiros digitos cpf
                      String password = profissional.cpf!.substring(0,3)+profissional.cpf!.substring(4,7);
                      print(password);
                      profissional.senha = password;
                      profissional.status = "ATIVO";
                      //salvando login e senha usuário
                      AuthenticateService().
                      signUp(email: profissional.email!, password: password).then((result) async {
                        if (result == null){


                          //salvando profissional
                          int idProf = 0;
                          await Provider.of<ProfissionalProvider>(context, listen: false)
                              .putInt(profissional).then((value) {
                                idProf = value;
                                print("entrou = prof = $idProf");
                                //salvando usuario
                                Provider.of<LoginProvider>(context, listen: false)
                                    .put(Login(
                                    id_usuario: idProf,
                                    tipo_usuario: "PROFISSIONAL"
                                ));
                          } );

                          print(idProf);

                          Provider.of<LogProvider>(
                              context, listen: false)
                              .put(LogSistema(
                            data: DateTime.now().toString(),
                            uid_usuario: uid,
                            descricao: "INSERIU PROFISSIONAL",
                            id_transacao: idProf.toString(),
                          ));

                          //dias salas profissional
                          for (var item in listSelectDay){
                            item.idProfissional=idProf;
                            await Provider.of<DiasSalasProfissionaisProvider>(context, listen: false)
                                .put(item);
                          }



                          for (var espProf in especialidadesProfissional){
                            espProf.idProfissional=idProf;
                            await Provider.of<EspecialidadeProfissionalProvider>
                              (context, listen: false).put(espProf);

                          }

                          //serviços profissional
                          print(servicosProfissional.length);
                          print("serviços length");
                          // for (var serv in servicosProfissional){
                          for (int i =0; i<servicosProfissional.length; i++){
                            print(servicosProfissional.length);
                            print("serviços length");
                            servicosProfissional[i].idProfissional=idProf;
                            await Provider.of<ServicoProfissionalProvider>
                              (context, listen: false).put(servicosProfissional[i]);
                            if (i==(servicosProfissional.length-1)) {
                              Navigator.pushReplacementNamed(
                                  context, "/profissionais");
                            }
                          }

                          // print("idProf $idProf");
                        }

                      });
                    },
                    label: "Salvar >>",
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.height * 0.065,),
                  ButtonWidget(
                    onTap: () {
                      Navigator.pop(parentContext);
                    },
                    label: "Cancelar >>",
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.height * 0.065,),

                  // SimpleDialogOption(child: Text("Salvar"),
                  //     onPressed: () async {
                  //
                  //     }),
                  // SimpleDialogOption(
                  //     child: Text("Cancelar"),
                  //     onPressed: () {
                  //       Navigator.pop(parentContext);
                  //     }),
                ],
              ));
        }
    );
  }




}
