import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/provider/especialidade_provider.dart';
import 'package:psico_sis/widgets/input_text_widget2.dart';

import '../model/Especialidade.dart';
import '../model/Profissional.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class DialogsProfissional {

  static Future<void> AlertDialogConfirmarProfissional(parentContext, Profissional profissional) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Confirme o cadastro do Profissional"),
              Divider(thickness: 2,),
              //nome
              Row(
                children: [
                  Text("Nome: "),
                  Text("${profissional.nome}"),
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

            ],
          ),

          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {
                  AlertDialogConfirmarEspecialidadeProfissional(parentContext,profissional);
                }
            ),
            SimpleDialogOption(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(parentContext);
                }
            ),
          ],
        );
      },
    );
  }

  static Future<void> AlertDialogConfirmarEspecialidadeProfissional(parentContext, Profissional profissional) async {
    List<Especialidade> _listEsp = [];
    List<Especialidade> _listAdd = [];
    await Provider.of<EspecialidadeProvider>(parentContext, listen: false)
        .getListEspecialidades1().then((value) {
          _listEsp = value;
          _listEsp.sort((a,b)=> a.descricao.toString().compareTo(b.descricao.toString()));
    });

    String dropdown = _listEsp.first.descricao;
    List<DropdownMenuItem<String>> getDropdownEspecialidades(List<Especialidade> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i=0; i<list.length; i++){
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
          builder: (context, setState) => AlertDialog(
            title: Column(
              children: [
                Text("Adicione uma Especialidade ao Profissional"),
                Divider(thickness: 2,),
                //nome
                Row(
                  children: [
                    Text("Nome: "),
                    Text("${profissional.nome}"),
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
                Divider(thickness: 2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Adicione ao menos uma especialidade: "),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(parentContext).size.width*0.2,
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
                                items: getDropdownEspecialidades(_listEsp),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(parentContext).size.width*0.2,
                      child: InputTextWidget2(
                        label: "CÓDIGO (OPCIONAL)",
                        icon: Icons.onetwothree,
                        validator: (value) {
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                    ),
                    InkWell(
                      onTap: (){
                        Especialidade esp = Provider.of<EspecialidadeProvider>
                          (parentContext, listen: false)
                            .getEspByDesc(dropdown, _listEsp);
                        if (_listAdd.contains(esp)==false){
                          _listAdd.add(esp);
                        }

                        setState((){});
                      },
                      child: Icon(
                          size: 50,
                          Icons.add_circle),
                    ),

                  ],
                ),
                Column(
                  children: [
                    for(int i=0; i<_listAdd.length; i++)
                      Row(
                        children: [
                          Text("Especialidade ${i+1}:"),
                          Text(" ${_listAdd[i].descricao}", style: AppTextStyles.labelBlack16Lex,),
                        ],
                      )

                  ],
                )

              ],
            ),

            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("Salvar"),
                  onPressed: () {
                    AlertDialogConfirmarDiasProfissional(parentContext, profissional, _listAdd);
                  }
              ),
              SimpleDialogOption(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(parentContext);
                  }
              ),
            ],
          ),
        );
      },
    );
  }


  static Future<void> AlertDialogConfirmarDiasProfissional(parentContext, Profissional profissional, List<Especialidade> especialidade) async {
    //HORARIO FUNCIONAMENTO CLINICA
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
      "19:00"
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
      true,
      false,
      false,
      false,
      false,
      false,
    ];


    return showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Column(
              children: [
                Text("Selecione os dias que o Profissional atua"),
                Divider(thickness: 2,),


              ],
            ),

            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("Salvar"),
                  onPressed: () {}
              ),
              SimpleDialogOption(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(parentContext);
                  }
              ),
            ],
          ),
        );
      },
    );
  }

}

