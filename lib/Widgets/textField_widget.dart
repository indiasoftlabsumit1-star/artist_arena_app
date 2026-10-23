



import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';

class TextfieldWidget extends StatelessWidget {


  final String? label;
   final String? hint;
   final TextStyle? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  // final IconData? prefixIcon;
  // final Widget? suffixIcon;
  // final ValueChanged<String>? onChanged;
  // final int maxLines;
  final FormFieldValidator<String>? validator;
  // final TextInputAction? textInputAction;
  // final AutovalidateMode? autovalidateMode;
  // final bool readOnly;
  // final VoidCallback? onTap;
  const TextfieldWidget({super.key, this.label, this.controller,  this.obscureText=false, this.keyboardType, this.validator, this.hint, this.hintText,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
validator: validator,
        controller: controller,


      decoration: InputDecoration(
        labelText: label,
        labelStyle: Appthemestyle.poppins(
          fontSize: 15.sp.clamp(15.0, 20.0),
          color: Color(0xff0C0A0A)
        ),
        hintText: hint,
        hintStyle: hintText,

        contentPadding: EdgeInsets.symmetric(
          vertical: 0.0,
        ),

        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}


class CategoryDropdownWidget extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const CategoryDropdownWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  static const List<Map<String, dynamic>> categories = [
    {'id': '1', 'name': 'Singer'},
    {'id': '2', 'name': 'Dancer'},
    {'id': '3', 'name': 'Actor'},
    {'id': '4', 'name': 'Comedian'},
    {'id': '5', 'name': 'Musician'},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      validator: validator,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Category',
        labelStyle: Appthemestyle.poppins(
          fontSize: 15.sp.clamp(15.0, 20.0),
          color: const Color(0xff0C0A0A),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category['id'] as String,
          child: Text(category['name'] as String),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
