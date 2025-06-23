import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/core/constants/app_images.dart';

class WelcomeLeftPanel extends StatelessWidget {
  const WelcomeLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset('assets/svg/back1.svg'),
        Padding(
          padding: EdgeInsets.only(left: 61.w, right: 57.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              108.verticalSpace,
              FittedBox(
                child: Text(
                  "Добро пожаловать в APRIL",
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 40.r,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Ваш путь к эффективному взаимодействию.",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 22.r,
                  fontWeight: FontWeight.w400,
                ),
              ),
              85.verticalSpace,
              Image.asset(
                AppImages.logoPng,
                width: 430.w,
                height: 337.h,
                fit: BoxFit.contain,
              ),
              85.verticalSpace,
              FittedBox(
                child: Text(
                  "Ваш помощник в общении",
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 40.r,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "APRIL объединяет родителей,\nспециалистов и организации.",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
