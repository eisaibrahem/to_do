import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {

  static final light= ThemeData(
    brightness: Brightness.light,
      primaryColor: primaryClr,
      backgroundColor: Colors.white,


  );

  static final dark= ThemeData(
    brightness: Brightness.dark,
      primaryColor: darkGreyClr,
      backgroundColor: Colors.white,
      // appBarTheme: const AppBarTheme(
      //   color: darkHeaderClr,
      // ),
  );



}

TextStyle get headingStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ),
);
TextStyle get subHeadingStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ),
);
TextStyle get titleStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ),
);
TextStyle get subTitleStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ),
);
TextStyle get bodyStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ),
);
TextStyle get bodyStyle2 => GoogleFonts.lato(
  textStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
  ),
);

