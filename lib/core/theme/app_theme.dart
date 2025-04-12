// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';

ThemeData APP_THEME = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.white,
  primaryColor: Color(0xff3A7D44),
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff3A7D44)),
  primaryColorLight: Color(0xFFE7EBFF),
  iconTheme: IconThemeData(color: Colors.black),
  textTheme: GoogleFonts.montserratTextTheme(),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    // contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide(color: AppColors.error, width: 2.w),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide(color: AppColors.error, width: 2.w),
    ),

    floatingLabelBehavior: FloatingLabelBehavior.always,
    helperStyle: GoogleFonts.montserrat(
      color: AppColors.white,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 1.25,
      letterSpacing: 0.24,
    ),
    errorStyle: GoogleFonts.montserrat(
      color: AppColors.error,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      height: 1.25,
      letterSpacing: 0.24,
    ),
    floatingLabelStyle: GoogleFonts.montserrat(
      color: AppColors.white,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.24,
    ),
    labelStyle: GoogleFonts.montserrat(
      color: AppColors.white,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.24,
    ),
    hintStyle: GoogleFonts.montserrat(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: 14.sp,
      color: Colors.white70,
      letterSpacing: 0.24,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xff3A7D44),
    padding: EdgeInsets.symmetric(vertical: 16.h),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color(0xff3A7D44),
    selectionColor: Color(0xff3A7D44).withOpacity(0.35),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    circularTrackColor: Colors.transparent,
    color: Color(0xff3A7D44),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xff3A7D44),
  ),
  appBarTheme: AppBarTheme(
    color: AppColors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      // fontSize: ScreenUtil().setSp(38), // 16 by figma
      fontSize: 16.sp,
      color: AppColors.black,
    ),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: AppColors.black,
    ),
    iconTheme: const IconThemeData(color: AppColors.black),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.all(Color(0xff3A7D44)),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      return states.any((element) => element == WidgetState.selected) ? Color(0xff3A7D44) : Colors.transparent;
    }),
    side: BorderSide(
      color: Color(0xff3A7D44),
      width: 2.w,
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: Colors.transparent,
  ),
);

ThemeData APP_THEME_DARK = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: AppColors.gray,
  primaryColor: Color(0xff3A7D44),
  primaryColorLight: Color(0xFFE7EBFF),
  iconTheme: IconThemeData(color: Colors.black),
  textTheme: GoogleFonts.montserratTextTheme(),
);
