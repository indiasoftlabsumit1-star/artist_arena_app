




import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonButtonWidget extends StatelessWidget {

  final String btnName;
  final Color? btnBgColor;
  final Color btnText;
   final double? width;
  final VoidCallback callback;

const CommonButtonWidget({super.key, required this.btnName,  this.btnBgColor, required this.btnText, required this.callback, this.width=double.infinity});

  @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: (){
       callback();
     },
       child: Container(
            width: width,
         padding: EdgeInsetsGeometry.symmetric(horizontal: 4.w,vertical: 1.h),
         decoration: BoxDecoration(
           color: btnBgColor,
           borderRadius: BorderRadius.circular(20.sp),
           border: Border.all(
             color: Colors.red
           )
         ),
         child: Center(
           child: Text(
             btnName,
             style: Appthemestyle.customBTNText(
               btnText: btnText,
             ),
           ),
         ),     ),

   );
  }
}
