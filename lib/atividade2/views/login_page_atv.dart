import 'package:flutter/material.dart';
import 'package:psico_sis/atividade2/model/usuario_model.dart';
import '../../daows/UsuarioWS.dart';
import '../../model/Usuario.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_text_widget.dart';

class LoginPageAtv extends StatefulWidget {
  const LoginPageAtv({Key? key}) : super(key: key);

  @override
  State<LoginPageAtv> createState() => _LoginPageAtvState();
}

class _LoginPageAtvState extends State<LoginPageAtv> {
  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    String _email= "";
    String _password = "";
    String _erroAuthentication = "ASAA";
    return Container(
      child: Scaffold(
        backgroundColor: AppColors.shape,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
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
                        //fazer login
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Center(
                              child: Text(
                                "Fazer Login",
                                style: AppTextStyles.labelWhite20,
                              )),
                        ),

                        //LOGIN
                        InputTextWidget(
                          backgroundColor: AppColors.shape,
                          borderColor: AppColors.line,
                          icon: Icons.email,
                          iconColor: AppColors.labelWhite,
                          textStyle: AppTextStyles.labelBold16,
                          keyboardType: TextInputType.emailAddress,
                          label: "login",
                          obscureText: false,
                          controller: TextEditingController(),
                          validator: (value) {
                            if ((value!.isEmpty) || (value == null)) {
                              return 'Por favor insira um texto';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email = value;
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
                            _password = value;
                          },
                        ),
                        //usuario invalido
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            _erroAuthentication,
                            style: AppTextStyles.labelWhite20,
                          ),
                        ),
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
                    onTap: () async {
                        if (_form.currentState!.validate()) {
                        String token = await UsuarioWS.getInstance()
                            .LoginPage(_email, _password);
                        if (token.isNotEmpty){
                          Usuario _usu = await UsuarioWS.getInstance().GetByToken(token);
                          UsuarioModel usuarioModel = UsuarioModel.fromJson(_usu.toJson());
                          print("${_usu.nomeUsuario} nome usuario");
                          print("toooooo ==== $token");
                          // print(_usu.nomeUsuario);
                          Navigator.pushNamed(context, "/home_atv", arguments: usuarioModel);
                        } else {
                          _erroAuthentication = "Usuário ou senha inválidos.";
                          print(_erroAuthentication);
                          // setState(() {  });
                          print(_erroAuthentication);
                        }
                      }

                      // Navigator.pushReplacementNamed(context, "/home_assistente");
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
