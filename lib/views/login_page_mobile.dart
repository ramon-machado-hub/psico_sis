import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/log_sistema.dart';
import 'package:psico_sis/provider/log_provider.dart';
import 'package:psico_sis/provider/login_provider.dart';
import 'package:psico_sis/service/prefs_service.dart';
import 'package:psico_sis/widgets/input_text_password_widget.dart';
import 'package:psico_sis/widgets/input_text_widget3.dart';
import '../provider/usuario_provider.dart';
import '../service/authenticate_service.dart';
import '../themes/app_colors.dart';
import '../themes/app_images.dart';
import '../themes/app_text_styles.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_lower_widget.dart';
import '../widgets/input_text_widget.dart';

class LoginPageMobile extends StatefulWidget {
  const LoginPageMobile({Key? key}) : super(key: key);

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {

  final _form = GlobalKey<FormState>();

  String _email1 ="";
  String _password1="";
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  bool _login = false;
  // final FocusNode _emailFocus = FocusNode();
  // final FocusNode _passwordFocus = FocusNode();

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
    // FocusScope.of(context).unfocus();
    // FocusManager.instance.primaryFocus?.unfocus();
    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value){
          print("inistate login");
          Navigator.pushReplacementNamed(
                    context, "/home_profissional_mobile");
        }
      }),
    ]);
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.shape,
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height*0.03,
                ),
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
                  height: size.height*0.03,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: size.height * 0.45,
                    width: size.width * 0.8,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.8,
                            child: Center(
                                child: Text(
                                  "Fazer Login",
                                  style: AppTextStyles.labelWhite20,
                                )),
                          ),
                        ),
                        Positioned(
                          top:size.height * 0.08,
                          left: 0,
                          child: SizedBox(
                            height: size.height * 0.15,
                            width: size.width * 0.8,
                            child:  InputTextLowerWidget(
                              backgroundColor: AppColors.shape,
                              borderColor: AppColors.line,
                              icon: Icons.email,
                              iconColor: AppColors.labelWhite,
                              textStyle: AppTextStyles.labelBold16,
                              keyboardType: TextInputType.emailAddress,
                              label: "email",
                              obscureText: false,
                              controller: _emailController,
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


                            // InputTextWidget(
                            //   label: "email",
                            //   height: size.height*0.15,
                            //   keyboardType: TextInputType.emailAddress,
                            //   obscureText: false,
                            //   backgroundColor: AppColors.shape,
                            //   borderColor: AppColors.line,
                            //   textStyle: AppTextStyles.labelBold16,
                            //   iconColor: AppColors.labelWhite,
                            //   onChanged: (value) {
                            //     _email1 = value;
                            //   },
                            //   controller: _emailController,
                            //   validator: (value) {
                            //     if ((value!.isEmpty) || (value == null)) {
                            //       return 'Por favor insira um texto';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // TextFormField(
                            //   controller: _emailController,
                            //   keyboardType: TextInputType.emailAddress,
                            //   focusNode: _emailFocus,
                            //   // textInputAction: TextInputAction.next,
                            //   // onFieldSubmitted: (term){
                            //   //   _fieldFocusChange(context, _emailFocus, _passwordFocus);
                            //   // },
                            //   decoration: InputDecoration(
                            //     labelText: 'Email',
                            //     hintText: 'Email',
                            //     icon: Icon(Icons.person_outline),
                            //     fillColor: Colors.white,
                            //   ),
                            //   onChanged: (value){
                            //     _email1 = value;
                            //   },
                            // )

                          ),
                        ),


                        //email
                        // InputTextLowerWidget(
                        //   backgroundColor: AppColors.shape,
                        //   borderColor: AppColors.line,
                        //   icon: Icons.email,
                        //   iconColor: AppColors.labelWhite,
                        //   textStyle: AppTextStyles.labelBold16,
                        //   keyboardType: TextInputType.emailAddress,
                        //   label: "email",
                        //   obscureText: false,
                        //   controller: TextEditingController(),
                        //   validator: (value) {
                        //     if ((value!.isEmpty) || (value == null)) {
                        //       return 'Por favor insira um texto';
                        //     }
                        //     return null;
                        //   },
                        //   onChanged: (value) {
                        //     // FocusScope.of(context).unfocus();
                        //     // primaryFocus!.unfocus(disposition: disposition);
                        //     _email1 = value;
                        //   },
                        // ),

                        //senha
                        Positioned(
                            top: size.height*0.25,
                            left: 0,
                            child: SizedBox(
                                height: size.height * 0.15,
                                width: size.width * 0.8,
                                child:
                                InputTextPasswordWidget(
                                  backgroundColor: AppColors.shape,
                                  borderColor: AppColors.line,
                                  icon: Icons.password_outlined,
                                  iconColor: AppColors.labelWhite,
                                  textStyle: AppTextStyles.labelBold16,
                                  keyboardType: TextInputType.text,
                                  label: "senha",
                                  obscureText: true,
                                  controller: _passwordController,

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

                            )
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height*0.03,
                ),
                (_login)?
                CircularProgressIndicator()
                    :
                ButtonWidget(
                  width: size.width * 0.3,
                  height: size.height * 0.1,
                  label: "Entrar",
                  onTap: () {
                    if (_form.currentState!.validate()){
                      _login = true;
                      setState((){});
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
                              )).then((value) => Navigator.pushReplacementNamed(context, "/home_profissional_mobile",));
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
                          _login = false;
                          setState((){});
                          showSnackBar(
                              "Login ou senha incorreto!");
                        }
                      });

                    }

                  },
                ),

              ],
            ),
          ),
        )
      ),
    );

    
  }
}
