


import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Appthemestyle {




     static   TextStyle   searchType= Appthemestyle.poppins(
       fontSize: 12.sp,
       fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0
     );

static TextStyle customBTNText({
       Color? btnText,
     }) {
       return Appthemestyle.poppins(
         fontSize: 18.sp.clamp(18.0, 20.0),
         color: btnText,
         letterSpacing: 0,
       );
     }


     static TextStyle poppins({
       double? fontSize,
       FontWeight fontWeight = FontWeight.w400,
       Color? color,  int? letterSpacing,  FontStyle? fontStyle,  double? height,
     }) {
       return TextStyle(
         fontFamily: 'Poppins',
         fontSize: fontSize,
         fontWeight: fontWeight,
         color: color,
       );
     }
}

 class    AppColores{
  
  
  static Color custtombtnColor=  Color(0xffFF1F53);
}