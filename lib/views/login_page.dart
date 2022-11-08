import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/log_sistema.dart';
import 'package:psico_sis/provider/log_provider.dart';
import 'package:psico_sis/provider/login_provider.dart';
import 'package:psico_sis/service/prefs_service.dart';
import '../provider/usuario_provider.dart';
import '../service/authenticate_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_images.dart';
import '../themes/app_text_styles.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_lower_widget.dart';
import '../widgets/input_text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email1 ="";
  String _password1="";

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



  @override
  void initState(){
    super.initState();
    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value){
          print("inistate login");
          Navigator.pushReplacementNamed(
                    context, "/home_assistente");
        }
      }),
    ]);
  }


  @override
  Widget build(BuildContext context) {

    final _form = GlobalKey<FormState>();

    return Container(
      child: Scaffold(
        backgroundColor: AppColors.shape,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                          height: 175,
                          width:  350,
                          fit: BoxFit.fill,
                          AppImages.logoVertical3),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                              child: Text(
                                "Fazer Login",
                                style: AppTextStyles.labelWhite20,
                              )),
                        ),

                        //email
                        InputTextLowerWidget(
                          backgroundColor: AppColors.shape,
                          borderColor: AppColors.line,
                          icon: Icons.email,
                          iconColor: AppColors.labelWhite,
                          textStyle: AppTextStyles.labelBold16,
                          keyboardType: TextInputType.emailAddress,
                          label: "email",
                          obscureText: false,
                          controller: TextEditingController(),
                          validator: (value) {
                            if ((value!.isEmpty) || (value == null)) {
                              return 'Por favor insira um texto';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email1 = value;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),

                        //senha
                        InputTextWidget(
                          backgroundColor: AppColors.shape,
                          borderColor: AppColors.line,
                          icon: Icons.password_outlined,
                          iconColor: AppColors.labelWhite,
                          textStyle: AppTextStyles.labelBold16,
                          keyboardType: TextInputType.emailAddress,
                          label: "senha",
                          obscureText: true,
                          controller: TextEditingController(),
                          validator: (value) {
                            if ((value!.isEmpty) || (value == null)) {
                              return 'Por favor insira uma senha';
                            }
                            if (value.length < 6) {
                              return 'Senha deve conter 6 caracteres';
                            }
                            return null;
                            // value?.isEmpty ?? true ? "O email não pode ser vazio" : null;
                          },
                          onChanged: (value) {
                            _password1 = value;
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  ButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                    label: "Entrar",
                    onTap: () {
                      if (_form.currentState!.validate()){
                        AuthenticateService().signIn(email: _email1, password: _password1).then((result) {
                          if (result == null) {
                            print("logou");
                            String uid = Provider.of<UsuarioProvider>(context, listen: false)
                                .getDataUid();
                            print("uid antes do save $uid");
                            PrefsService.save(uid).then((value) {
                              PrefsService.isAuth().then((value) => print("value $value"));
                              PrefsService.getUid().then((value) => print("uidPrefs $value"));
                            });
                            // Provider.of<>
                            bool teste = false;
                            Provider.of<LoginProvider>(context, listen: false)
                              .getLoginByUid2(uid).then((value) {
                                if (value.tipo_usuario!.compareTo("ASSISTENTE")==0){
                                  Provider.of<LogProvider>(context, listen: false)
                                      .put(LogSistema(
                                    data: DateTime.now().toString(),
                                    uid_usuario: uid,
                                    descricao: "Login",
                                    id_transacao: "0",
                                  )).then((value) =>
                                  Navigator.pushReplacementNamed(context, "/home_assistente",));
                                } else
                                  if( (value.tipo_usuario!.compareTo("PROFISSIONAL")==0))
                                    Provider.of<LogProvider>(context, listen: false)
                                        .put(LogSistema(
                                    data: DateTime.now().toString(),
                                    uid_usuario: uid,
                                    descricao: "Login",
                                    id_transacao: "0",
                                    )).then((value) => Navigator.pushReplacementNamed(context, "/home",));
                                    // Navigator.pushReplacementNamed(context, "/home_page",);

                                  });

                            // Provider.of<UsuarioProvider>(
                            //     context, listen: false).getUsuarioByUid2(uid)
                            //     .then((usuario)  {
                            //       teste = true;

                                  // Provider.of<LogProvider>(context, listen: false)
                                  //     .put(LogSistema(
                                  //   data: DateTime.now().toString(),
                                  //   uid_usuario: uid,
                                  //   descricao: "Login",
                                  //   id_transacao: 0,
                                  // )).then((value)  {
                                  //   if (usuario.tipoUsuario=="ASSISTENTE"){
                                  //     Navigator.pushReplacementNamed(context, "/home_assistente",);
                                  //     // Navigator.pushNamedAndRemoveUntil(context, "/home_assistente",(_) => false);
                                  //   } else {
                                  //
                                  //     Navigator.pushReplacementNamed(context, "/login",);
                                  //   }
                                  // });
                                // });
                              if (teste=false){
                                    //re
                              }

                            // Navigator.pushReplacementNamed(context, "/home_assistente", arguments: uid);

                          } else {
                            showSnackBar(
                                "Login inválido ou senha inválida");
                          }
                        });

                      }

                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
