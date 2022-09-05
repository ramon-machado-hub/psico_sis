import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';

import '../model/Profissional.dart';
import '../model/consulta.dart';
import '../themes/app_text_styles.dart';
import 'input_text_widget.dart';
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

  static Future<void> AlertOpcoesConsulta(parentContext, Consulta consulta){
    bool? check1=false;
    return showDialog(
      context: parentContext,
      builder: (context){
        return AlertDialog(
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
                  Checkbox(value: check1, onChanged: (value){}),
                  Text("Finalizar consulta")
                ],
              ),
              Row(
                children: [
                  Checkbox(value: check1, onChanged: (value){}),
                  Text("Reagendar consulta")
                ],
              ),
              Row(
                children: [
                  Checkbox(value: check1, onChanged: (value){}),
                  Text("Cancelar consulta")
                ],
              )
            ],
          ),
          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            SimpleDialogOption(child: Text("Cancelar"), onPressed: () {
              Navigator.pop(context);
            }),
          ],
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
  bool selected = false;
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
  bool selected = false;
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