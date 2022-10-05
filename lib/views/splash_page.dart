import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';

import '../service/prefs_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState(){
    super.initState();
    Future.wait([
      PrefsService.isAuth(),
      PrefsService.getUid(),
      Future.delayed( const Duration(seconds: 3))
    ]).then((value) {
      if (value[0]==true){
        Navigator.pushReplacementNamed(context, "/home_assistente",
            arguments: value[1]);
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.labelWhite,
        ),
      ),
    );
  }
}
