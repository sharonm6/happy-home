import 'package:flutter/material.dart';
import 'package:happy_home/config/color_constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: ColorConstants.happyhomeBrownDark,
          size: 50.0,
        ),
      ),
    );
  }
}
