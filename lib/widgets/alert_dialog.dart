import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/Especialidade.dart';
import 'package:psico_sis/model/pacientes_parceiros.dart';
import 'package:psico_sis/model/tipo_pagamento.dart';
import 'package:psico_sis/provider/especialidade_provider.dart';
import 'package:psico_sis/provider/paciente_parceiro_provider.dart';
import 'package:psico_sis/provider/paciente_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/themes/app_colors.dart';
import '../model/Paciente.dart';
import '../model/Parceiro.dart';
import '../model/Profissional.dart';
import '../model/consulta.dart';
import '../model/log_sistema.dart';
import '../model/servico.dart';
import '../provider/log_provider.dart';
import '../provider/parceiro_provider.dart';
import '../themes/app_text_styles.dart';
import 'drop_down_widget.dart';
import 'input_text_lower_widget.dart';
import 'input_text_uper_widget.dart';
import 'input_text_widget.dart';
import 'input_text_widget2.dart';
import 'input_text_widget_mask.dart';
import 'list_hours_widget.dart';

class Dialogs {
  static Future<void> showMyDialog(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Title"),
          children: <Widget>[
            SimpleDialogOption(child: Text("Option1"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option2"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option3"), onPressed: () {})
          ],
        );
      },
    );
  }

  static Future<void> AlertDialogProfissional(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Especialidade"),
          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {}
            ),
            SimpleDialogOption(child: Text("Option2"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option3"), onPressed: () {})
          ],
        );
      },
    );
  }

/*
  static Future<void> AlertSalasHoras(parentContext, String dia) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("SALAS"),

              Container(
                color: AppColors.primaryColor,
                width: 400,
                child: Column(
                  children: [
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn(),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn2(),
                    ),
                  ],
                ),
              )
            ],
          ),

          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            SimpleDialogOption(child: Text("Cancelar"), onPressed: () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }
*/

  // Future<Usuario> getUsuarioByUid(String uid) async {
  //   print("uid getUsuarioByUid $uid");
  //   if (uid.isEmpty){
  //     print("empity");
  //     String _uidGet ="";
  //     print("_uidGet $_uidGet");
  //     return Provider.of<UsuarioProvider>(context, listen: false)
  //         .getUsuarioByUid2(uid);
  //   } else{
  //     print(" not empity");
  //     return Provider.of<UsuarioProvider>(context, listen: false)
  //         .getUsuarioByUid2(uid);
  //   }
  //
  // }

  //ALTERAR ESPECIALIDADE

  static Future<void> AlertAlterarEspecialidade(parentContext,Especialidade especialidade, String uid) {

    final _form = GlobalKey<FormState>();
    String _descEspecialidade=especialidade.descricao;
    print("id_especialidade $_descEspecialidade");

    print("$_descEspecialidade desssc");

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context){
          return AlertDialog(
            title: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ALTERAR ESPECIALIDADE ${_descEspecialidade}"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.35,
                    child: InputTextUperWidget(
                      label: "DESCRIÇÃO ESPECIALIDADE",
                      initalValue: _descEspecialidade,
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        if (value.compareTo(especialidade.descricao)==0){
                          return 'Altere a descrição da Especialidade';
                        }
                        return null;
                      },
                      onChanged: (value){
                        _descEspecialidade = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("ALTERAR"),
                  onPressed: () {
                    if(_form.currentState!.validate()){
                      //Alterando Especialidade
                      Provider.of<EspecialidadeProvider>(context, listen: false)
                          .put(Especialidade(
                        idEspecialidade: especialidade.idEspecialidade,
                        descricao: _descEspecialidade,
                      )).then((value) {
                        Provider.of<LogProvider>(context, listen: false)
                            .put(LogSistema(
                          data: DateTime.now().toString(),
                          uid_usuario: uid,
                          descricao: "Alterando especialidade",
                          id_transacao: especialidade.idEspecialidade,
                        ));
                        // Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, "/especialidades");
                      });
                    }

                  }
              ),
              SimpleDialogOption(

                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),

            ],
          );
        }
    );
  }


  // SALVAR PACIENTE
  // alocar parceiro ao paciente
  static Future<void> AlertConfirmarPaciente(parentContext,
      String nome,
      String endereco,
      String data,
      String telefone,
      String cpf,
      int numero,
      List<Parceiro> list,
      String uid) {

    bool _isCheck = false;
    final _form = GlobalKey<FormState>();

    List<DropdownMenuItem<String>> getDropdownParceiros(List<Parceiro> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i=0; i<list.length; i++){

        var newDropdown = DropdownMenuItem(
          value: list[i].razaoSocial.toString(),
          child: Text(list[i].razaoSocial.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    String dropdownTpConsulta = list.first.razaoSocial.toString();
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context){
          return StatefulBuilder(
            builder: (parentContext, setState) =>
                AlertDialog(
                  title: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SALVAR PACIENTE"),
                        //NOME
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Row(
                            children: [
                              Text("Nome: "),
                              Text("$nome"),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Row(
                            children: [
                              Text("Endereço: "),
                              Text("$endereco"),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Row(
                            children: [
                              Text("Numero: "),
                              Text("$numero"),
                            ],
                          ),
                        ),


                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Row(
                            children: [
                              Text("Telefone: "),
                              Text("$telefone"),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Row(
                            children: [
                              Text("CPF: "),
                              Text("$cpf"),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Row(
                            children: [
                              Text("DATA NASCIMENTO: "),
                              Text("$data"),
                            ],
                          ),
                        ),
                        //Parceiro
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.greenAccent,
                              activeColor: Colors.red,
                              value: _isCheck,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCheck = value!;
                                });
                              },
                            ),
                            // if (_isCheck)
                            Text('ADICIONAR PARCEIRO', style: AppTextStyles.labelBlack16Lex, ),

                          ],
                        ),
                        if (_isCheck)
                          SizedBox(
                            width: MediaQuery.of(parentContext).size.width*0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selecione o PARCEIRO",
                                  style: AppTextStyles.subTitleBlack16,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.labelWhite),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: DropdownButton<String>(
                                      value: dropdownTpConsulta,
                                      icon: const Icon(
                                          Icons.arrow_drop_down_sharp),
                                      elevation: 16,
                                      style: TextStyle(
                                          color: AppColors.labelBlack),
                                      underline: Container(
                                        height: 2,
                                        color: AppColors.line,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownTpConsulta = newValue!;
                                        });
                                      },


                                      items: getDropdownParceiros(list),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                      ],
                    ),
                  ),
                  actions: <Widget>[
                    SimpleDialogOption(
                        child: Text("CONFIRMAR"),
                        onPressed: () {
                          if(_form.currentState!.validate()){
                            //SALVANDO PACIENTE
                            int id_paciente = 0;
                            int idParceiro = 0;
                            //checando se existe um paciente com o mesmo nome

                            Provider.of<PacienteProvider>(context, listen: false)
                                .put(Paciente(
                              nome: nome,
                              cpf: cpf,
                              endereco: endereco,
                              numero: numero,
                              dataNascimento: data,
                              telefone: telefone,
                            )).then((value) async {
                               await Provider.of<PacienteProvider>(context, listen: false)
                                  .getCount().then((value1) {
                                   id_paciente = value1;
                                  idParceiro = Provider.of<ParceiroProvider>(context, listen: false)
                                    .getIdByRazao(dropdownTpConsulta, list);
                               });

                               if (_isCheck){
                                 //salvando paciente Parceiro
                                 await Provider.of<PacientesParceirosProvider>(context, listen: false)
                                     .put(PacientesParceiros(
                                     idPaciente: id_paciente,
                                     idParceiro: idParceiro,
                                     status: "ATIVO"
                                 ));
                                 await Provider.of<LogProvider>(context, listen: false)
                                     .put(LogSistema(
                                   data: DateTime.now().toString(),
                                   uid_usuario: uid,
                                   descricao: "INSERIU PACIENTE/PARCEIRO",
                                   id_transacao: id_paciente,
                                 ));
                               }

                                //SALVANDO LOG
                                await Provider.of<LogProvider>(context, listen: false)
                                    .put(LogSistema(
                                  data: DateTime.now().toString(),
                                  uid_usuario: uid,
                                  descricao: "INSERIU PACIENTE",
                                  id_transacao: id_paciente,
                                ));
                              Navigator.pushReplacementNamed(context, "/cadastro_paciente");
                            });
                          }

                        }
                    ),
                    SimpleDialogOption(
                        child: Text("CANCELAR"),
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    ),

                  ],
                ),
          );
        }
    );
  }


  //ALTERAR PACIENTE
  static Future<void> AlertAlterarPaciente(parentContext,
      Paciente paciente,String primeiroParceiro, String id_parceiro, List<Parceiro> list,
      List<PacientesParceiros> listPP, String uid) async {
    bool _isCheck = false;
    bool _alocarParceiro = false;
    bool _desalocarParceiro = false;

    Parceiro? parceiro;
    Provider.of<ParceiroProvider>(parentContext, listen: false)
        .getParceiroById2(id_parceiro, list).then((value) {
      parceiro = value;
      print("existParceiro ");
    } );

    if (id_parceiro.compareTo("0")==0){
      print("aloca");
      _alocarParceiro = true;
    } else {
      print("desaloca");
      _desalocarParceiro = true;
      print("desaloca $_desalocarParceiro");
    }
    print("List<Parceiro> list ${list.length}");
    final _form = GlobalKey<FormState>();
    String _nome = paciente.nome!;
    int _numero = paciente.numero!;
    String _endereco = paciente.endereco!;
    String _telefone = paciente.telefone!;
    String _dataNascimento =paciente.dataNascimento!;
    String _cpf = paciente.cpf!;
    print("_nome ${_nome}");
    print("_endereco ${_endereco}");
    print("_telefone ${_telefone}");


    String dropdown = primeiroParceiro;
    List<DropdownMenuItem<String>> getDropdownParceiros(List<Parceiro> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i=0; i<list.length; i++){
        var newDropdown = DropdownMenuItem(
          value: list[i].razaoSocial.toString(),
          child: Text(list[i].razaoSocial.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }
    print("compareto ${dropdown.compareTo(list.first.razaoSocial.toString())}");
    print("dropdownTpConsulta ${dropdown}");

    bool isValidDate(String date) {
      try {
        DateTime.parse(date);
        return true;
      } catch (e) {
        return false;
      }
    }


    return showDialog(
      barrierColor: AppColors.shape,
      context: parentContext,
      builder: (context) =>
          StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(child: Text("ALTERAR PACIENTE")),
                    ),

                    //NOME
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: InputTextUperWidget(
                        label: "NOME PACIENTE",
                        initalValue: _nome,
                        icon: Icons.edit,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Insira um NOME';
                          }
                          return null;
                        },
                        onChanged: (value){
                          _nome = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                    ),
                    //CPF
                    Row(
                      children: [
                        //CPF
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.2,
                          child: InputTextWidgetMask(
                            label: "CPF",
                            initalValue: _cpf,
                            icon: Icons.badge_outlined,
                            input: CpfInputFormatter(),
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Insira um CPF';
                              }
                              if (value.length<11) {
                                return 'CPF incompleto';
                              } else {
                                if (UtilBrasilFields.isCPFValido(value)==false){
                                  return 'CPF inválido.';}
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _cpf = value;
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                        ),
                        //TELEFONE
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.2,
                          child: InputTextWidgetMask(
                            input: TelefoneInputFormatter(),
                            initalValue: _telefone,
                            label: "TELEFONE",
                            icon: Icons.local_phone,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Insira um TELEFONE';
                              }
                              if (value.length<14){
                                return 'Número Incompleto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _telefone = value;
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                        ),

                      ],
                    ),
                    //ENDEREÇO
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.26,
                          child: InputTextUperWidget(
                            label: "ENDEREÇO",
                            initalValue: _endereco,
                            icon: Icons.location_on_outlined ,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Insira um ENDEREÇO';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _endereco = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.142,
                          child: InputTextWidgetMask(
                            input: FilteringTextInputFormatter.digitsOnly,
                            label: "NÚMERO",
                            initalValue: _numero.toString(),
                            icon: Icons.onetwothree,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Insira um NÚMERO';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _numero = int.parse(value);
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                        ),

                      ],
                    ),
                    //DATA NASCIMENTO
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.2,
                      child: InputTextWidgetMask(
                        label: "DATA DE NASCIMENTO",
                        icon: Icons.date_range_rounded ,
                        input: DataInputFormatter(),
                        initalValue: _dataNascimento,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Insira um texto';
                          }
                          if (value.length<10){
                            return 'Data incompleta';
                          } else {
                            ///validar data;
                            if (isValidDate(value)){
                              return 'Data inválida';
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _dataNascimento = value;
                        },
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                    ),

                    //Parceiro
                    (_desalocarParceiro) ?
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text('PARCEIRO: ', style: AppTextStyles.labelBlack14Lex, ),
                            ),
                            Text(parceiro!.razaoSocial.toString(), style: AppTextStyles.labelBlack16Lex, ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Checkbox(
                                checkColor: Colors.greenAccent,
                                activeColor: Colors.red,
                                value: _isCheck,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isCheck = value!;
                                  });
                                },
                              ),
                            ),
                            Text('DESVINCULAR PARCEIRO', style: AppTextStyles.labelBlack16Lex, ),
                          ],
                        ),


                      ],
                    )
                        :
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Checkbox(
                            checkColor: Colors.greenAccent,
                            activeColor: Colors.red,
                            value: _isCheck,
                            onChanged: (bool? value) {
                              setState(() {
                                _isCheck = value!;
                                print("valor drop $dropdown");
                              });
                            },
                          ),
                        ),
                        // if (_isCheck)
                        Text('ADICIONAR PARCEIRO', style: AppTextStyles.labelBlack16Lex, ),

                      ],
                    ),

                    if ((_isCheck)&&(_alocarParceiro))
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: SizedBox(
                          width: MediaQuery.of(parentContext).size.width*0.35,
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
                                    icon: const Icon(
                                        Icons.arrow_drop_down_sharp),
                                    elevation: 16,
                                    style: TextStyle(
                                        color: AppColors.labelBlack),
                                    underline: Container(
                                      height: 2,
                                      color: AppColors.line,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdown = newValue!;
                                      });
                                    },
                                    items: getDropdownParceiros(list),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("ALTERAR"),
                    onPressed: () {
                      if(_form.currentState!.validate()){
                        //Alterando PACIENTE
                        Provider.of<PacienteProvider>(context, listen: false)
                            .put(Paciente(
                          idPaciente: paciente.idPaciente,
                          nome: _nome,
                          cpf: _cpf,
                          endereco: _endereco,
                          numero: _numero,
                          dataNascimento: _dataNascimento,
                          telefone: _telefone,
                        )).then((value) async {

                          //SE FOR ALOCAR OU DESALOCAR SALVAR NO PACIENTES PARCEIROS
                          String result = "";
                          if (_isCheck){
                            if (_alocarParceiro){
                              int idParceiroAlocado = Provider.of<ParceiroProvider>(context, listen: false)
                                  .getIdByRazao(dropdown, list);
                              await Provider.of<LogProvider>(context, listen: false)
                                  .put(LogSistema(
                                data: DateTime.now().toString(),
                                uid_usuario: uid,
                                descricao: "ALTEROU PACIENTE",
                                id_transacao: paciente.idPaciente,
                              ));
                              await Provider.of<PacientesParceirosProvider>(context, listen: false)
                                  .put(PacientesParceiros(
                                  idPaciente: paciente.idPaciente,
                                  idParceiro: idParceiroAlocado,
                                  status: 'ATIVO'
                              ));

                              result = "INSERIU PACIENTE/PARCEIRO";

                            } else

                            if(_desalocarParceiro){
                              print("DESALOCAR");
                              //pegando id a ser alterado
                              int idPP = Provider.of<PacientesParceirosProvider>(context, listen: false)
                                  .getIdByRazao(paciente.idPaciente.toString(), id_parceiro, listPP);
                              print("idPP $idPP");
                              await Provider.of<LogProvider>(context, listen: false)
                                  .put(LogSistema(
                                data: DateTime.now().toString(),
                                uid_usuario: uid,
                                descricao: "ALTEROU PACIENTE",
                                id_transacao: paciente.idPaciente,
                              ));
                              await Provider.of<PacientesParceirosProvider>(context, listen: false)
                                  .put(PacientesParceiros(
                                  idPacientesParceiros: idPP,
                                  idPaciente: paciente.idPaciente,
                                  idParceiro: int.parse(id_parceiro),
                                  status: 'INATIVO'
                              ));

                              result = "DESALOCOU PACIENTE/PARCEIRO";
                              print("desalocou");
                            }
                          }
                          print("log result $result");
                          Provider.of<LogProvider>(context, listen: false)
                              .put(LogSistema(
                            data: DateTime.now().toString(),
                            uid_usuario: uid,
                            descricao: result,
                            id_transacao: paciente.idPaciente,
                          ));
                          Navigator.pushReplacementNamed(context, "/home_assistente");
                        });
                      }

                    }
                ),
                SimpleDialogOption(

                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),

              ],
            ),
          ),

    );
  }

  static Future<void> AlertAlterarServico(parentContext,Servico servico, String uid) {

    final _form = GlobalKey<FormState>();
    String _descServico = servico.descricao!;
    String _qtdSessoes = servico.qtd_sessoes!.toString();
    String _qtdPacientes = servico.qtd_pacientes!.toString();

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context){
          return AlertDialog(
            title: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ALTERAR SERVIÇO ${_descServico}"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.35,
                    child: InputTextUperWidget(
                      label: "DESCRIÇÃO SERVIÇO",
                      initalValue: _descServico,
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        return null;
                      },
                      onChanged: (value){
                        _descServico = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.35,
                    child: InputTextWidget2(
                      label: "QUANTIDADE SESSÕES",
                      initalValue: _qtdSessoes.toString(),
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        return null;
                      },
                      onChanged: (value){
                        _qtdSessoes = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.35,
                    child: InputTextWidget2(
                      label: "QUANTIDADE PACIENTES",
                      initalValue: _qtdPacientes,
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        return null;
                      },
                      onChanged: (value){
                        _qtdPacientes = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("ALTERAR"),
                  onPressed: () {
                    if(_form.currentState!.validate()){
                      //Alterando Especialidade
                      Provider.of<ServicoProvider>(context, listen: false)
                          .put(Servico(
                        id: servico.id,
                        descricao: _descServico,
                        qtd_pacientes: int.parse(_qtdPacientes),
                        qtd_sessoes: int.parse(_qtdSessoes),
                      )).then((value) {
                        Provider.of<LogProvider>(context, listen: false)
                            .put(LogSistema(
                          data: DateTime.now().toString(),
                          uid_usuario: uid,
                          descricao: "Alterando Serviço",
                          id_transacao: servico.id,
                        ));
                        Navigator.pop(context);
                      });
                    }

                  }
              ),
              SimpleDialogOption(

                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),

            ],
          );
        }
    );
  }

  static Future<void> AlertAlterarParceiro(parentContext,Parceiro parceiro, String uid) {

    print("razaoSocial ${parceiro.razaoSocial}");
    print("numero ${parceiro.numero}");
    print("telefone ${parceiro.telefone}");
    print("id ${parceiro.id}");
    print("status ${parceiro.status}");
    print("desconto ${parceiro.desconto}");
    print("email ${parceiro.email}");
    print("cnpj ${parceiro.cnpj}");
    print("endereco ${parceiro.endereco}");

    final _form = GlobalKey<FormState>();
    String _razao = parceiro.razaoSocial!;
    String _cnpj = parceiro.cnpj!;
    String _email = parceiro.email!;
    String _telefone = parceiro.telefone!;
    String _status = parceiro.status!;
    String _endereco = parceiro.endereco!;
    int _desconto = parceiro.desconto!;
    int _numero = parceiro.numero!;
    String _porcentagem = "5";
    print("id_razao $_razao");

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) => StatefulBuilder(

            builder: (context, setState) => AlertDialog(
              title: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("ALTERAR PARCEIRO ${parceiro.razaoSocial}")),
                    //razão social
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.35,
                      child: InputTextUperWidget(
                        label: "RAZÃO SOCIAL",
                        initalValue: parceiro.razaoSocial,
                        icon: Icons.edit,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira uma RAZÃO SOCIAL';
                          }
                          return null;
                        },
                        onChanged: (value){
                          _razao = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                    ),
                    //cnpj
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.35,
                      child: InputTextWidgetMask(
                        label: "CNPJ",
                        initalValue: parceiro.cnpj,
                        icon: Icons.badge_outlined,
                        input: CnpjInputFormatter(),
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira uma RAZÃO SOCIAL';
                          }
                          return null;
                        },
                        onChanged: (value){
                          _cnpj = value;
                        },
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                    ),
                    // telefone
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.35,
                      child: InputTextWidgetMask(
                        label: "TELEFONE",
                        initalValue: parceiro.telefone,
                        icon: Icons.local_phone,
                        input: TelefoneInputFormatter(),
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira um TELEFONE';
                          }
                          return null;
                        },
                        onChanged: (value){
                          _telefone = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                    ),
                    //email
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.35,
                      child: InputTextLowerWidget(
                        label: "EMAIL",
                        initalValue: parceiro.email,
                        icon: Icons.email_rounded,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira uma EMAIL';
                          }
                          return null;
                        },
                        onChanged: (value){
                          _email = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                    ),
                    //endereço
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.21,
                          child: InputTextUperWidget(
                            label: "ENDEREÇO",
                            initalValue: parceiro.endereco,
                            icon: Icons.location_on_outlined,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira uma ENDEREÇO';
                              }
                              return null;
                            },
                            onChanged: (value){
                              _endereco = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                        ),
                        //numero
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.14,
                          child: InputTextWidget2(
                            label: "NÚMERO",
                            initalValue: parceiro.numero.toString(),
                            icon: Icons.edit,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira uma RENDEREÇO';
                              }
                              return null;
                            },
                            onChanged: (value){
                              _numero = int.parse(value);
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Desconto"),
                        DropDownWidget(
                          list: ["5","10","15","20","25","30","35","40"],
                          valueDrop1: _desconto.toString(),
                          onChanged: (value){
                            _porcentagem = value!;
                            _desconto = int.parse(_porcentagem);
                            setState((){});

                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("ALTERAR"),
                    onPressed: () {
                      if(_form.currentState!.validate()){
                        //Alterando PARCEIRO
                        Provider.of<ParceiroProvider>(context, listen: false)
                            .put(Parceiro(
                          id: parceiro.id,
                          razaoSocial: _razao,
                          telefone: _telefone,
                          endereco: _endereco,
                          email: _email,
                          desconto: _desconto,
                          status: _status,
                          cnpj: _cnpj,
                          numero: _numero,
                        )).then((value) {
                          print("salvou");
                          Provider.of<LogProvider>(context, listen: false)
                              .put(LogSistema(
                            data: DateTime.now().toString(),
                            uid_usuario: uid,
                            descricao: "ALTEROU PARCEIRO",
                            id_transacao: parceiro.id,
                          ));
                          Navigator.pop(context);
                          // Navigator.pushReplacementNamed(context, "/home_assistente");
                        });
                      }

                    }
                ),
                SimpleDialogOption(

                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),

              ],
            ))
    );
  }



  static Future<void> AlertCadastrarDespesa(parentContext,){

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context){
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Despesa"),
                SizedBox(
                  width: MediaQuery.of(parentContext).size.width*0.35,
                  child: InputTextWidget(
                    label: "DESCRIÇÃO DESPESA",
                    icon: Icons.edit,
                    validator: (value) {
                      if ((value!.isEmpty) || (value == null)) {
                        return 'Por favor insira um texto';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.line,
                    textStyle:  AppTextStyles.subTitleBlack12,
                    iconColor: AppColors.labelBlack,),
                ),
                SizedBox(
                  width: MediaQuery.of(parentContext).size.width*0.2,
                  child: InputTextWidget(
                    label: "VALOR",
                    icon: Icons.monetization_on_outlined,
                    validator: (value) {
                      if ((value!.isEmpty) || (value == null)) {
                        return 'Por favor insira um texto';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.line,
                    textStyle:  AppTextStyles.subTitleBlack12,
                    iconColor: AppColors.labelBlack,),
                )
              ],
            ),
            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("SALVAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
              SimpleDialogOption(

                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),

            ],
          );
        }
    );
  }

  static Future<void> AlertDetalhesProfissional(parentContext, Profissional profissional){
    return showDialog(
        context: parentContext,
        barrierColor: AppColors.shape,
        builder: (context){
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Detalhes Proffisional"),
                  Text(profissional.nome.toString(), style: AppTextStyles.labelBlack16Lex,),
                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }

  //FECHAR CAIXA
  static Future<void> AlertFecharCaixa(parentContext,){
    return showDialog(
        context: parentContext,
        barrierColor: AppColors.shape,
        builder: (context){
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("DESPESAS: 50,00"),
                Text("PAGAMENTO COMISSÃO"),
                Text("DINHEIRO"),
                Text("PIX"),
                Text("CARTÃO DE CRÉDITO"),
                Text("CARTÃO DE DÉDITO"),
              ],
            ),
            actions: [
              SimpleDialogOption(
                  child: Text("SALVAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
              SimpleDialogOption(

                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ],
          );
        }
    );
  }

  //PAGAMENTO COMISSÃO PROFISSIONAL
  static Future<void> AlertPagarProfissional(parentContext, List<Profissional> list){
    String dropdownTpConsulta = list.first.nome.toString();

    List<DropdownMenuItem<String>> getDropdownProfissionais(List<Profissional> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i=0; i<list.length; i++){
        var newDropdown = DropdownMenuItem(
          value: list[i].nome.toString(),
          child: Text(list[i].nome.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }
    return showDialog(
        context: parentContext,
        barrierColor: AppColors.shape,
        builder: (context){
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pagamento Comissão Proffisional"),
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width*0.35,
                    child: Column(
                      children: [
                        Text(
                          "Selecione o Profissional",
                          style: AppTextStyles.subTitleBlack16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.labelWhite),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButton<String>(
                              value: dropdownTpConsulta,
                              icon: const Icon(
                                  Icons.arrow_drop_down_sharp),
                              elevation: 16,
                              style: TextStyle(
                                  color: AppColors.labelBlack),
                              underline: Container(
                                height: 2,
                                color: AppColors.line,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownTpConsulta = newValue!;
                                });
                              },


                              items: getDropdownProfissionais(list),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //valor comissão
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width*0.2,
                    child: InputTextWidget(
                      label: "VALOR",
                      icon: Icons.monetization_on_outlined,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira um texto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                  )
                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("PAGAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
                SimpleDialogOption(

                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),

              ],
            ),
          );
        }
    );
  }

  //DropWidiget
  static Widget DropWidgetProfissional(parentContext, List<Profissional> list){
    String dropdownProfissional = list.first.nome.toString();

    List<DropdownMenuItem<String>> getDropdownProfissionais(List<Profissional> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i=0; i<list.length; i++){
        var newDropdown = DropdownMenuItem(
          value: list[i].nome.toString(),
          child: Text(list[i].nome.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }
    return  StatefulBuilder(
      builder: (parentContext, setState) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.labelWhite),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButton<String>(
            value: dropdownProfissional,
            icon: const Icon(
                Icons.arrow_drop_down_sharp),
            elevation: 16,
            style: TextStyle(
                color: AppColors.labelBlack),
            underline: Container(
              height: 2,
              color: AppColors.line,
            ),
            onChanged: (String? newValue) {

              setState(() {
                dropdownProfissional = newValue!;
                print(newValue);
                print(dropdownProfissional);
              });
            },
            items: getDropdownProfissionais(list),
          ),
        ),
      ),
    );

  }

  static Future<void> AlertFinalizarConsulta(parentContext, Consulta consulta ){
    String dropdownTpPagamento="";
    List<TipoPagamento> items = [];
    StreamSubscription<QuerySnapshot>? tpPagamentoSubscription;
    var db = FirebaseFirestore.instance;

    List<DropdownMenuItem<String>> getDropdownTpPagamento(){
      tpPagamentoSubscription?.cancel();
      tpPagamentoSubscription =
          db.collection("tipos_pagamento").snapshots().listen(
                  (snapshot) {
                items = snapshot.docs.map(
                        (documentSnapshot) => TipoPagamento.fromMap(
                      documentSnapshot.data(),
                      int.parse(documentSnapshot.id),
                    )
                ).toList();
                items.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
              });
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i=0; i<items.length; i++){
        var newDropdown = DropdownMenuItem(
          value: items[i].descricao.toString(),
          child: Text(items[i].descricao.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }
    return showDialog(
        context: parentContext,
        barrierColor: AppColors.shape,
        builder: (context){
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pagamento Comissão Proffisional"),
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width*0.35,
                    child: Column(
                      children: [
                        Text(
                          "Selecione o Tipo de pagamento",
                          style: AppTextStyles.subTitleBlack16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.labelWhite),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButton<String>(
                              value: dropdownTpPagamento,
                              icon: const Icon(
                                  Icons.arrow_drop_down_sharp),
                              elevation: 16,
                              style: TextStyle(
                                  color: AppColors.labelBlack),
                              underline: Container(
                                height: 2,
                                color: AppColors.line,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownTpPagamento = newValue!;
                                });
                              },
                              items: getDropdownTpPagamento(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //valor comissão
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width*0.2,
                    child: InputTextWidget(
                      label: "VALOR",
                      icon: Icons.monetization_on_outlined,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira um texto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                  )
                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("PAGAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
                SimpleDialogOption(

                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }

  //Opções Consulta
  static Future<void> AlertOpcoesConsulta(parentContext, Consulta consulta){
    bool check1=false, check2=false,check3=false;
    void zerarCheck(){
      check1=false;
      check2=false;
      check3=false;
    }

    return showDialog(
        context: parentContext,
        builder: (context){
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(consulta.dataConsulta.toString()),
                  Text(consulta.salaConsulta.toString()),
                  Text(consulta.horarioConsulta.toString()),
                  Text(consulta.tpConsulta.toString()),

                  Text(consulta.descConsulta.toString()),
                  Text("Valor: ${consulta.valorConsulta},00"),
                  Text("Situação: ${consulta.situacaoConsulta.toString()}"),
                  Divider(
                    color: AppColors.labelBlack,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Checkbox(value: check1, onChanged: (value){
                        zerarCheck();
                        check1=true;
                        setState((){});
                      }),
                      Text("Finalizar consulta")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: check2, onChanged: (value){
                        zerarCheck();
                        check2=true;
                        setState((){});
                      }),
                      Text("Reagendar consulta")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: check3, onChanged: (value){
                        zerarCheck();
                        check3=true;
                        setState((){});
                      }),
                      Text("Cancelar consulta")
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("Ok"),
                    onPressed: () {
                      if(check1){
                        print("entrou");
                        // AlertFinalizarConsulta(context,consulta);
                        Navigator.pop(context);
                      }

                    }
                ),
                SimpleDialogOption(child: Text("Cancelar"), onPressed: () {
                  Navigator.pop(context);
                }),
              ],
            ),
          );

        }
    );
  }

  static Future<void> AlertHorasTrabalhadas(parentContext, String dia) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Selecione os horários ofertados na "+dia),

              Container(
                color: AppColors.primaryColor,
                width: 400,
                child: Column(
                  children: [
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn(),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn2(),
                    ),
                  ],
                ),
              )
            ],
          ),

          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            SimpleDialogOption(child: Text("Cancelar"), onPressed: () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }

  static Future<void> AlertConfirmSistema(parentContext, String descricao) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text("DESEJA REALMENTE SALVAR O SISTEMA ABAIXO"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(descricao),
              ),
            ],
          ),

          actions: <Widget>[
            SimpleDialogOption(
                child: Text("SIM"),
                onPressed: () {

                  Navigator.pop(context);
                }
            ),
            SimpleDialogOption(child: Text("NÃO"), onPressed: () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }

}

List <Widget> ListHousColumn() {
  List <Widget> list = [];
  String hour = "";
  for (int i = 8; i < 14; i++) {
    if (i<10){
      hour = "0"+i.toString()+":00";
    } else {
      hour = i.toString()+":00";
    }
    list.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListHoursWidget(hour: hour,),

      ),
    ));
  }
  return list;
}

List <Widget> ListHousColumn2() {
  List <Widget> list = [];
  String hour = "";
  for (int i = 14; i < 20; i++) {
    if (i<10){
      hour = "0"+i.toString()+":00";
    } else {
      hour = i.toString()+":00";
    }
    list.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListHoursWidget(hour: hour,),

      ),
    ));
  }
  return list;
}