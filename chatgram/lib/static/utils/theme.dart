import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  brightness: Brightness.light,
  accentColor: Color(0xFF122543),
  primaryColor: Color(0xFF122543),
  primaryColorDark: Color(0xFF1CD860),
  primaryColorLight: Colors.white,
  scaffoldBackgroundColor: Color(0xFF122543),
  textTheme: TextTheme(
    //HEADING SMALL WHITE
    headline2: TextStyle(
        color: Color(0xFF122543),
        fontSize: 19,
        fontFamily: 'CenturyGothic',
        fontWeight: FontWeight.w800),

    //HEADING BIG WHITE
    headline1: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Color(0xFF122543),
        fontSize: 28,
        fontWeight: FontWeight.bold),

    //BUTTON TEXT
    headline3: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Color(0xFF122543),
        fontSize: 14,
        fontWeight: FontWeight.w700),

    // APP BAR
    headline4: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600),

    //TEXT FIELD
    headline5: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Color(0xFF122543),
        fontSize: 14,
        fontWeight: FontWeight.w500),

    //BODY TEXT 1
    bodyText1: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Color(0xFF122543),
        fontSize: 14,
        fontWeight: FontWeight.w600),

    //BODY TEXT 2
    bodyText2: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Color(0xFF122543),
        fontSize: 16,
        fontWeight: FontWeight.w700),

    //BODY TEXT 3
    headline6: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700),
  ),
);

ThemeData light = ThemeData(
  brightness: Brightness.dark,
  accentColor: Color(0xFF122543),
  primaryColor: Colors.white,
  primaryColorDark: Color(0xFF1CD860),
  primaryColorLight: Color(0xFF122543),
  scaffoldBackgroundColor: Color(0xFF122543),
  textTheme: TextTheme(
    //HEADING SMALL WHITE
    headline2: TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontFamily: 'CenturyGothic',
        fontWeight: FontWeight.w800),

    //HEADING BIG WHITE
    headline1: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold),

    //BUTTON TEXT
    headline3: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600),

    // APP BAR
    headline4: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Color(0xFF122543),
        fontSize: 18,
        fontWeight: FontWeight.w600),

    //TEXT FIELD
    headline5: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500),

    //BODY TEXT 1
    bodyText1: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600),

    //BODY TEXT 2
    bodyText2: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700),
    //BODY TEXT 3
    headline6: TextStyle(
        fontFamily: 'CenturyGothic',
        color: Color(0xFF122543),
        fontSize: 15,
        fontWeight: FontWeight.w700),
  ),
);
