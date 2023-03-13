import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/model/transacao_caixa.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/widgets/button_disable_widget.dart';
import 'package:psico_sis/widgets/button_widget.dart';

import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/dias_profissional.dart';
import '../model/sessao.dart';
import '../provider/dias_profissional_provider.dart';
import '../provider/paciente_provider.dart';
import '../service/validator_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/input_text_uper_widget.dart';
import '../widgets/input_text_widget_mask.dart';

class DialogsPaciente {


  //ALTERAR DADOS PACIENTE
  static Future<void> AlterarDadosPaciente(parentContext, String uid,
      Paciente paciente,) {
    bool _exist = false;
    bool _change = false;
    final _form = GlobalKey<FormState>();
    String _nome ="",
        _data_nascimento = "",
        _nome_responsavel = "",
        _endereco = "",
        _telefone = "",
        _cpf ="";
    int _numero=0;

    Future<bool> containPaciente(setState, String nome) async{
      final result =
      await Provider.of<PacienteProvider>(parentContext, listen: false).existByName(nome);
      print("result $result");
      _exist = result;
      setState;
      return result;
    }

    bool isValidDate(String date) {
      try {
        DateTime.parse(date);
        return true;
      } catch (e) {
        return false;
      }
    }

    Size size = MediaQuery
        .of(parentContext)
        .size;
    return showDialog(
      barrierColor: AppColors.shape,
        context: parentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                      width: size.width * 0.7,
                      height: size.height * 0.8,
                      color: AppColors.labelWhite,
                      child: Form(
                        key: _form,
                        child: Container(
                          width: size.width * 0.5,
                          height: size.height * 0.7,
                          decoration: BoxDecoration(
                            color: AppColors.shape,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                                child: Text(
                                  "ALTERAR DADOS PACIENTE",
                                  style: AppTextStyles.labelBold16,
                                ),
                              ),
                              //nome
                              InputTextUperWidget(
                                label: "NOME PACIENTE",
                                icon: Icons.perm_contact_cal_sharp,
                                initalValue: paciente.nome,
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Insira um NOME';
                                  }
                                  if (_exist){
                                    return 'Paciente já cadastrado';
                                  }
                                },
                                onChanged: (value) {
                                  _nome = value;
                                  setState((){});
                                },
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle:  AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,),
                              //nome RESPONSÁVEL
                              InputTextUperWidget(
                                label: "NOME RESPONSÁVEL",
                                initalValue: paciente.nome_responsavel,
                                icon: Icons.person_pin_rounded,
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Insira um NOME';
                                  }

                                },
                                onChanged: (value) {
                                  _nome_responsavel = value;
                                  setState((){});
                                },
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle:  AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,),
                              //row cpf / telefone
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: InputTextWidgetMask(
                                      initalValue: paciente.cpf,
                                      label: "CPF RESPONSÁVEL",
                                      icon: Icons.badge_outlined,
                                      input: CpfInputFormatter(),
                                      validator: (value) {
                                        if ((value!.isEmpty) || (value == null)) {
                                          return 'Insira um CPF';
                                        }
                                        if (value.length<11) {
                                          return 'CPF incompleto';
                                        } else {
                                          // if (UtilBrasilFields.isCPFValido(value)==false){
                                          //   return 'CPF inválido.';}
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
                                  SizedBox(
                                    width: size.width * 0.25,
                                    child: InputTextWidgetMask(
                                      initalValue: paciente.telefone,
                                      input: TelefoneInputFormatter(),
                                      label: "TELEFONE",
                                      icon: Icons.local_phone,
                                      validator: (value) {
                                        if ((value!.isEmpty) || (value == null)) {
                                          return 'Insir TELEFONE';
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

                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width*0.406,
                                    child: InputTextUperWidget(
                                      initalValue: paciente.endereco,
                                      label: "ENDEREÇO",
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
                                    width: size.width*0.142,
                                    child: InputTextWidgetMask(
                                      input: FilteringTextInputFormatter.digitsOnly,
                                      initalValue: paciente.numero.toString(),
                                      label: "NÚMERO",
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

                              InputTextWidgetMask(
                                label: "DATA DE NASCIMENTO",
                                initalValue: paciente.dataNascimento,

                                icon: Icons.date_range_rounded ,
                                input: DataInputFormatter(),
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Insira um texto';
                                  }
                                  if (value.length<10){
                                    return 'Data incompleta';
                                  }
                                  if (ValidatorService.validateDate(value)==false){
                                    return 'Data inválida';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _data_nascimento = value;
                                },
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle:  AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,),

                              ButtonWidget(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.1,
                                label: "ALTERAR",
                                onTap: () async {
                                  // await containPaciente(setState, _nome);
                                  if (_form.currentState!.validate()) {
                                    if (
                                        (_nome.length>0) ||
                                        (_numero>0) ||
                                        (_telefone.length>0) ||
                                        (_cpf.length>0) ||
                                        (_endereco.length>0) ||
                                        (_data_nascimento.length>0) ||
                                        (_nome_responsavel.length>0)
                                    ){
                                      print("true");
                                      _change = true;
                                    }
                                    if (_change){
                                      //update;
                                      Provider.of<PacienteProvider>(context,
                                          listen: false).updatePaciente(paciente.id1,
                                        Paciente(
                                          nome: (_nome.length>0)?_nome:paciente.nome,
                                          cpf: (_cpf.length>0)?_cpf:paciente.cpf,
                                          endereco: (_endereco.length>0)?_endereco:paciente.endereco,
                                          numero: (_numero>0)? _numero:paciente.numero,
                                          nome_responsavel:
                                            (_nome_responsavel.length>0)?
                                            _nome_responsavel:paciente.nome_responsavel,
                                          telefone: (_telefone.length>0)?_telefone:paciente.telefone,
                                          dataNascimento: (_data_nascimento.length>0)?_data_nascimento:paciente.dataNascimento,
                                        )
                                      ).then((value) => Navigator.pushReplacementNamed(context, '/home_assistente'));
                                    }
                                  } else {
                                    setState((){});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                  );
                }
            ),
          );
        }
    );
  }
}