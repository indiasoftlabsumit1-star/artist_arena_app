


import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

      final double width=  constraints.maxWidth;
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: width>=1024?0.w:5.w),
          child: Column(
            children: [
              Text("Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.\n\n Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. is dummy text used in laying out print, graphic or web designs.",
              style: Appthemestyle.poppins(
        color:Color(0xff0C0A0A),
                fontSize: 14.sp.clamp(12.0, 14.0)
              ),
              )
            ],
          ),
        );
      }
    );
  }
}
