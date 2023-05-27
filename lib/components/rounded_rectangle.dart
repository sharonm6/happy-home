import 'package:flutter/material.dart';
import 'package:happy_home/config/color_constants.dart';

class RoundedRectangle extends StatelessWidget {
  final double borderRadiusAmt;
  final Color containerColor;
  final EdgeInsetsGeometry paddingInset;
  final Widget childWidget;

  const RoundedRectangle({
    super.key,
    this.borderRadiusAmt = 15.0,
    this.containerColor = const Color(0xFFD2C3B3),
    this.paddingInset = const EdgeInsets.fromLTRB(40, 20, 40, 20),
    required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusAmt),
      child: Container(
          color: containerColor,
          child: Padding(
            padding: paddingInset,
            child: childWidget,
          )),
    );
  }
}
