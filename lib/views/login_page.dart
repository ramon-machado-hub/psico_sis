import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    String _email;
    String _password;
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
                    height: MediaQuery.of(context).size.height * 0.40,
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
                        InputTextWidget(
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
                            _email = value;
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
                      Navigator.pushReplacementNamed(context, "/home");
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
