import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_profissional.dart';
import 'package:psico_sis/provider/profissional_provider.dart';

import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../service/validator_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_lower_widget.dart';
import '../widgets/input_text_uper_widget.dart';
import '../widgets/input_text_widget2.dart';
import '../widgets/input_text_widget_mask.dart';

class CadastroProfissional extends StatefulWidget {
  const CadastroProfissional({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional> createState() => _CadastroProfissionalState();
}

class _CadastroProfissionalState extends State<CadastroProfissional> {

  String _uid="";
  final _form = GlobalKey<FormState>();
  List<Profissional> _listProfissional = [];
  List<Usuario> _listUsuario = [];
  var db = FirebaseFirestore.instance;

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
  String _nome = "",
        _cpf = "",
        _data = "",
        _endereco = "",
        _numero = "",
        _telefone = "",
        _email = "",
        _email2 = "";


  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await db.collection('usuarios').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element) {
      Usuario usuario = Usuario.fromJson1(element);
      _listUsuario.add(usuario);
    });
  }

  bool existEmail(String email) {
    bool result = false;
    _listProfissional.forEach((element) {
      if (element.email?.compareTo(email)==0){
        result=true;
      }
    });
    print("list = ${_listUsuario.length}");
    _listUsuario.forEach((element) {
      if (element.emailUsuario?.compareTo(email)==0){
        result=true;
      }
    });
    // Provider.of<ProfissionalProvider>(
    //     context, listen: false).existByEmail(email).then((value) => result = value);
    print("result = $result");
    return result;
  }

  bool existCPF(String cpf)  {
    bool result = false;
    _listProfissional.forEach((element) {
      if (element.cpf?.compareTo(cpf)==0){
        result = true;
      }
    });
    // var result = await Provider.of<ProfissionalProvider>(
    //     context, listen: false).existByCPF(cpf);
    // // Provider.of<ProfissionalProvider>(
    // //     context, listen: false).existByEmail(cpf).then((value) => result = value);
    // print("result cpf = $result");
    return result;
  }


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

  @override
  void initState() {
    super.initState();
    getData();
    _listProfissional = Provider.of<ProfissionalProvider>(context, listen: false)
      .listProfissional;

    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value){
          print("usuário autenticado");
          PrefsService.getUid().then((value) {
            _uid = value;
            print("_uid initState $_uid");
            getUsuarioByUid(_uid).then((value) {
              _usuario = value;
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar:  PreferredSize(
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * 0.15,
                      height: size.height * 0.3,
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
                          SizedBox(
                            width: size.width * 0.15,
                            height: size.height * 0.225,
                            child: Center(
                              child: Icon(
                                  size: 120,
                                  Icons.switch_account)
                            ),

                          ),
                          Text("CADASTRO PROFISSIONAL"),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: size.width * 0.45,
                        height: size.height * 0.72,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.line,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.shape),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: size.height *0.11,
                                child: InputTextUperWidget(
                                  label: "NOME",
                                  icon: Icons.perm_contact_cal_sharp,
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

                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.32,
                                    height: size.height * 0.11,
                                    child: InputTextUperWidget(
                                      label: "ENDEREÇO",
                                      icon: Icons.location_on_outlined ,
                                      validator: (value) {
                                        if ((value!.isEmpty) || (value == null)) {
                                          return 'Insira um ENDEREÇO';
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
                                    width: size.width * 0.125 ,
                                    height: size.height * 0.11,
                                    child: InputTextWidget2(
                                      label: "Número",
                                      icon: Icons.onetwothree,
                                      validator: (value) {
                                        if ((value!.isEmpty) || (value == null)) {
                                          return 'Número';
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
                              Padding(
                                padding: const EdgeInsets.only(left: 22.0),
                                child: Row(
                                  children: [
                                    // CPF
                                    SizedBox(
                                      height: size.height *0.11,
                                      width: size.width *0.142,
                                      child: InputTextWidgetMask(
                                        padding: size.width * 0.005,
                                        label: "CPF",
                                        icon: Icons.badge_outlined,
                                        input: CpfInputFormatter(),
                                        validator: (value) {
                                          if ((value!.isEmpty) || (value == null)) {
                                            return 'Insira um CPF';
                                          }
                                          if (UtilBrasilFields.isCPFValido(value)==false){
                                            return 'CPF inválido.';
                                          }

                                          if (existCPF(value)){
                                            return 'CPF cadastrado.';

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
                                    ),
                                    //TELEFONE 0,247
                                    SizedBox(
                                      height: size.height *0.11,
                                      width: size.width * 0.135,
                                      child: InputTextWidgetMask(
                                        padding: size.width * 0.0005,
                                        label: "TELEFONE",
                                        icon: Icons.local_phone,
                                        input: TelefoneInputFormatter(),
                                        validator: (value) {
                                          if ((value!.isEmpty) || (value == null)) {
                                            return 'Insira um TELEFONE';
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
                                    //DATA 0,2
                                    SizedBox(
                                      height: size.height *0.11,
                                      width: size.width * 0.14,
                                      child: InputTextWidgetMask(
                                        padding: size.width * 0.005,
                                        label: "DATA DE NASCIMENTO",
                                        icon: Icons.date_range_rounded ,
                                        input: DataInputFormatter(),

                                        validator: (value) {
                                          if ((value!.isEmpty) || (value == null)) {
                                            return 'Insira uma DATA';
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
                              ),

                              //EMAIL
                              SizedBox(
                                height: size.height *0.11,
                                width: size.width * 0.65,
                                child: InputTextLowerWidget(
                                  label: "EMAIL",
                                  icon: Icons.email,
                                  validator: (value) {
                                    if ((value!.isEmpty) || (value == null)) {
                                      return 'Insira um email';
                                    }
                                    if(EmailValidator.validate(value)==false){
                                      return 'Email inválido';
                                    }
                                    if (value.compareTo(_email2)!=0){
                                      return 'Email divergente';
                                    }
                                    if (existEmail(value)){
                                      return 'Email CADASTRADO';
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
                              SizedBox(
                                height: size.height *0.11,
                                width: size.width * 0.65,
                                child: InputTextLowerWidget(
                                  label: "CONFIRME O EMAIL",
                                  icon: Icons.email,
                                  validator: (value) {
                                    if ((value!.isEmpty) || (value == null)) {
                                      return 'Insira um email';
                                    }
                                    if(EmailValidator.validate(value)==false){
                                      return 'Email inválido';
                                    }
                                    if (value.compareTo(_email)!=0){
                                      return 'Email divergente';
                                    }
                                    if (existEmail(value)){
                                      return 'Email CADASTRADO';
                                    }
                                    return null;
                                  },
                                  onChanged: (value){
                                    _email2 = value;
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
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.15,
                      height: size.height * 0.3,
                    )
                  ],
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
                        numero: _numero,
                        email: _email,
                      );
                      DialogsProfissional.AlertDialogConfirmarProfissional(context,_uid, profissional);
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
