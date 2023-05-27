import 'package:flutter/material.dart';
import 'package:happy_home/config/color_constants.dart';

final textInputDecoration = InputDecoration(
  fillColor: ColorConstants.happyhomeGreyLight,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorConstants.happyhomeGreyLight, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorConstants.happyhomeOffWhite, width: 2.0),
  ),
  hintStyle: TextStyle(color: ColorConstants.happyhomeBrown, fontSize: 14.0),
);

final simpleInputDecoration = InputDecoration(
  filled: false,
  border: InputBorder.none,
  contentPadding: EdgeInsets.zero,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  ),
);
