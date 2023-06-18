import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_agenda.dart';
import 'package:psico_sis/model/dias.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/provider/dias_profissional_provider.dart';
import 'package:psico_sis/provider/dias_provider.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/especialidade_profissional_provider.dart';
import 'package:psico_sis/provider/especialidade_provider.dart';
import 'package:psico_sis/provider/log_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/widgets/button_widget.dart';
import 'package:psico_sis/widgets/input_text_uper_widget.dart';
import 'package:psico_sis/widgets/input_text_widget_mask.dart';
import '../model/Especialidade.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/dias_profissional.dart';
import '../model/especialidades_profissional.dart';
import '../model/log_sistema.dart';
import '../model/login.dart';
import '../model/servico.dart';
import '../model/servicos_profissional.dart';
import '../model/sessao.dart';
import '../provider/login_provider.dart';
import '../provider/paciente_provider.dart';
import '../provider/servico_profissional_provider.dart';
import '../service/authenticate_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../views/especialidades.dart';
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
        .getEspecialidades()
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
                        // print("erro");

                          if (_listAdd.contains(esp) == false) {
                            print(esp.id1);
                            print("aquiiii");
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
                      (context, listen: false).getList().then((value) {
                      _listOcupados = value;
                    });
                    print(_listAdd.length);
                    print("aqui");
                    List<EspecialidadeProfissional> listEspProf=[];
                    for (int i =0; i<_listAdd.length; i++){
                      print(_listAdd[i].id1);
                      listEspProf.add(EspecialidadeProfissional(
                          codigoEspecialidade: _listCodigo[i],
                          idEspecialidade: _listAdd[i].id1
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

  //
  //       List<DiasProfissional> diasProfissional,
  //       List<ServicosProfissional> servicosProfissional,
  //       List<Servico> servicos, ) async {

  //CONFIRMAR EXCLUSÃO DE HORÁRIO
  static Future<void> AlertDialogConfirmarExclusaoHorario(
      parentContext, String uid,
      Profissional profissional,
      DiasSalasProfissionais diaRemover,
      List<DiasSalasProfissionais> diasTrabalhoProfissional,
      List<DiasSalasProfissionais> listOcupados,
      List<DiasProfissional> diasProfissional,
      List<DiasProfissional> dias,
      List<Servico> servicos,
      List<ServicosProfissional> servicosProfissional,

      ) async {


    return showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context1, setState) => AlertDialog(
            title: Column(
              children: [
                Text("CONFIRMAR EXCLUSÃO DE HORÁRIO PROFISSIONAL"),
                Divider(
                  thickness: 2,
                ),
                //nome
                Row(
                  children: [
                    Text("Profissional: "),
                    Text("${profissional.nome}"),
                  ],
                ),
                //email
                Row(
                  children: [
                    Text("Dia: "),
                    Text("${diaRemover.dia}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Horário: "),
                    Text("${diaRemover.hora}"),
                  ],
                ),
                Row(
                  children: [
                    Text("Sala: "),
                    Text("${diaRemover.sala}"),
                  ],
                ),

                Divider(
                  thickness: 2,
                ),
              ],
            ),
            actions: <Widget>[
              ButtonWidget(
                onTap: () async {
                  print(diaRemover.id1);

                  int cont =0;
                  bool result = false;
                  //checa se existe mais de um diaSalaProfissional com o mesmo dia da semana
                  //se existir apenas um deverá excluir.
                  diasTrabalhoProfissional.forEach((element) {
                    if (element.dia!.compareTo(diaRemover.dia!)==0){
                      result = true;
                      cont++;
                    }
                  });



                  print(result);
                  print(cont);
                  if ((cont==1)&&(result)){
                    diasProfissional.forEach((element) {
                      if (element.dia!.compareTo(diaRemover.dia!)==0){
                        print("----${element.dia}");
                        print("----${element.id1}");
                        print("removeu diasProfissional");
                        Provider.of<DiasProfissionalProvider>(parentContext,listen: false)
                          .remove(element.id1);
                        
                      }
                    });
                    // print("removeu diasProfissional");

                  }
                  // print("removeu diasSalasProfissional ${diaRemover.id1} ");
                  Provider.of<DiasSalasProfissionaisProvider>(parentContext, listen: false)
                    .remove(diaRemover.id1);
                  diasTrabalhoProfissional.remove(diaRemover);
                  DialogsProfissional.AlertDialogCronograma(
                      parentContext, uid, diasTrabalhoProfissional, listOcupados, diasProfissional, profissional, servicosProfissional, servicos);
                  // Navigator.
                },
                label: "Remover",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.065,),

              ButtonWidget(
                onTap: () async {
                  Navigator.pop(parentContext);
                },
                label: "Cancelar",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.065,),
            ],
          ),
        );
      },
    );
  }

  //Sessoes do dia e horario a ser removido
  static Future<void> AlertDialogSessoesDiaHoraRemover(
      parentContext, String uid,
      Profissional profissional,
      List<Sessao> sessoes,
      String dia,
      String hora,
      String sala,
      )async{

    String getDiaCorrente(String data) {
      DateTime date = DateTime(
          int.parse(data.substring(7,10)),
          int.parse(data.substring(4,5)),
          int.parse(data.substring(1,2))
      );
      String dia = DateFormat('EEEE').format(date);
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

    int GetDiferenceDays(String data1, String data2){
      int dia1, dia2=0;
      int mes1, mes2=0;
      int ano1,ano2=0;
      dia1 = int.parse(data1.substring(0,2));
      dia2 = int.parse(data2.substring(0,2));
      mes1 = int.parse(data1.substring(3,5));
      mes2 = int.parse(data2.substring(3,5));
      ano1 = int.parse(data1.substring(6,10));
      ano2 = int.parse(data2.substring(6,10));
      final data = DateTime(ano2,mes2,dia2).difference(DateTime(ano1,mes1,dia1));
      print(data.inDays.toString()+" diferença");
      return data.inDays;
    }

    Size size = MediaQuery.of(parentContext).size;
    return showDialog(
      barrierColor: AppColors.shape,
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
            builder: (context1, setState) => AlertDialog(
              title: Column(
                children: [
                  Text("SESSÕES QUE CAUSAM CHOQUE PARA ESTE DIA E HORARIO"),
                  Row(children: [
                    Text(dia),
                    Text(" | "),
                    Text(hora),
                    Text(" | "),
                    Text(sala),
                  ],),
                  Container(
                    width: size.width*0.4,
                    height: size.height*0.7,
                    color: AppColors.red,
                    child: ListView.builder(
                        itemCount: sessoes.length,
                        itemBuilder: (context, index){

                          return
                            (sessoes.length>0)?
                               Card(
                                 child: ListTile(
                                   trailing: Column(
                                     children: [
                                       InkWell(
                                         onTap: ()async{
                                           int sessaoAtual = int.parse(sessoes[index].descSessao!.substring(7,8));
                                           int sessaoTotal = int.parse(sessoes[index].descSessao!.substring(9,10));
                                           int diference = 0;
                                           List<Sessao> sessoesChoque = [];
                                           List<Sessao> listSessao = [];
                                           List<String> datasSessoes = [];
                                           List<String> horarioSessoes = [];
                                           List<DiasProfissional> listDiasProf=[];
                                           Paciente paciente = Paciente();
                                           List<DiasSalasProfissionais> listDiasSalas=[];
                                           await Provider.of<PacienteProvider>(context, listen: false)
                                               .getPaciente(sessoes[index].idPaciente!).then((value) {
                                             paciente = value;
                                           });
                                           await Provider.of<DiasSalasProfissionaisProvider>(context, listen:false)
                                               .getListDiasSalasByProfissional(
                                               sessoes[index].idProfissional!).then((value) {
                                               listDiasSalas = value;
                                           });
                                           await Provider.of<DiasProfissionalProvider>(context, listen: false)
                                               .getDiasProfissionalByIdProfissional
                                                (sessoes[index].idProfissional!).then((value) {
                                                listDiasProf = value;
                                           });

                                           if (sessaoAtual!=sessaoTotal){
                                             print("sessoes > 1");
                                             Provider.of<SessaoProvider>(context, listen: false)
                                                 .getSessoesByTransacaoPacienteProfissional(
                                                 sessoes[index].idPaciente!,
                                                 sessoes[index].idProfissional!, sessoes[index].idTransacao!).then((value) {

                                                   listSessao.clear();
                                                   listSessao = value;
                                               listSessao.sort((a,b)=>a.descSessao!.compareTo(b.descSessao!));

                                               listSessao.forEach((element) {
                                                 print(element.dataSessao);
                                                 datasSessoes.add(element.dataSessao!);
                                               });
                                               diference = GetDiferenceDays(datasSessoes[0], datasSessoes[1]);
                                             });
                                             DialogsAgendaAssistente.
                                             AlertDialogReagendamento2(
                                                 parentContext, uid,
                                                 sessoes, sessoes[index],sessoes[index],
                                                 paciente, profissional, listDiasProf,
                                                 listDiasSalas, datasSessoes,
                                                 horarioSessoes, diference);
                                           } else {
                                             print("sessoes = 1");
                                             print(sessoes.length);
                                             sessoesChoque.add(sessoes[index]);
                                             sessoes.add(sessoes[index]);
                                             datasSessoes.add(sessoes[index].dataSessao!);
                                             horarioSessoes.add(sessoes[index].horarioSessao!);
                                             DialogsAgendaAssistente.
                                             AlertDialogReagendamento2(
                                                 parentContext, uid,
                                                 sessoesChoque, sessoes[index],sessoes[index],
                                                 paciente, profissional, listDiasProf,
                                                 listDiasSalas, datasSessoes,
                                                 horarioSessoes, diference).then((value){
                                                   Navigator.pop(context);
                                             });


                                           }



                                         },
                                         child: Icon(Icons.calendar_month_outlined),
                                       ),
                                       Text("REAGENDAR")
                                     ],
                                   ),
                                   title: SizedBox(
                                     width: size.width*0.38,
                                     height: size.height*0.05,
                                     child: FittedBox(
                                       fit: BoxFit.scaleDown,
                                       child: Text(sessoes[index].descSessao!),
                                     )
                                   ),
                                   subtitle: Row(
                                     children: [
                                       Column(
                                         children: [
                                           Text(getDiaCorrente(sessoes[index].dataSessao!)),
                                           Text(sessoes[index].dataSessao!),
                                         ],
                                       ),
                                       SizedBox(
                                         height: size.height*0.05,
                                         child: VerticalDivider(thickness: 2,color: AppColors.labelBlack,),),
                                       Column(
                                         children: [
                                           Text("STATUS"),
                                           Text(sessoes[index].statusSessao!),
                                         ],
                                       ),
                                       SizedBox(
                                         height: size.height*0.05,
                                         child: VerticalDivider(thickness: 2,color: AppColors.labelBlack,),
                                       ),

                                       Text(sessoes[index].salaSessao!),
                                       SizedBox(
                                          height: size.height*0.05,
                                          child: VerticalDivider(thickness: 2,color: AppColors.labelBlack,),
                                       ),

                                       Text(sessoes[index].horarioSessao!),

                                     ],
                                   ),
                                 ),
                               )
                          :
                              Center();
                        }),
                  ),
                ],
              ),
            )
        );
      }
    );

  }

  //Cronograma
  static Future<void> AlertDialogCronograma(
      parentContext, String uid,
      List<DiasSalasProfissionais> listHorariosProfissional,
      List<DiasSalasProfissionais> listOcupados,
      List<DiasProfissional> diasProfissional,
      Profissional profissional,
      List<ServicosProfissional> servicosProfissional,
      List<Servico> servicos, ) async {

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
      false,
    ];
    List<String> _listDescSalas = [
      "SALA 01",
      "SALA 02",
      "SALA 03",
      "SALA 04",
      "SALA 05",
      "SALA 06",
      "SALA 07",
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
      listHorariosProfissional.forEach((element){
        if ((element.dia?.compareTo(_selectDay)==0) &&
            (element.hora?.compareTo(_listHoras[j])==0)){
          result = true;
        }
      });
      return result;
    }
    DiasSalasProfissionais getDia(int i, int j){
       DiasSalasProfissionais dia = new DiasSalasProfissionais();
       listHorariosProfissional.forEach((element) {
         if ((element.dia?.compareTo(_selectDay)==0) &&
             (element.hora?.compareTo(_listHoras[j])==0)&&
             (element.sala?.compareTo(_listDescSalas[i])==0)
         ){
           dia = element;
         }
       });
       return dia;
    }

    bool busyProfissional(int i, int j){
      bool result = false;
      listHorariosProfissional.forEach((element) {
        if ((element.dia?.compareTo(_selectDay)==0) &&
            (element.hora?.compareTo(_listHoras[j])==0)&&
            (element.sala?.compareTo(_listDescSalas[i])==0)
        ){
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
      String idProfissional = "0";
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


    Size size = MediaQuery.of(parentContext).size;
    return showDialog(
        context: parentContext,
        builder: (context){
           return StatefulBuilder(
               builder: (context, setState)=>AlertDialog(
                 title: SizedBox(
                   width: size.width*0.9,
                   height: size.height*0.75,
                   child: Column(
                     children: [
                       Center(
                           child: Text(
                               "Selecione os DIAS e HORÁRIOS que o Profissional irá atuar. ", style: AppTextStyles.labelBlack14Lex,)),
                       Divider(
                         thickness: 2,
                       ),
                       Container(
                         // color: AppColors.secondaryColor2,
                         width: size.width * 0.9,
                         height: size.height * 0.6,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Column(
                                   children: [
                                     //list horas
                                     Container(
                                       height: size.height * 0.06,
                                       width:size.width * 0.718,
                                       child: Row(
                                         children: [
                                           Card(
                                             elevation: 8,
                                             color: AppColors.line,
                                             child: Container(
                                               width: size.width * 0.114,
                                               height: size.height *0.06,
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
                                                     width: size.width *0.04,
                                                     height: size.height*0.045,
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
                                       // height: size.height *0.465,
                                       height: size.height *0.54,
                                       width: size.width * 0.718,
                                       // color: AppColors.line,
                                       child: Row(
                                         children: [
                                           //salas
                                           Container(
                                             height:size.height * 0.54,
                                             width: size.width * 0.12,
                                             // color: AppColors.blue,
                                             child: ListView.builder(
                                                 scrollDirection: Axis.vertical,
                                                 itemCount: 7,
                                                 itemBuilder: (context, index) {
                                                   return Card(
                                                       elevation: 8,
                                                       color: _listSalas[index]
                                                           ? AppColors.line
                                                           : AppColors.green,
                                                       child: SizedBox(
                                                           height: size.height *0.065,
                                                           width: size.width *0.07,
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
                                             height: size.height *0.54,
                                             width:size.width *0.598,
                                             // color: AppColors.primaryColor,
                                             child: ListView.builder(
                                                 itemCount: 7,
                                                 itemBuilder: (context, index){
                                                  return Row(
                                                    children: [
                                                      for (int j = 0; j < jota; j++)
                                                      //ocupado horario profissional?
                                                        busyProfissional(index, j) ?
                                                        InkWell(
                                                          onTap: (){
                                                            print("ontap = $_selectDay");
                                                            Provider.of<SessaoProvider>(context,listen: false)
                                                                .getSessoesByDiaSalaHora(
                                                                _selectDay, _listDescSalas[index],
                                                                _listHoras[j],profissional.id1).then((value) {
                                                              List<Sessao> list = [];
                                                              list = value;
                                                              print(list.length);
                                                              print("list.length");

                                                              list.forEach((element) {
                                                                print(element.dataSessao);
                                                                print(element.descSessao);
                                                                print(element.horarioSessao);
                                                                // print(element.);
                                                              });
                                                              if(list.length>0){
                                                                //exibir sessoes que causa choque em horario a ser removido
                                                                DialogsProfissional.AlertDialogSessoesDiaHoraRemover(parentContext,
                                                                    uid,profissional,list,_selectDay,_listDescSalas[index],
                                                                    _listHoras[j]
                                                                );
                                                                //  showSnackBar("EXISTE SESSÃO PARA ESTE DIA NESTE HORÁRIO.");
                                                              } else {
                                                                //confirmar exclusão
                                                                DiasSalasProfissionais dia = getDia(index, j);
                                                                print(dia.hora);
                                                                print(dia.sala);
                                                                print(dia.dia);
                                                                List<DiasProfissional> result = [];
                                                                diasProfissional.forEach((element) {
                                                                  if (element.idProfissional!.compareTo(profissional.id1)==0){
                                                                    result.add(element);
                                                                  }
                                                                });
                                                                DialogsProfissional.AlertDialogConfirmarExclusaoHorario(
                                                                    parentContext, uid, profissional, dia,
                                                                    listHorariosProfissional,listOcupados, result,diasProfissional,servicos,servicosProfissional);
                                                                setState((){});
                                                                print("result = 0");
                                                              }
                                                            });

                                                          },
                                                          child: Card(
                                                            elevation: 8,
                                                            color: AppColors.secondaryColor,
                                                            child: SizedBox(
                                                                width: MediaQuery.of(parentContext).size.width * 0.04,
                                                                height: MediaQuery.of(parentContext).size.height * 0.065,
                                                                child: FittedBox(

                                                                    child: Column(
                                                                      children: [
                                                                        Text("RESERVADO"),
                                                                        Icon(
                                                                          Icons.delete_outline_rounded,
                                                                          color: AppColors.labelWhite,
                                                                        ),
                                                                      ],
                                                                    ))),
                                                          ),
                                                        ):
                                                        busy(index, j) ?
                                                        //card ocupado
                                                        Card(
                                                          color: AppColors.red,
                                                          child: SizedBox(
                                                            width: size.width *0.04,
                                                            height: size.height *0.065,
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
                                                                              future: getNome(index, j),
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
                                                        // busy(i, j)
                                                        busySelect(index, j)?
                                                        //card selecionado
                                                        InkWell(
                                                          onTap: (){
                                                            // getSelectDay(i,j)
                                                            if (getDay(_selectDay, index, j, _listSelectDay)!=null){
                                                              _listSelectDay.remove(getDay(_selectDay, index, j, _listSelectDay));
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
                                                                      sala: _listDescSalas[index]
                                                                  )
                                                              );
                                                              _listSelectDay.sort(
                                                                      (a,b) {
                                                                    if (a.dia! == b.dia!) {
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
                                                            color: ((index % 2) != 0) ? AppColors.shape : AppColors.labelWhite,
                                                            child: SizedBox(
                                                                width: MediaQuery.of(parentContext).size.width * 0.04,
                                                                height: MediaQuery.of(parentContext).size.height * 0.065,
                                                                child: Center(child:
                                                                Text(_listHoras[j],
                                                                  style: AppTextStyles.labelBold16,))),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                 })
                                           )
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                                 //lista cards horários selecionados
                                 Container(
                                   height:size.height * 0.54,
                                   width: size.width * 0.18,
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
                             // Divider(
                             //   thickness: 2,
                             // ),
                             //lista com os botões dos dias da semana

                           ],
                         ),
                       ),
                       Divider(
                         thickness: 2,
                       ),
                       Center(
                         child: Container(
                           height: size.height * 0.07,
                           width: size.width * 0.464,
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
                                     height: size.height *0.08,
                                     width:size.height *0.15,
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
                 actions: [
                   ButtonWidget(
                     onTap: () async {
                       if (_listSelectDay.length>0){
                         print("confirmar alterar agendamento");
                         // listHorariosProfissional.sort((a,b)=>a.dia!.compareTo(b.dia!));
                         listHorariosProfissional.sort(
                                 (a,b) {
                               if (a.dia! == b.dia!) {
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
                         List<DiasProfissional> listaDoProfissional = [];
                         diasProfissional.forEach((element) {
                            if (element.idProfissional!.compareTo(profissional.id1)==0){
                              listaDoProfissional.add(element);
                            }
                         });
                         // listaDoProfissional = diasProfissional.where((element) => element.idProfissional!.compareTo(profissional.id1)==0);
                         DialogsProfissional.AlertConfirmarAdicionalAgendamento(parentContext,
                             uid,profissional,listHorariosProfissional,_listSelectDay, listaDoProfissional);
                       }  else {
                         print("selecione um dia");
                       }

                     },
                     label: "Avançar >>",
                     width: MediaQuery.of(context).size.width * 0.07,
                     height: MediaQuery.of(context).size.height * 0.065,),
                 ],
               ));
        });

    

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
      String idProfissional = "0";
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
                                                                 // print("${b.hora!}.compareTo(${a.hora!}))");
                                                                 // print(b.hora!.compareTo(a.hora!));
                                                                 //
                                                                 // print("${a.hora!}.compareTo(${b.hora!}))");
                                                                 // print(a.hora!.compareTo(b.hora!));
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
        .getListServicos()
        .then((value) {
      // _listServ = value.cast<Servico>();
      _listServ = value;
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
              print("elememnt");
              print(element.id);
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
                        print("id servico selecionado = ");
                        print(servSelecionados[i].id);
                        _listServProf.add(ServicosProfissional(
                            valor: valoresServico[i],
                            idServico: servSelecionados[i].id,
                        ));
                      }

                    }
                    print('agora vai');
                    _listServProf.forEach((element) {
                      print(element.idServico);
                    });
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

  static Future<void> AlertConfirmarAdicionalAgendamento(
      parentContext, String uid, Profissional profissional,
      List<DiasSalasProfissionais> diasVelhos,
      List<DiasSalasProfissionais> diasNovos,
      List<DiasProfissional> diasTranalhoProfissional
  ){
    final ScrollController _scrollController = ScrollController();
    List<String> dias = [
      "SEGUNDA",
      "TERÇA",
      "QUARTA",
      "QUINTA",
      "SEXTA",
      "SÁBADO",
      "DOMINGO"
    ];
    List<String> horas = [
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
    ];
    int getQtdSessoesVelhasBYDia(String dia){
      int cont =0;
         diasVelhos.forEach((element) {
            if (element.dia!.compareTo(dia)==0){
              cont++;
            }
         });
         return cont;
    }

    List<DiasSalasProfissionais> getDiasSalasDoDia(String dia){
      List<DiasSalasProfissionais> result =[];
      print(diasVelhos.length.toString()+"--------");
      print(dia+"------");
      diasVelhos.forEach((element) {
        if (element.dia!.compareTo(dia)==0){
          print("result.add(element);${element.dia}");
          result.add(element);
        }
      });
      print(result.length);
      print("result");
      return result;
    }
    bool containDiaHora(String dia, String hora){
      bool result =false;
      diasVelhos.forEach((element) {
        if ((element.dia!.compareTo(dia)==0)
            &&(element.hora!.compareTo(hora)==0)){
          print("return true ${element.dia}");
          result = true;
        }
      });
      return result;
    }

    List<Widget> listaWidgets(Size size){
      int indexI(String dia,){
       int result =0;
       result = dias.indexWhere((element) => element.compareTo(dia)==0);
       print("result i = ${result}");
       return result;
      }
      int indexJ(String hora,){
        int result =0;
        result = horas.indexWhere((element) => element.compareTo(hora)==0);
        print("result j = ${result}");

        return result;
      }
      double width = size.width*0.48;
      double height = (size.height*0.48)/12;
      List<Widget> result = [];
      for (int i =0; i<dias.length;i++){
        for (int j=0; j<horas.length; j++){
          result.add(
              Card(
                // color: AppColors.labelWhite,
            child: Container(
              width: width,
              height: height,
              color: AppColors.line.withOpacity(0.4),
              child: Center(child: Text(horas[j]),)
            )
          ));
        }
      }
      diasNovos.forEach((element) {
        int i = indexI(element.dia!);
        int j = indexJ(element.hora!);
        int indice = i*12+j;
        result[indice] = Card(
            child: Container(
                width: width,
                height: height,
                color: AppColors.secondaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(horas[j]),
                    Text("|"),
                    Text(element.sala!),
                  ],
                )
            )
        );
      });
      diasVelhos.forEach((element) {
         int i = indexI(element.dia!);
         int j = indexJ(element.hora!);
         int indice = i*12+j;
         result[indice] = Card(
          child: Container(
            width: width,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(horas[j]),
                Text("|"),
                Text(element.sala!),
              ],
            )
          )
         );
      });

      return result;
    }
    print("----");
    diasTranalhoProfissional.forEach((element) {
      print(element.dia);
      print(element.idProfissional);
    });
    print("----");

    Size size = MediaQuery.of(parentContext).size;
    bool check = false;
    List<Widget> list = listaWidgets(size);
    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) =>
              AlertDialog(
                title: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.75,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("CONFIRMAR NOVOS HORÁRIOS "),

                          // Text("Profissional: "),
                          Text(profissional.nome!),
                        ],
                      ),
                      Container(
                        width: size.width * 0.7,
                        height: size.height * 0.7,
                        color: AppColors.shape,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    // color: AppColors.labelWhite.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(6.0)
                                  ),
                                  width: size.width * 0.16,
                                  height: size.height * 0.7,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.16,
                                        height: size.height * 0.05,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: size.width * 0.05,
                                                  height: size.height * 0.05,
                                                  child: CircleAvatar(
                                                    backgroundColor: AppColors.secondaryColor,
                                                  )
                                              ),
                                              SizedBox(
                                                width: size.width * 0.11,
                                                height: size.height * 0.05,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("HORÁRIO NOVO",
                                                      style: AppTextStyles.labelBlack14Lex),
                                                )
                                              ),


                                            ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top:size.height*0.05,
                                            bottom:size.height*0.05,),
                                        child: SizedBox(
                                        width: size.width * 0.16,
                                        height: size.height * 0.05,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            SizedBox(
                                                width: size.width * 0.05,
                                                height: size.height * 0.05,
                                                child: CircleAvatar(
                                                  backgroundColor: AppColors.labelWhite,)
                                            ),
                                            SizedBox(
                                                width: size.width * 0.11,
                                                height: size.height * 0.05,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,

                                                  child: Text("HORÁRIO ANTIGO",style: AppTextStyles.labelBlack14Lex),
                                                )
                                            ),

                                          ],
                                        ),
                                      ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.16,
                                        height: size.height * 0.05,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: size.width * 0.05,
                                                height: size.height * 0.05,
                                                child: CircleAvatar(
                                                  backgroundColor: AppColors.line.withOpacity(0.4),)
                                            ),
                                            SizedBox(
                                                width: size.width * 0.11,
                                                height: size.height * 0.05,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("HORÁRIO LIVRE", style: AppTextStyles.labelBlack14Lex),
                                                )

                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                                Container(
                                    width: size.width * 0.5,
                                    height: size.height * 0.7,
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.5,
                                          height: size.height * 0.03,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                            child: Text("HORÁRIOS DO PROFISSIONAL",
                                              style: AppTextStyles.labelBlack14Lex,),
                                          )
                                        ),
                                        SizedBox(
                                          width: size.width * 0.5,
                                          height: size.height * 0.67,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (context, index){
                                              List<DiasSalasProfissionais> diasProf =[];
                                              diasProf=getDiasSalasDoDia(dias[index]);
                                              return Container(
                                                width: size.width * 0.1,
                                                height: size.height * 0.67,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.line,
                                                        borderRadius: BorderRadius.circular(4.0)
                                                      ),
                                                        width: size.width * 0.09,
                                                        height: size.height * 0.035,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        alignment: Alignment.center,
                                                        child: Text(dias[index])
                                                      )
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.1,
                                                      height: size.height * 0.63,
                                                      child:ListView.builder(
                                                          itemCount: 12,
                                                          itemBuilder: (context1, index1){
                                                            return list[index*12+index1];
                                                          }),
                                                    )
                                                  ],
                                                )
                                              );
                                            },

                                          )
                                        ),
                                      ],
                                    )

                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                actions: [
                  ButtonDisableWidget(

                      isButtonDisabled: check,
                      onTap: ()async{
                        check=!check;
                        for (var item in diasNovos){
                          // item.idProfissional=idProf;
                          item.idProfissional = profissional.id1;

                          await Provider.of<DiasSalasProfissionaisProvider>(context, listen: false)
                              .put(item).then((value) async{
                            // bool result = true;
                            // for(int i =0; i<diasTranalhoProfissional.length;i++){
                            //   if (item.dia!.compareTo(diasTranalhoProfissional[i].dia!)==0){
                            //     print("false ${item.dia}");
                            //     result = false;
                            //   }
                            // }
                            // if(result){
                            //   print("adicionou ${item.dia}");
                            // } else {
                            //   print("$result ..");
                            // }
                                // checando se existe um dia novo profissional
                          });

                        }
                        for (var item in diasNovos){
                          bool result = true;
                          for(int i =0; i<diasTranalhoProfissional.length;i++){
                            if (item.dia!.compareTo(diasTranalhoProfissional[i].dia!)==0){
                              print("false ${item.dia}");
                              result = false;
                              break;
                            }
                          }
                          if(result){
                            print("adicionou ${item.dia}");
                            await Provider.of<DiasProfissionalProvider>
                              (context, listen: false).put(
                                DiasProfissional(
                                    idProfissional: profissional.id1,
                                    dia: item.dia
                                ));
                            diasTranalhoProfissional.add(DiasProfissional(
                                idProfissional: profissional.id1,
                                dia: item.dia
                            ));
                          } else {
                            print("$result não adicionou..${item.dia}");
                          }
                        }
                        Navigator.pushReplacementNamed(
                            context, "/profissionais");
                        // setState((){});
                      },
                      label: "Salvar",
                      width: size.width*0.07,
                      height: size.height*0.065,

                  ),
                  ButtonWidget(
                    onTap: () {
                      Navigator.pop(parentContext);
                    },
                    label: "Cancelar",
                    width: size.width * 0.07,
                    height: size.height * 0.065,),

                ],
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


                          ///salvando profissional
                          String idProf = "0";

                          await Provider.of<ProfissionalProvider>(context, listen: false)
                              .putId(profissional).then((value) {
                                idProf = value;
                                print("Salvando = prof = $idProf");
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
                            id_transacao: idProf,
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
                          // }

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

  static Future<void> AlertAlterarProfissional(
      parentContext, String uid,
      Profissional profissional, List<ServicosProfissional> servicosProfissional,
      List<Especialidade> especialidadesProfissional, List<Servico> servicos,
      ) {
    late bool isButtonDisable = false;
    servicosProfissional.sort((a,b){
      int a1 = int.parse(a.valor!.substring(0,a.valor!.length-3));
      int b1 = int.parse(b.valor!.substring(0,b.valor!.length-3));
      if (a1<b1){
        return b1;
      }
      return a1;
    });

    String getNomeServicoById(String id){
      String result ="";
      var nome = servicos.firstWhere((element) => element.id1==id,);
      return nome.descricao!;
    }

    Size size =    MediaQuery.of(parentContext).size;
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) =>
              AlertDialog(
                title: SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                              "ALTERAR SERVIÇOS")),
                      Divider(
                        thickness: 2,
                      ),
                      Container(
                        // color: AppColors.secondaryColor2,
                        width: size.width * 0.5,
                        height: (size.height * 0.55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //lista de servicos
                            Container(
                              // color:Colors.red,
                                width: size.width * 0.4,
                                height: (size.height * 0.065)*(servicosProfissional.length+1),
                                child: ListView.builder(
                                    itemCount: servicosProfissional.length,
                                    itemBuilder: (context, index){
                                  return  Card(
                                      child: Container(
                                        color: AppColors.shape,
                                        width: size.width * 0.38,
                                        height: size.height * 0.06,
                                        child: Row(
                                          children: [
                                            //desc serviço
                                            SizedBox(
                                                width: size.width * 0.31,
                                                height:  size.height * 0.06,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(getNomeServicoById(servicosProfissional[index].idServico!)),
                                                )

                                            ),
                                            //valor
                                            SizedBox(
                                                width:  size.width * 0.03,
                                                height:  size.height * 0.06,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(servicosProfissional[index].valor!, style: AppTextStyles.labelBlack16Lex,),
                                                )
                                            ),
                                            //icone edit
                                            SizedBox(
                                                width:  size.width * 0.02,
                                                height:  size.height * 0.06,
                                                child: InkWell(
                                                  onTap: (){
                                                    DialogsProfissional.
                                                    AlertAlterarServicoProfissional(
                                                        parentContext, uid, profissional,
                                                        servicosProfissional[index], servicos
                                                    ).then((value) => Navigator.pop(parentContext));
                                                  },
                                                  child: Icon(Icons.edit),
                                                )
                                            ),
                                            //icone2 remove
                                            SizedBox(
                                                width:  size.width * 0.02,
                                                height:  size.height * 0.06,
                                                child: InkWell(
                                                  onTap: (){
                                                    DialogsProfissional.AlertConfirmarApagarServicoProfissional(
                                                        parentContext, uid, profissional, servicosProfissional[index],servicos
                                                    ).then((value) => setState((){}));
                                                  },
                                                  child: Icon(Icons.delete_outline_rounded),
                                                )
                                            ),
                                          ],
                                        ),
                                      )
                                  );
                                }),
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                //   children: [
                                //     for (var items in servicosProfissional)
                                //       Center(
                                //         child: Card(
                                //             child: Container(
                                //               color: AppColors.shape,
                                //               width: size.width * 0.38,
                                //               height: size.height * 0.06,
                                //               child: Row(
                                //                 children: [
                                //                   //desc serviço
                                //                   SizedBox(
                                //                       width: size.width * 0.31,
                                //                       height:  size.height * 0.06,
                                //                       child: FittedBox(
                                //                         fit: BoxFit.scaleDown,
                                //                         alignment: Alignment.centerLeft,
                                //                         child: Text(getNomeServicoById(items.idServico!)),
                                //                       )
                                //
                                //                   ),
                                //                   //valor
                                //                   SizedBox(
                                //                       width:  size.width * 0.03,
                                //                       height:  size.height * 0.06,
                                //                       child: FittedBox(
                                //                         fit: BoxFit.scaleDown,
                                //                         alignment: Alignment.centerLeft,
                                //                         child: Text(items.valor!, style: AppTextStyles.labelBlack16Lex,),
                                //                       )
                                //                   ),
                                //                   //icone edit
                                //                   SizedBox(
                                //                       width:  size.width * 0.02,
                                //                       height:  size.height * 0.06,
                                //                       child: InkWell(
                                //                         onTap: (){
                                //                           DialogsProfissional.
                                //                           AlertAlterarServicoProfissional(
                                //                               parentContext, uid, profissional,
                                //                               items, servicos
                                //                           ).then((value) => Navigator.pop(parentContext));
                                //                         },
                                //                         child: Icon(Icons.edit),
                                //                       )
                                //                   ),
                                //                   //icone2 remove
                                //                   SizedBox(
                                //                       width:  size.width * 0.02,
                                //                       height:  size.height * 0.06,
                                //                       child: InkWell(
                                //                         onTap: (){
                                //                           DialogsProfissional.AlertConfirmarApagarServicoProfissional(
                                //                               parentContext, uid, profissional, items,servicos
                                //                           ).then((value) => setState((){}));
                                //                         },
                                //                         child: Icon(Icons.delete_outline_rounded),
                                //                       )
                                //                   ),
                                //                 ],
                                //               ),
                                //             )
                                //         ),
                                //       ),
                                //   ],
                                // )
                            ),
                            //botão
                            Container(
                              // color: Colors.blue,
                                width: size.width * 0.03,
                                height: (size.height * 0.065)*(servicosProfissional.length+1),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    iconSize: 35,
                                    color: AppColors.primaryColor,
                                    onPressed: (){
                                      print(servicos.length);
                                      for(int i =0; i< servicos.length;i++){
                                        for (int j =0; j<servicosProfissional.length;j++){
                                          if (servicos[i].id1.compareTo(servicosProfissional[j].idServico!)==0){
                                            servicos.removeAt(i);
                                            print("REMOVEU $i");
                                            break;
                                          }
                                        }
                                      }
                                      print(servicos.length);

                                         DialogsProfissional.adicionarServicoProfissional(
                                           parentContext,uid,profissional,servicos
                                         ) ;
                                    },
                                    icon: Icon(Icons.add_circle, color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                            ),


                          ],),

                      ),

                      Divider(
                        thickness: 2,
                      ),

                      SizedBox(
                        width: size.width * 0.5,
                        height:  size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonWidget(
                              onTap: () {
                                Navigator.pop(parentContext);
                              },
                              label: "Cancelar",
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: MediaQuery.of(context).size.height * 0.065,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }
    );
  }

  static Future<void> AlertAlterarServicoProfissional(
      parentContext, String uid,
      Profissional profissional, ServicosProfissional servicoProfissional,
       List<Servico> servicos,
      ) {
    late bool isButtonDisable = false;
    late String novoValor = "";
    String getNomeServicoById(String id){
      String result ="";
      var nome = servicos.firstWhere((element) => element.id1==id,);
      return nome.descricao!;
    }

    final _form = GlobalKey<FormState>();


    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) =>
              AlertDialog(
                title: SizedBox(
                  width: MediaQuery
                      .of(parentContext)
                      .size
                      .width * 0.5,
                  height: MediaQuery
                      .of(parentContext)
                      .size
                      .height * 0.5,
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                            child: Text(
                                "INSIRA UM NOVO VALOR PARA O SERVIÇO")),
                        Divider(
                          thickness: 2,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: AppColors.shape,
                            ),
                            width: MediaQuery
                                .of(parentContext)
                                .size
                                .width * 0.4,
                            height: MediaQuery
                                .of(parentContext)
                                .size
                                .height * 0.07,
                            child: Row(
                              children: [
                                //desc serviço
                                SizedBox(
                                    width:  MediaQuery
                                        .of(parentContext)
                                        .size
                                        .width * 0.35,
                                    height:  MediaQuery
                                        .of(parentContext)
                                        .size
                                        .height * 0.06,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(getNomeServicoById(servicoProfissional.idServico!),
                                            style: AppTextStyles.labelBlack16Lex,
                                          ),
                                        )
                                    )

                                ),
                                //valor
                                SizedBox(
                                    width:  MediaQuery
                                        .of(parentContext)
                                        .size
                                        .width * 0.05,
                                    height:  MediaQuery
                                        .of(parentContext)
                                        .size
                                        .height * 0.06,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text("R\$ ${servicoProfissional.valor!} ", style: AppTextStyles.labelBlackBold20Slin,),
                                    )
                                ),

                                // SizedBox(
                                //     width:  MediaQuery
                                //         .of(parentContext)
                                //         .size
                                //         .width * 0.05,
                                //     height:  MediaQuery
                                //         .of(parentContext)
                                //         .size
                                //         .height * 0.06,
                                //     child: FittedBox(
                                //       fit: BoxFit.scaleDown,
                                //       alignment: Alignment.centerRight,
                                //       child: Text("R\$ ${servicoProfissional.valor!} ", style: AppTextStyles.labelBold16,),
                                //     )
                                // ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child:  SizedBox(
                            width:  MediaQuery
                                .of(parentContext)
                                .size
                                .width * 0.16,
                            child: InputTextWidgetMask(
                              label: "Novo Valor",
                              icon: Icons.monetization_on,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              backgroundColor: AppColors.secondaryColor,
                              borderColor: AppColors.line,
                              textStyle: AppTextStyles.subTitleBlack12,
                              iconColor: AppColors.labelBlack,
                              input: CentavosInputFormatter(),
                              validator: (value) {
                                if ((value!.isEmpty) || (value == null)) {
                                  return 'Insira um valor';
                                }
                                return null;},
                              onChanged: (value) {
                                novoValor = value;},
                            ),

                          ),

                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width:  MediaQuery
                                .of(parentContext)
                                .size
                                .width * 0.25,
                            height:  MediaQuery
                                .of(parentContext)
                                .size
                                .height * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonWidget(
                                  onTap: () {

                                    if (_form.currentState!.validate()) {
                                      print("validou");
                                      String valor = novoValor.replaceAll(',', '.');
                                      print(valor);
                                      num valorReal =  0;
                                      valorReal = NumberFormat().parse(valor);
                                      if (valorReal>0){
                                        DialogsProfissional.AlertConfirmarAlterarServicoProfissional(
                                            parentContext, uid, profissional,
                                            servicoProfissional, servicos, novoValor)
                                            .then((value) => Navigator.pop(parentContext));

                                      }
                                    } else {
                                      print("não validou");
                                      setState((){});
                                    }
                                  },
                                  label: "Alterar",
                                  width: MediaQuery.of(context).size.width * 0.07,
                                  height: MediaQuery.of(context).size.height * 0.065,),
                                ButtonWidget(
                                  onTap: () {

                                    Navigator.pop(parentContext);
                                  },
                                  label: "Cancelar",
                                  width: MediaQuery.of(context).size.width * 0.07,
                                  height: MediaQuery.of(context).size.height * 0.065,),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ),
              ));
        }
    );
  }


  static Future<void> AlertConfirmarAlterarServicoProfissional(
      parentContext, String uid,
      Profissional profissional, ServicosProfissional servicoProfissional,
      List<Servico> servicos, String novoValor
      ){

    String getNomeServicoById(String id){
      String result ="";
      var nome = servicos.firstWhere((element) => element.id1==id,);
      return nome.descricao!;
    }
    Size size =  MediaQuery.of(parentContext).size;
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) =>
              AlertDialog(
                title: SizedBox(
                  width: size.width * 0.4,
                  height: size.height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                              "DESEJA REALMENTE ALTERAR O VALOR DO SERVIÇO?")),
                      Divider(
                        thickness: 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppColors.shape,
                          ),
                          width: size.width * 0.4,
                          height: size.height * 0.3,
                          child:Padding(
                            padding: EdgeInsets.only(left: size.width*0.01, right: size.width*0.01),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("SERVIÇO:",
                                  style: AppTextStyles.labelBlack16Lex,
                                ),
                                //desc serviço
                                SizedBox(
                                    width: size.width * 0.4,
                                    height: size.height * 0.06,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(getNomeServicoById(servicoProfissional.idServico!),
                                        style: AppTextStyles.labelBlack16Lex,
                                      ),
                                    )
                                ),
                                //valor
                                SizedBox(
                                    width: size.width * 0.4,
                                    height: size.height * 0.06,
                                    child: Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text("VALOR ATUAL: ", style: AppTextStyles.labelBold16,),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text("R\$ ${servicoProfissional.valor!} ", style: AppTextStyles.labelBold16,),
                                        )
                                      ],
                                    )
                                ),

                                SizedBox(
                                    width:  size.width * 0.4,
                                    height: size.height * 0.06,
                                    child: Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text("VALOR NOVO: ", style: AppTextStyles.labelBold16,),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(" R\$ $novoValor ", style: AppTextStyles.labelBlackBold20Slin,),
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),

                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width:  size.width * 0.25,
                          height: size.height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonWidget(
                                onTap: () async{
                                  await Provider.of<ServicoProfissionalProvider>(context,listen: false)
                                      .updateValorServicoProfissional(servicoProfissional.id1, novoValor);
                                  // Navigator.pop(parentContext);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/profissionais", (_) => false);
                                },
                                label: "Confirmar",
                                width: MediaQuery.of(context).size.width * 0.07,
                                height: MediaQuery.of(context).size.height * 0.065,),
                              ButtonWidget(
                                onTap: () {

                                  Navigator.pop(parentContext);
                                },
                                label: "Cancelar",
                                width: MediaQuery.of(context).size.width * 0.07,
                                height: MediaQuery.of(context).size.height * 0.065,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ));
        }
    );
  }

  static Future<void> AlertConfirmarApagarServicoProfissional(
      parentContext, String uid,
      Profissional profissional, ServicosProfissional servicoProfissional,
      List<Servico> servicos,
      ){

    late bool _valido = false;
    String getNomeServicoById(String id){
      String result ="";
      var nome = servicos.firstWhere((element) => element.id1==id,);
      return nome.descricao!;
    }

    bool checkServico(String id){

      return true;
    }

    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) =>
              AlertDialog(
                title: SizedBox(
                  width: MediaQuery
                      .of(parentContext)
                      .size
                      .width * 0.5,
                  height: MediaQuery
                      .of(parentContext)
                      .size
                      .height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                              "DESEJA REALMENTE REMOVER ESTE SERVIÇO?")),
                      Divider(
                        thickness: 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppColors.shape,
                          ),
                          width: MediaQuery
                              .of(parentContext)
                              .size
                              .width * 0.4,
                          height: MediaQuery
                              .of(parentContext)
                              .size
                              .height * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width:  MediaQuery
                                    .of(parentContext)
                                    .size
                                    .width * 0.4,
                                height:  MediaQuery
                                    .of(parentContext)
                                    .size
                                    .height * 0.06,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(profissional.nome!,
                                    style: AppTextStyles.labelBlackBold20Slin,),
                                ),
                              ),
                              //desc serviço
                              SizedBox(
                                  width:  MediaQuery
                                      .of(parentContext)
                                      .size
                                      .width * 0.4,
                                  height:  MediaQuery
                                      .of(parentContext)
                                      .size
                                      .height * 0.06,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(getNomeServicoById(servicoProfissional.idServico!),
                                      style: AppTextStyles.labelBlack16Lex,
                                    ),
                                  )

                              ),
                              //valor
                              SizedBox(
                                  width:  MediaQuery
                                      .of(parentContext)
                                      .size
                                      .width * 0.4,
                                  height:  MediaQuery
                                      .of(parentContext)
                                      .size
                                      .height * 0.06,
                                  child: Row(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text("VALOR: R\$ ", style: AppTextStyles.labelBlack16Lex,),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text("${servicoProfissional.valor!} ", style: AppTextStyles.labelBlackBold20Slin,),
                                      )
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width:  MediaQuery
                              .of(parentContext)
                              .size
                              .width * 0.25,
                          height:  MediaQuery
                              .of(parentContext)
                              .size
                              .height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonWidget(
                                onTap: () {
                                  Provider.of<ServicoProfissionalProvider>(context,listen: false).remove
                                    (servicoProfissional.id1);
                                  // Navigator.pop(parentContext);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/profissionais", (_) => false);
                                },
                                label: "Excluir",
                                width: MediaQuery.of(context).size.width * 0.07,
                                height: MediaQuery.of(context).size.height * 0.065,),
                              ButtonWidget(
                                onTap: () {

                                  Navigator.pop(parentContext);
                                },
                                label: "Cancelar",
                                width: MediaQuery.of(context).size.width * 0.07,
                                height: MediaQuery.of(context).size.height * 0.065,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ));
        }
    );
  }



  //----------------------------------------------------------------

  static Future<void>
  adicionarServicoProfissional(
      parentContext, String uid,
      Profissional profissional,
      List<Servico> servicos,
      ){
    String idServDrop = servicos.first.id1;
    String valor = "";
    var controller = TextEditingController();
    late bool _valido = false;
    final _form = GlobalKey<FormState>();
    servicos.sort((a,b)=>a.descricao!.compareTo(b.descricao!));
    String dropdown = servicos.first.descricao!;

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

    String getIdByDescricao(String descricao){
      String result = "";
      servicos.forEach((element) {
        if (element.descricao!.compareTo(descricao)==0){
          result = element.id1;
        }
      });

      return result;
    }

    String getNomeServicoById(String id){
      String result ="";
      var nome = servicos.firstWhere((element) => element.id1==id,);
      return nome.descricao!;
    }

    bool checkServico(String id){

      return true;
    }

    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) =>
              AlertDialog(
                title: SizedBox(
                  width: MediaQuery
                      .of(parentContext)
                      .size
                      .width * 0.5,
                  height: MediaQuery
                      .of(parentContext)
                      .size
                      .height * 0.5,
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text(
                                "ADICIONAR SERVIÇO")),
                        Divider(
                          thickness: 2,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: AppColors.shape,
                            ),
                            width: MediaQuery
                                .of(parentContext)
                                .size
                                .width * 0.4,
                            height: MediaQuery
                                .of(parentContext)
                                .size
                                .height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //nome Profissional
                                SizedBox(
                                  width:  MediaQuery
                                      .of(parentContext)
                                      .size
                                      .width * 0.4,
                                  height:  MediaQuery
                                      .of(parentContext)
                                      .size
                                      .height * 0.06,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(profissional.nome!,
                                      style: AppTextStyles.labelBlackBold20Slin,),
                                  ),
                                ),
                                //
                                // //desc serviço
                                // SizedBox(
                                //     width:  MediaQuery
                                //         .of(parentContext)
                                //         .size
                                //         .width * 0.4,
                                //     height:  MediaQuery
                                //         .of(parentContext)
                                //         .size
                                //         .height * 0.06,
                                //     child: FittedBox(
                                //       fit: BoxFit.scaleDown,
                                //       alignment: Alignment.centerLeft,
                                //       child: Text(getNomeServicoById(servicoProfissional.idServico!),
                                //         style: AppTextStyles.labelBlack16Lex,
                                //       ),
                                //     )
                                //
                                // ),
                                // //valor
                                // SizedBox(
                                //     width:  MediaQuery
                                //         .of(parentContext)
                                //         .size
                                //         .width * 0.4,
                                //     height:  MediaQuery
                                //         .of(parentContext)
                                //         .size
                                //         .height * 0.06,
                                //     child: Row(
                                //       children: [
                                //         FittedBox(
                                //           fit: BoxFit.scaleDown,
                                //           alignment: Alignment.centerLeft,
                                //           child: Text("VALOR: R\$ ", style: AppTextStyles.labelBlack16Lex,),
                                //         ),
                                //         FittedBox(
                                //           fit: BoxFit.scaleDown,
                                //           alignment: Alignment.centerLeft,
                                //           child: Text("${servicoProfissional.valor!} ", style: AppTextStyles.labelBlackBold20Slin,),
                                //         )
                                //       ],
                                //     )
                                // ),
                                // //Mensagem de erro
                                //
                                // SizedBox(
                                //   width:  MediaQuery
                                //       .of(parentContext)
                                //       .size
                                //       .width * 0.4,
                                //   height:  MediaQuery
                                //       .of(parentContext)
                                //       .size
                                //       .height * 0.06,
                                //   child: FittedBox(
                                //     fit: BoxFit.scaleDown,
                                //     alignment: Alignment.centerLeft,
                                //     child: Text("VALOR: R\$ ", style: AppTextStyles.labelBlack16Lex,),
                                //   ),
                                // ),

                                //DROPDOWN SERVICO
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
                                                idServDrop = getIdByDescricao(newValue);
                                              });
                                            },
                                            items: getDropdownServicos(servicos),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                //Valor Serviço
                                SizedBox(
                                  width: MediaQuery.of(parentContext).size.width * 0.2,
                                  child: InputTextWidgetMask(
                                    controller: controller,
                                    // initalValue: valor,
                                    label: "Valor",
                                    icon: Icons.onetwothree,
                                    validator: (value) {
                                      print("Validate $value");
                                      if ((value!.isEmpty) || (value == null)) {
                                        return 'Insira um valor';
                                      }
                                      if (value.length<5){
                                        return 'Valor deve ser maior que 10,00';
                                      }
                                      //VERIFICAR SE JÁ EXISTE ESTE SERVIÇO
                                      // if (servicos.contains(getServicoByDesc(dropdown, _listServ))){
                                      //   return 'Serviço já cadastrado';
                                      // }

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



                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width:  MediaQuery
                                .of(parentContext)
                                .size
                                .width * 0.25,
                            height:  MediaQuery
                                .of(parentContext)
                                .size
                                .height * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonWidget(
                                  onTap: () {
                                    if (_form.currentState!.validate()) {
                                      //id serviço
                                        Provider.of<ServicoProfissionalProvider>(
                                          context, listen: false).put(ServicosProfissional(
                                          valor: valor,
                                          idServico: idServDrop,
                                          idProfissional: profissional.id1,
                                        )).then(
                                            (value) =>
                                            Navigator.pushNamedAndRemoveUntil(
                                                context, "/profissionais", (_) => false)
                                        );
                                    }
                                    // Provider.of<ServicoProfissionalProvider>(context,listen: false).remove
                                    //   (servicoProfissional.id1);
                                    // Navigator.pop(parentContext);
                                    // Navigator.pushNamedAndRemoveUntil(
                                    //     context, "/profissionais", (_) => false);
                                  },
                                  label: "Adicionar",
                                  width: MediaQuery.of(context).size.width * 0.07,
                                  height: MediaQuery.of(context).size.height * 0.065,),
                                ButtonWidget(
                                  onTap: () {

                                    Navigator.pop(parentContext);
                                  },
                                  label: "Cancelar",
                                  width: MediaQuery.of(context).size.width * 0.07,
                                  height: MediaQuery.of(context).size.height * 0.065,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),

              ));
        }
    );
  }
}
