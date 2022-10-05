import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/provider/usuario_provider.dart';
import 'package:psico_sis/service/validator_service.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import '../model/Usuario.dart';
import '../model/log_sistema.dart';
import '../provider/log_provider.dart';
import '../service/authenticate_service.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_lower_widget.dart';
import '../widgets/input_text_uper_widget.dart';
import '../widgets/input_text_widget.dart';
import '../widgets/input_text_widget_mask.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key}) : super(key: key);

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {


  final _form = GlobalKey<FormState>();
  var db = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? usuarioSubscription;
  late List<Usuario> _lu = [];
  List<Usuario> items = [];
  String _uid="";
  //   late List<Especialidade> _le = [];
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

  String  _nomeUsuario="",
      _loginUsuario = "",
      _emailUsuario = "",
      _emailUsuario2 = "",
      _senhaUsuario1 = "",
      _senhaUsuario2 = "",
      _dataNascimentoUsuario = "",
      _telefone = "";



  //mensagem de avisos
  void showSnackBar(String message) {
    SnackBar snack = SnackBar(
      backgroundColor: AppColors.secondaryColor,
      content: Text(
        message,
        style: AppTextStyles.labelWhite16Lex,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
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

  bool isValidDate(String date) {
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool containEmail(String email){
    print("email $email");
    bool result = false;

    _lu.forEach((element) {
      print("${element.emailUsuario}  =  $email");
      if (element.emailUsuario?.compareTo(email)==0){
        result = true;
      }
    });
    return result;
  }

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await db.collection('usuarios').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element) {
      Usuario usuario = Usuario.fromJson1(element);
      _lu.add(usuario);
    });
  }



  @override
  void initState(){
    super.initState();
    getData();

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
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    // usuarioSubscription?.cancel();
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
          child: Center(
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "CADASTRO USUÁRIO",
                    style: AppTextStyles.labelBold16,
                  ),
                  //container informações
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 8,),
                        //nome
                        InputTextUperWidget(
                          label: "NOME",
                          icon: Icons.perm_contact_cal_sharp,
                          validator: (value) {
                            if ((value!.isEmpty) || (value == null)) {
                              return 'Insira um Nome';
                            }
                            return null;
                          },
                          onChanged: (value){
                            _nomeUsuario = value;
                          },
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          backgroundColor: AppColors.secondaryColor,
                          borderColor: AppColors.line,
                          textStyle:  AppTextStyles.subTitleBlack12,
                          iconColor: AppColors.labelBlack,),
                        //email
                        InputTextLowerWidget(
                          label: "EMAIL",
                          icon: Icons.email,
                          validator: (value) {
                            if ((value!.isEmpty) || (value == null)) {
                              return 'Insira um Email';
                            }
                            if (value.compareTo(_emailUsuario2)!=0){
                              return 'Email divergente';
                            }
                            if (containEmail(value)){
                              return 'Email já cadastrado';
                            }

                            return null;
                          },
                          onChanged: (value){
                            _emailUsuario = value;
                          },
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          backgroundColor: AppColors.secondaryColor,
                          borderColor: AppColors.line,
                          textStyle:  AppTextStyles.subTitleBlack12,
                          iconColor: AppColors.labelBlack,),
                        //confirme email
                        InputTextLowerWidget(
                          label: "CONFIRME O EMAIL",
                          icon: Icons.email,
                          validator: (value) {
                            if ((value!.isEmpty) || (value == null)) {
                              return 'Insira um email';
                            }
                            if (value.compareTo(_emailUsuario)!=0){
                              // showSnackBar("Erro.");
                              return 'Email divergente';
                            }
                            if (containEmail(value)){
                              return 'Email já cadastrado';
                            }
                            return null;
                          },
                          onChanged: (value){
                            _emailUsuario2 = value;
                          },
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          backgroundColor: AppColors.secondaryColor,
                          borderColor: AppColors.line,
                          textStyle:  AppTextStyles.subTitleBlack12,
                          iconColor: AppColors.labelBlack,),

                        //senha
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.22,
                              height: size.height * 0.12,
                              child: InputTextWidget(
                                label: "SENHA",
                                icon: Icons.password,
                                validator: (value) {

                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Insira uma senha';
                                  }
                                  if (value.compareTo(_senhaUsuario2)!=0){
                                    return 'Senhas Divergentes';
                                  }

                                  if (value.length<6) {
                                    print("ddd");
                                    return 'Conter ao menos 6 dígitos';
                                  }

                                  return null;
                                },
                                onChanged: (value){
                                  _senhaUsuario1 = value;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle:  AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,),
                            ),
                            SizedBox(
                              width: size.width * 0.22,
                              height: size.height * 0.12,
                              child: InputTextWidget(
                                label: "SENHA",
                                icon: Icons.password,
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Insira uma senha';
                                  }
                                  if (value.compareTo(_senhaUsuario1)!=0){
                                    return 'Senhas Divergentes';
                                  }
                                  if (value.length<6) {
                                    print("ddd");
                                    return 'Conter ao menos 6 dígitos';
                                  }

                                  return null;
                                },
                                onChanged: (value){
                                  _senhaUsuario2 = value;
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
                        //telefone + data
                        Row(
                          children: [

                            SizedBox(
                              width: size.width * 0.22,
                              height: size.height * 0.12,
                              child: InputTextWidgetMask(
                                label: "TELEFONE",
                                icon: Icons.local_phone,
                                input: TelefoneInputFormatter(),
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Insira um número';
                                  }
                                  if (value.length<14) {
                                    print("ddd");
                                    return '(DDD) XXXX - XXXX';
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
                              width: size.width * 0.22,
                              height: size.height * 0.12,
                              child: InputTextWidgetMask(
                                label: "DATA DE NASCIMENTO",
                                icon: Icons.date_range_rounded ,
                                input: DataInputFormatter(),
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Insira uma data';
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
                                  _dataNascimentoUsuario = value;
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

                      ],

                    ),
                  ),
                  ButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                    label: "AVANÇAR",
                    onTap: () {
                      print(_senhaUsuario1);
                      if (_form.currentState!.validate()){

                        AuthenticateService().
                        signUp(email: _emailUsuario, password: _senhaUsuario1).then((result) {
                          if (result == null) {
                            //salvando usuário
                            Provider.of<UsuarioProvider>(context, listen: false)
                                .put(Usuario(
                                nomeUsuario: _nomeUsuario,
                                telefone: _telefone,
                                dataNascimentoUsuario: _dataNascimentoUsuario,
                                statusUsuario: "ATIVO",
                                tokenUsuario: DateTime.now().toString(),
                                emailUsuario: _emailUsuario,
                                loginUsuario: _loginUsuario,
                                senhaUsuario: _senhaUsuario1,
                                tipoUsuario: "ASSISTENTE",
                            ));

                            //salvando log via contador
                            Provider.of<UsuarioProvider>(
                                  context, listen: false)
                                  .getCount().then((value1) {
                                      //finalizou consulta de qtd usuario
                                      Provider.of<LogProvider>(
                                          context, listen: false)
                                          .put(LogSistema(
                                        data: DateTime.now().toString(),
                                        uid_usuario: _uid,
                                        descricao: "INSERIU ASSISTENTE",
                                        id_transacao: value1,
                                      ));
                              Navigator.pushReplacementNamed(context, "/home_assistente");
                            });
                          } else {
                            showSnackBar("Erro.");
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
