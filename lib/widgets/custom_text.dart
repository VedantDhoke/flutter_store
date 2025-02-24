import 'package:ecommerce_admin_tut/helpers/app_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;

  // Use the 'required' keyword for the mandatory parameter 'text'
  const CustomText({
    Key? key,
    required this.text, // Use 'required' keyword for text
    this.size = 16.0, // Default value for size
    this.color =
        black, // Default color, assuming 'black' is defined in app_colors.dart
    this.weight = FontWeight.normal, // Default weight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: weight,
      ),
    );
  }
}
