import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/log_sistema.dart';
import 'package:psico_sis/provider/log_provider.dart';
import 'package:psico_sis/provider/parceiro_provider.dart';
import 'package:psico_sis/widgets/drop_down_widget.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/widgets/input_text_widget2.dart';
import 'package:psico_sis/widgets/input_text_widget_mask.dart';
import '../model/Parceiro.dart';
import '../model/Usuario.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_lower_widget.dart';
import '../widgets/input_text_uper_widget.dart';

class CadastroParceiro extends StatefulWidget {
  const CadastroParceiro({Key? key}) : super(key: key);

  @override
  State<CadastroParceiro> createState() => _CadastroParceiroState();
}

class _CadastroParceiroState extends State<CadastroParceiro> {

  final _form = GlobalKey<FormState>();
  var db = FirebaseFirestore.instance;

  String _uid="";
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
  String _razao ="",
      _cnpj = "",
      _endereco = "",
      _telefone = "",
      _porcentagem = "5",
      _email ="";
  int _numero = 0;

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

  bool containParceiro(String cnpj){
    return false;
  }


  @override
  void initState(){
    super.initState();
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBarWidget2(nomeUsuario:_usuario.nomeUsuario!),
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
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                              "CADASTRO PARCEIRO",
                              style: AppTextStyles.labelBold16,
                            ),
                          ),
                          InputTextUperWidget(
                            label: "RAZÃO SOCIAL",
                            icon: Icons.event_available_rounded,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _razao = value;
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
                                width: size.width * 0.223,
                                height: size.height * 0.11,
                                child: InputTextWidgetMask(
                                  label: "CNPJ",
                                  icon: Icons.badge_outlined,
                                  input: CnpjInputFormatter(),
                                  validator: (value) {
                                    if ((value!.isEmpty) || (value == null)) {
                                      return 'Por favor insira um texto';
                                    }
                                    if (value.length<18) {
                                      return 'CNPJ incompleto';
                                    } else {
                                        if (UtilBrasilFields.isCNPJValido(value)==false){
                                        return 'CNPJ inválido.';}
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _cnpj = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  backgroundColor: AppColors.secondaryColor,
                                  borderColor: AppColors.line,
                                  textStyle:  AppTextStyles.subTitleBlack12,
                                  iconColor: AppColors.labelBlack,),
                              ),
                              SizedBox(
                                width: size.width * 0.225,
                                height: size.height * 0.11,
                                child: InputTextWidgetMask(
                                  label: "TELEFONE",
                                  icon: Icons.local_phone,
                                  input: TelefoneInputFormatter(),
                                  validator: (value) {
                                    if ((value!.isEmpty) || (value == null)) {
                                      return 'Por favor insira um número';
                                    }
                                    print(value.length);
                                    if (value.length<14) {
                                      print("ddd");
                                      return '(DDD) XXXX - XXXX';
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
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.3,
                                height: size.height * 0.11,
                                child: InputTextUperWidget(
                                  label: "ENDEREÇO",
                                  icon: Icons.location_on_outlined ,
                                  validator: (value) {
                                    if ((value!.isEmpty) || (value == null)) {
                                      return 'Por favor insira um texto';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _endereco = value.toUpperCase();
                                    // value = _endereco;
                                    print(_endereco);
                                  },
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  backgroundColor: AppColors.secondaryColor,
                                  borderColor: AppColors.line,
                                  textStyle:  AppTextStyles.subTitleBlack12,
                                  iconColor: AppColors.labelBlack,),
                              ),
                              SizedBox(
                                width: size.width * 0.148,
                                height: size.height * 0.11,
                                child: InputTextWidget2(
                                  label: "NÚMERO",
                                  icon: Icons.onetwothree_rounded ,
                                  validator: (value) {
                                    if ((value!.isEmpty) || (value == null)) {
                                      return 'Inserir NÚMERO';
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


                          InputTextLowerWidget(
                            label: "EMAIL",
                            icon: Icons.email,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              children: [
                                Text("Desconto"),
                                DropDownWidget(
                                  list: ["5","10","15","20","25","30","35","40"],
                                  valueDrop1: _porcentagem,
                                  onChanged: (value){
                                    _porcentagem = value!;
                                    setState((){});

                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "Cadastrar",
                  onTap: () async {
                    if (_form.currentState!.validate()){


                      //SALVANDO Parceiro
                      Provider.of<ParceiroProvider>(context, listen: false)
                          .put(Parceiro(
                          cnpj: _cnpj,
                          desconto: int.parse(_porcentagem),
                          email: _email,
                          telefone: _telefone,
                          endereco: _endereco,
                          razaoSocial: _razao,
                          status: "ATIVO",
                          numero: _numero,
                      ));

                      //salvando log via contador
                      Provider.of<ParceiroProvider>(
                          context, listen: false)
                          .getCount().then((value1) {
                          //finalizou consulta de quantos qtd parceiros
                          Provider.of<LogProvider>(
                            context, listen: false)
                            .put(LogSistema(
                          data: DateTime.now().toString(),
                          uid_usuario: _uid,
                          descricao: "INSERIU PARCEIRO",
                          id_transacao: value1+1,
                        ));
                        // Navigator.pushReplacementNamed(context, "/home_assistente");
                          Navigator.pushReplacementNamed(context, "/cadastro_parceiro");
                      });

                      // Navigator.pushReplacementNamed(context, "/cadastro_parceiro");
                    }

                  },
                ),
              ],
            ),
          ),
        ));
  }
}
