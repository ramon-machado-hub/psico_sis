import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final titleAppbar = GoogleFonts.fredokaOne(
    fontSize: 20,
    fontWeight: FontWeight.w100,
    color: AppColors.labelWhite,
  );

  static final labelWhite20 = GoogleFonts.fredokaOne(
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: AppColors.labelWhite,
  );

  static final labelBlack12 = GoogleFonts.fredokaOne(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.labelBlack,
  );

  static final labelBold16 = GoogleFonts.mitr(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.labelBlack,
  );

  static final textButton = GoogleFonts.bangers(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.shape,
  );

  static final labelBlack16 = GoogleFonts.fredokaOne(
    fontSize: 16,
    fontWeight: FontWeight.w600,

    color: AppColors.labelBlack,
  );

  static final labelWhite16 = GoogleFonts.lilitaOne(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.labelWhite,
  );

}