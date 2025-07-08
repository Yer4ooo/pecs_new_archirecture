import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final bool isLoading;
  final String? loadingText;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor = const Color(0xFF639A52),
    this.textStyle,
    this.isLoading = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Opacity(
        opacity: isLoading ? 0.7 : 1.0,
        child: Container(
          width: width ?? double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: backgroundColor,
          ),
          child: Center(
            child: isLoading
                ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 18.h,
                  width: 18.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    loadingText ?? "Loading...",
                    overflow: TextOverflow.ellipsis,
                    style: textStyle ??
                        GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            )
                : Text(
              text,
              style: textStyle ??
                  GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
