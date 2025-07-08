import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/core/constants/app_images.dart';

import '../../../../translations/locale_keys.g.dart';

class WelcomeLeftPanel extends StatelessWidget {
  const WelcomeLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 683.w,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: EdgeInsets.all(25.r),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFEEFA7),
                image: DecorationImage(image: AssetImage("assets/images/Background.png"), fit: BoxFit.cover),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100), bottomLeft: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10)).r,
              ),
              child: Column(
                children: [
                  108.verticalSpace,
                Text(
                    LocaleKeys.login_page_welcome.tr(),
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 40.r,
                      fontWeight: FontWeight.w600,)
                ),
                  Text(
                  LocaleKeys.login_page_path.tr(),
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 22.r,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                  80.verticalSpace,
                  Image.asset(
                    AppImages.logoPng,
                    width: 430.w,
                    height: 337.h,
                    fit: BoxFit.contain,
                  ),
                  80.verticalSpace,
                      Text(
                        LocaleKeys.login_page_helper.tr(),
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontSize: 40.r,
                          fontWeight: FontWeight.w600,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    Text(
                      LocaleKeys.login_page_together.tr(),
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontSize: 24.r,
                        fontWeight: FontWeight.w400,
                      ),
                    maxLines: 2,),
                ]
            )
        ),),
      ),
    );
    //
  }
}
