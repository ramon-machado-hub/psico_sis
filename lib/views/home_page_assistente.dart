import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/model/especialidades_profissional.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/especialidade_provider.dart';
import 'package:psico_sis/service/prefs_service.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/widgets/menu_button_widget.dart';
import '../model/Especialidade.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/login.dart';
import '../model/servico.dart';
import '../provider/especialidade_profissional_provider.dart';
import '../provider/login_provider.dart';
import '../provider/profissional_provider.dart';
import '../provider/servico_profissional_provider.dart';
import '../provider/servico_provider.dart';
import '../provider/usuario_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/menu_icon_button_widget.dart';


class HomePageAssistente extends StatefulWidget {

  // final String uid;
  // const HomePageAssistente({Key? key, required this.uid,}) : super(key: key);
  const HomePageAssistente({Key? key}) : super(key: key);

  @override
  State<HomePageAssistente> createState() => _HomePageStateAssitente();
}

class _HomePageStateAssitente extends State<HomePageAssistente> {

  var db = FirebaseFirestore.instance;
  String _uid="";
  late Usuario _usuario = Usuario(
    idUsuario:1,
    senhaUsuario: "",
    loginUsuario: "",
    dataNascimentoUsuario: "",
    telefone: "",
    nomeUsuario: "",
    emailUsuario: "",
    statusUsuario:  "",
    tokenUsuario: "",
  );
  final List<String> _listHoras = [
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00"
  ];

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
  void initState(){
    super.initState();
    Future.wait([
      PrefsService.isAuth().then((value) async {
        if (value){
          print("usuário autenticado home");
         await PrefsService.getUid().then((value) async {
            _uid = value;
            print("_uid initState home $_uid");
            await getUsuarioByUid(_uid).then((value) {
              _usuario = value;
            }).then((value) {
              if (this.mounted){
                setState((){
                  print("setState home");
                });
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
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    // print("usuario depois do builder = ${_usuario.nomeUsuario}");
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),

          child: AppBarWidget2(nomeUsuario: _usuario.nomeUsuario!),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                colors: [
                  AppColors.shape,
                  AppColors.primaryColor,
                ],
              )),
          child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.labelWhite,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: size.width * 0.70,
                height: size.height * 0.7,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: size.width * 0.025,
                  runSpacing: size.height * 0.05,
                  children: [

                    MenuIconButtonWidget(
                        label: "Agenda",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.calendar_month_rounded,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/agenda_assistente");
                        }),


                    MenuIconButtonWidget(
                        label: "Aniversariantes",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.cake_rounded,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/aniversariantes");
                        }),


                    // MenuIconButtonWidget(
                    //     label: "Caixa",
                    //     height: size.width * 0.1,
                    //     width: size.width * 0.1,
                    //     iconData: Icons.monetization_on,
                    //     onTap: () {
                    //       Navigator.pushReplacementNamed(context, "/caixa");
                    //     }),

                    MenuIconButtonWidget(
                        label: "Cadastro Usuário",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.person_add,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/cadastro_usuario");
                        }),

                    // MenuButtonWidget(
                    //   label: "Sessões",
                    //   height: size.width * 0.1,
                    //   width: size.width * 0.1,
                    // C:\Users\Windows\Documents\Sistema\psico_sisrofi      //   image: AppImages.consulta_icon,
                    //   onTap: () {
                    //     Navigator.pushReplacementNamed(context, "/sessao");
                    //   },
                    // ),
                    MenuButtonWidget(
                      label: "Especialidades",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      image: AppImages.experiencia,
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/especialidades", (_) => false);
                        // Navigator.pushReplacementNamed(context, "/especialidades");

                      },
                    ),

                    MenuButtonWidget(
                      label: "Pacientes",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      image: AppImages.paciente2,
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, "/pacientes");
                      },
                    ),

                    MenuIconButtonWidget(
                        label: "Parceiros",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.handshake_rounded,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/parceiro");
                        }),




                    MenuIconButtonWidget(
                        label: "Profissionais",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.people_alt,
                        onTap: () async{
                          Navigator.pushReplacementNamed(
                              context, "/profissionais");

                          // DialogsProfissional
                          //     .AlertDialogConfirmarEspecialidadeProfissional
                          //   (context, Profissional(
                          //   id: 1,
                          //   numero: "100",
                          //   nome: "Teste",
                          //   telefone: "100",
                          //   endereco: "100",
                          //   dataNascimento: "100",
                          //   cpf: "100",
                          //   status: "100",
                          //   senha: "100",
                          //   email: "teste@gmail",
                          // ));


                          //inserir em
                          // List<DiasSalasProfissionais> _listOcupadas = [];
                          // await Provider.of<DiasSalasProfissionaisProvider>
                          //   (context, listen: false).getListOcupadas().then((value) {
                          //     _listOcupadas = value;
                          // });
                          // DialogsProfissional.AlertDialogConfirmarDiasProfissional(context, _listOcupadas);

                        }),

                    MenuIconButtonWidget(
                        label: "Serviços",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.local_pharmacy_rounded,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/servicos");
                        }),

                    // MenuIconButtonWidget(
                    //     label: "adicionar servico profissional",
                    //     height: size.width * 0.1,
                    //     width: size.width * 0.1,
                    //     iconData: Icons.local_pharmacy_rounded,
                    //     onTap: () async {
                    //
                    //
                    //         //SALVANDO Parceiro
                    //         await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                    //             .put(ServicosProfissional(
                    //           idServico: 2,
                    //           idProfissional: 1,
                    //           valor: "120,00"
                    //         ));
                    //
                    //
                    //
                    //     }),


                    MenuIconButtonWidget(
                        label: "alterando serviços",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.local_pharmacy_rounded,
                        onTap: () async {
                          List<Servico> list = [];
                          List<ServicosProfissional> listServProf = [];
                          List<Profissional> listProf = [];
                          List<Especialidade> listEsp = [];
                          List<EspecialidadeProfissional> listEspProf = [];
                          List<DiasSalasProfissionais> listDiasSalas = [];
                          List<Login> listUsers = [];
                          List<Usuario> listUsuarios = [];

                          //alterando serviços id automatico
                          // await Provider.of<ServicoProvider>(context, listen: false)
                          //   .getListServicos1().then((value) {
                          //     print("entrou 1");
                          //     list = value;
                          //     // alterar todos os id serviços
                          //     list.forEach((element) async {
                          //       await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                          //           .getListServicosProfissional().then((value1) async{
                          //         print("entrou 2");
                          //         listServProf = value1;
                          //         String id= "";
                          //         await Provider.of<ServicoProvider>(context, listen: false)
                          //             .put3(Servico(
                          //             descricao: element.descricao,
                          //             qtd_pacientes: element.qtd_pacientes,
                          //             qtd_sessoes: element.qtd_sessoes)).then((value2)  {
                          //           print("id = $value2");
                          //           print("servProf = ${listServProf.length}");
                          //           id = value2;
                          //           //alterar todos os id servicos contido em serv_prof
                          //           listServProf.forEach((element1) async {
                          //             print("----");
                          //             print("id = ${element1.idServico}");
                          //             print("id = ${element.id}");
                          //             if (element1.idServico!.compareTo(element.id!)==0) {
                          //               print("alterando");
                          //               await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                          //                   .put(ServicosProfissional(
                          //                 id: element1.id,
                          //                 idProfissional: element1.idProfissional,
                          //                 idServico: id,
                          //                 valor: element1.valor, )).then((value) => print('alterou ${element1.id}'));
                          //             }
                          //           });
                          //         });
                          //       });
                          //     });
                          //
                          // });

                          //----------

                          // back  users
                          // await Provider.of<LoginProvider>(context, listen: false)
                          //   .getUsers().then((value) {
                          //     print("entrou");
                          //     listUsers = value;
                          //     listUsers.forEach((element) async {
                          //       await Provider.of<LoginProvider>(context, listen: false)
                          //           .put2(element, element.id1).then((value) =>
                          //           print("inseriu back users ${element.id} - ${element.id1}"));
                          //     });
                          // });


                          //---------

                          //back  usuarios
                          // await Provider.of<UsuarioProvider>(context, listen: false)
                          //   .getUsuarios().then((value) {
                          //     print("entrou");
                          //     listUsuarios = value;
                          //     listUsuarios.forEach((element) async {
                          //       await Provider.of<UsuarioProvider>(context, listen: false)
                          //           .put2(element, element.id1).then((value) =>
                          //           print("inseriu back users ${element.idUsuario} - ${element.id1}"));
                          //     });
                          // });

                          //----------

                          //back  profissional
                          // await Provider.of<ProfissionalProvider>(context, listen: false)
                          //   .getListProfissionaisAtivos().then((value) {
                          //     listProf = value;
                          //     listProf.forEach((element) {
                          //       Provider.of<ProfissionalProvider>(context, listen: false)
                          //           .put2(element).then((value) => print("inseriu back prof ${element.id}"));
                          //     });
                          // });


                          //----------

                          //back  especialidade
                          // await Provider.of<EspecialidadeProvider>(context, listen: false)
                          //   .getListEspecialidades1().then((value) {
                          //     listEsp = value;
                          //     listEsp.forEach((element) {
                          //       Provider.of<EspecialidadeProvider>(context, listen: false)
                          //           .put2(element).then((value) => print("inseriu back prof ${element.id1}"));
                          //     });
                          // });


                          //----------

                          //back  especialidadeProfissional
                          // await Provider.of<EspecialidadeProfissionalProvider>(context, listen: false)
                          //   .getListEspecialidades().then((value) {
                          //     listEspProf = value;
                          //     listEspProf.forEach((element) {
                          //       Provider.of<EspecialidadeProfissionalProvider>(context, listen: false)
                          //           .put2(element).then((value) => print("inseriu back prof ${element.id1}"));
                          //     });
                          // });

                          //----------

                          //back  diasSalasProfissional
                          await Provider.of<DiasSalasProfissionaisProvider>(context, listen: false)
                            .getListDiasSalas().then((value) {
                              listDiasSalas = value;
                              listDiasSalas.forEach((element) {
                                Provider.of<DiasSalasProfissionaisProvider>(context, listen: false)
                                    .put2(element).then((value) => print("inseriu back dias ${element.id}"));
                              });
                          });

                          //----------

                          //back serv prof
                          // await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                          //   .getListServicosProfissional().then((value) {
                          //     listServProf = value;
                          //     listServProf.forEach((element) {
                          //       Provider.of<ServicoProfissionalProvider>(context, listen: false)
                          //           .put2(element);
                          //     });
                          // });

                          //serviços back
                          // await Provider.of<ServicoProvider>(context, listen: false)
                          //   .getListServicos1().then((value) {
                          //     list = value;
                          //     list.forEach((element) {
                          //       Provider.of<ServicoProvider>(context, listen: false)
                          //           .put2(element);
                          //     });
                          //
                          // });


                            // List<String> list = [
                            //   "PSICOLOGIA",
                            //   "NUTRIÇÃO ADULTO",
                            //   "FONOAUDIOLOGIA",
                            //   "NUTRIÇÃO MATERNO-INFANTIL",
                            //   "PSICOPEDAGOGIA",
                            //   "ENFERMEIRA ESTÉTICA",
                            //   "TERAPIA OCUPACIONAL",
                            //   "PSICOMOTRICISTA",
                            //   "ACOMPANHANTE TERAPÊUTICA",
                            //   "PEDIATRIA",
                            // ];
                            //ALTERANDO especialidade Parceiro
                            // list.forEach((element) async {
                            //   await Provider.of<EspecialidadeProvider>(context, listen: false)
                            //               .put2(Especialidade(
                            //     descricao: element
                            //   ));
                            // });
                            // await Provider.of<EspecialidadeProvider>(context, listen: false)
                            //     .getListEspecialidades1().then((value) {
                            //       list = value;
                            //       list.forEach((element) {
                            //          Provider.of<EspecialidadeProvider>(context, listen: false)
                            //             .put2(element);
                            //          Provider.of<EspecialidadeProvider>(context, listen: false)
                            //             .remove(element.idEspecialidade.toString());
                            //       });
                            // });



                        }),

                  ],
                ),
              )), // child: Container(
        ),
      ),
    );
  }
}
