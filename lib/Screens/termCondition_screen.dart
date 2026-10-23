



import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';

class TermconditionScreen extends StatefulWidget {
  const TermconditionScreen({super.key});

  @override
  State<TermconditionScreen> createState() => _TermconditionScreenState();
}

class _TermconditionScreenState extends State<TermconditionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 7.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Center(child: Text('Terms and Conditions',style: Appthemestyle.poppins(fontWeight: FontWeight.w700,fontSize: 18.sp),)),
            ),
            SizedBox(height: 2.h,),
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen"
                " book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",

            style: Appthemestyle.poppins(color: Color(0xff707070),fontSize: 14.sp),
            )
          ],
        ),
      ),
      ),
    );
  }
}
