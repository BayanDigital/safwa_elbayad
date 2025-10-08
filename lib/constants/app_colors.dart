import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary1 = Color(0xFF59A1C9);
  static const Color primary2=Color(0xFF36AD73);
  static const Color primary =   Color(0xFF30BFBF);

  static const Color whiteLight=Color(0xFFF3F3F3);
static const Color secondaryColor=Color(0xFF000033);
  static const Color textColor=Color(0xFF535252);
  static const Color grayColor=Color(0xFF989A9D);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
     primary1,
      primary2,
      primary
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color black = Color.fromARGB(255, 0, 4, 8);
  static const Color roz =Color(0xFF672035);
  static const Color light =Color(0xFFF4F1FD);
  static const Color lightBorder=Color(0xFFA8A8A8);
  static const Color pink =Color(0xFFF5EBDD);
  static const Color lightBlack =Colors.black54;
  static const Color darkRoz =Color(0xFF872945);
 static const Color lightRoz=Color(0xFFFEEDF2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF4141);
  static const Color gray = Color(0xFFC1C1C1);
  static const Color grayWhite=Color(0xFFB7B7B7);
  static const Color grayBG = Color(0xFFF7F7F7);
  static const Color lightgray = Color(0xFF979797);
  static const Color navyButton = Color(0xFF294366);
  static const Color navyText = Color(0xFF788493);
  static const Color purple = Color(0xFF7B39FD);
  static const Color lightpurple = Color(0xFFF5F0FF);
  static const Color darkGrey=Color(0xFFB9B9B9);
  static const Color blue = Color(0xFF003169);
  static const Color gold = Color(0xFFFBBE04);
}
