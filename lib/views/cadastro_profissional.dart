import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/dialogs/alert_dialog_profissional.dart';

import '../model/Profissional.dart';
import '../service/validator_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_uper_widget.dart';
import '../widgets/input_text_widget2.dart';
import '../widgets/input_text_widget_mask.dart';

class CadastroProfissional extends StatefulWidget {
  const CadastroProfissional({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional> createState() => _CadastroProfissionalState();
}

class _CadastroProfissionalState extends State<CadastroProfissional> {
  final _form = GlobalKey<FormState>();
  String _nome = "",
        _cpf = "",
        _data = "",
        _endereco = "",
        _numero = "",
        _telefone = "";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarWidget2(nomeUsuario: ""),
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
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                //contagem passos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: size.width * 0.45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.shape),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 6.0, right: 6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text("1", style: AppTextStyles.subTitleWhite14),
                            ),
                          ),
                          Expanded(child: Divider(
                            color: AppColors.line,
                            height: 3,
                          )),
                          Padding(
                            padding:  EdgeInsets.only(left: 6.0, right: 6.0),
                            child:  CircleAvatar(
                              backgroundColor: AppColors.line,
                              child: Text("2"),
                            ),
                          ),
                          Expanded(child: Divider(
                            color: AppColors.line,
                            height: 3,
                          )),
                          Padding(
                            padding: EdgeInsets.only(left: 6.0, right: 6.0),
                            child: CircleAvatar(
                              backgroundColor: AppColors.line,
                              child: Text("3"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                //container informações cadastro
                Container(
                  width: size.width * 0.45,
                  height: size.height * 0.65,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "CADASTRO PROFISSIONAL",
                        style: AppTextStyles.labelBold16,
                      ),
                      InputTextUperWidget(
                        label: "NOME",
                        icon: Icons.perm_contact_cal_sharp,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira um NOME';
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
                      InputTextWidgetMask(
                        label: "CPF",
                        icon: Icons.badge_outlined,
                        input: CpfInputFormatter(),
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira um CPF';
                          }
                          return null;
                        },
                        onChanged: (value){
                          _cpf = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.328,
                            // height: size.height * 0.08,
                            child: InputTextUperWidget(
                              label: "ENDEREÇO",
                              icon: Icons.location_on_outlined ,
                              validator: (value) {
                                if ((value!.isEmpty) || (value == null)) {
                                  return 'Por favor insira um ENDEREÇO';
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
                          SizedBox(
                            width: size.width * 0.12,
                            // height: size.height * 0.1,
                            child: InputTextWidget2(
                              label: "Número",
                              icon: Icons.onetwothree,
                              validator: (value) {
                                if ((value!.isEmpty) || (value == null)) {
                                  return 'Por favor insira um Número';
                                }
                                return null;
                              },
                              onChanged: (value){
                                _numero = value;
                              },
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              backgroundColor: AppColors.secondaryColor,
                              borderColor: AppColors.line,
                              textStyle:  AppTextStyles.subTitleBlack12,
                              iconColor: AppColors.labelBlack,),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          //TELEFONE
                          SizedBox(
                            width: size.width * 0.25,
                            child: InputTextWidgetMask(
                              label: "TELEFONE",
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
                              label: "DATA DE NASCIMENTO",
                              icon: Icons.date_range_rounded ,
                              input: DataInputFormatter(),

                              validator: (value) {
                                if ((value!.isEmpty) || (value == null)) {
                                  return 'Por favor insira uma DATA';
                                }
                                if (value.length<10){
                                  return 'Data incompleta';
                                }
                                if (ValidatorService.validateDate(value)==false){
                                  return 'Data inválida';
                                }
                                return null;
                              },
                              onChanged: (value){
                                _data = value;
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

                      //EMAIL
                      InputTextUperWidget(
                        label: "EMAIL",
                        icon: Icons.email,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira um email';
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

                    ],

                  ),
                ),
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "AVANÇAR",
                  onTap: () {
                    if (_form.currentState!.validate()){
                      Profissional profissional = Profissional(
                        status: "ATIVO",
                        telefone: _telefone,
                        nome: _nome,
                        endereco: _endereco,
                        cpf: _cpf,
                        dataNascimento: _data,
                        numero: _numero
                      );
                      DialogsProfissional.AlertDialogConfirmarProfissional(context,profissional);
                      // Navigator.pushReplacementNamed(context, "/cadastro_profissional2");
                    }

                  },
                ),
              ],
            ),
          ),
        ));
  }
}
