import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ServiceTab extends StatelessWidget {
  ServiceTab({super.key});

  final List<Map<String, String>> services = [
    {
      'type': "Working Since",
      'text': "2009",
    },
    {
      'type': "Area Of Working",
      'text': "Indore",
    },
    {
      'type': "Services",
      'text': "Wedding Planner, Event Planner",
    },
    {
      'type': "Charges",
      'text': "On Demand",
    },
    {
      'type': "Requirements",
      'text': "On Demand",
    },
    {
      'type': "Payment Mode",
      'text': "Cash, Cheque, Neft",
    },
    {
      'type': "Website",
      'text': "www.arihantevents.in",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsetsGeometry.symmetric(horizontal: 5.w),
      child: Column(
        children: List.generate(
          services.length,
              (index) {
            final item = services[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Expanded(
                   child: Text(
                        item['type']!,
                        style: Appthemestyle.poppins(
                          fontSize: 12.sp.clamp(10.0, 12.0),
                          color: const Color(0xff999999),
                        ),
                      ),
                 ),

                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      item['text']!,
                      style: Appthemestyle.poppins(
                        fontSize: 12.sp.clamp(10.0, 12.0),
                        fontWeight: FontWeight.w500,
                        color: index == 6
                            ? AppColores.custtombtnColor
                            : const Color(0xff0C0A0A),                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}