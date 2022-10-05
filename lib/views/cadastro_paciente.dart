import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import '../model/Parceiro.dart';
import '../model/Usuario.dart';
import '../provider/paciente_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../service/validator_service.dart';
import '../themes/app_colors.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_uper_widget.dart';
import '../widgets/input_text_widget_mask.dart';

class CadastroPacientes extends StatefulWidget {
  const CadastroPacientes({Key? key}) : super(key: key);

  @override
  State<CadastroPacientes> createState() => _CadastroPacientesState();
}

class _CadastroPacientesState extends State<CadastroPacientes> {
  final _form = GlobalKey<FormState>();
  var db = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? parceiroSubscription;
  List<Parceiro> list = [];
  // List<Parceiro> items = [];
  late Usuario _usuario = Usuario(
    idUsuario:0,
    senhaUsuario: "",
    loginUsuario: "",
    dataNascimentoUsuario: "",
    telefone: "",
    nomeUsuario: "",
    emailUsuario: "",
    statusUsuario:  "",
    tokenUsuario: "",
  );
  String _uid="";
  String _nome ="",
      _data_nascimento = "",
      _endereco = "",
      _telefone = "",
      _cpf ="";
  int _numero=0;
  bool _exist=false;

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

  Future<bool> containPaciente(String nome) async{
    final result =
    await Provider.of<PacienteProvider>(context, listen: false).existByName(_nome);
    print("result $result");
    _exist = result;
    setState((){});
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

  @override
  void initState(){
    super.initState();
    parceiroSubscription?.cancel();
    parceiroSubscription =
        db.collection("parceiros").snapshots().listen(
                (snapshot) {
              setState((){
                list = snapshot.docs.map(
                        (documentSnapshot) => Parceiro.fromMap(
                      documentSnapshot.data(),
                      int.parse(documentSnapshot.id),
                    )
                ).toList();
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
              setState((){});
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
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
          child: Form(
            key: _form,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: Text(
                              "CADASTRO PACIENTE",
                              style: AppTextStyles.labelBold16,
                            ),
                          ),
                          //nome
                          InputTextUperWidget(
                              label: "NOME",
                              icon: Icons.perm_contact_cal_sharp,
                              validator: (value) {
                                if ((value!.isEmpty) || (value == null)) {
                                  return 'Insira um NOME';
                                }
                                // containPaciente(_nome);
                                //     .then((value1) {
                                //   if (value1){
                                //     print("value1");
                                //     _exist = true;
                                //     setState((){});
                                //     return 'PACIENTE já possui cadastro!';
                                //   } else {
                                //     print("value2");
                                //
                                //     _exist=false;
                                //     setState((){});
                                //     return null;
                                //   }
                                // });
                                // Provider.of<PacienteProvider>(context, listen: false).existByName(_nome)
                                //     .then((value1) {
                                //       if(value1==false){
                                //         print("entrou aquiii");
                                //         _exist =false;
                                //         setState((){});
                                //         return null;
                                //       } else{
                                //         print("aqui entrou");
                                //         _exist = true;
                                //         setState((){});
                                //       }
                                // });
                                if (_exist){
                                  return 'Paciente já cadastrado';
                                }
                                // print("saiu");
                                // return null;
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
                          //row cpf / telefone
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.2224,
                                child: InputTextWidgetMask(
                                  label: "CPF",
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
                                width: size.width * 0.225,
                                child: InputTextWidgetMask(
                                  input: TelefoneInputFormatter(),
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

                          Row(
                            children: [
                              SizedBox(
                                width: size.width*0.30,
                                child: InputTextUperWidget(
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
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "Cadastrar Paciente",
                  onTap: () async {
                    await containPaciente(_nome);
                    if (_form.currentState!.validate()) {
                      await Provider.of<PacienteProvider>(context, listen: false).existPaciente(_nome)
                          .then((value) {
                            bool result = value;
                            if (result==false){
                              Dialogs.AlertConfirmarPaciente(context,
                                  _nome, _endereco, _data_nascimento, _telefone,
                                  _cpf, _numero,list, _uid);
                            } else {
                              print("usuario ja existe");
                            }
                      });

                    } else {
                      setState((){});
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
