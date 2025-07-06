import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/components/custom_text_field.dart';
import 'package:pecs_new_arch/core/components/primary_button.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/core/constants/app_icons.dart';
import 'package:pecs_new_arch/core/navigation/app_router.gr.dart';
import 'package:pecs_new_arch/features/registration/presentation/screens/registration_screen.dart';
import 'package:pecs_new_arch/features/start/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/start/presentation/bloc/login_bloc.dart';
import 'package:pecs_new_arch/features/start/presentation/widgets/logo_part_screen.dart';
import 'package:pecs_new_arch/translations/locale_keys.g.dart';
@RoutePage()
class StartPage extends StatefulWidget {
  const StartPage({super.key});
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final locale = context.locale;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Row(
              children: [
                WelcomeLeftPanel(),
        SingleChildScrollView(
          child: SizedBox(
                  width: 0.5.sw,
                  height: 974.h,
                  child: Padding(
                    padding: const EdgeInsets.all(25).r,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Locale>(
                                value: locale,
                                isDense: true,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey.shade600,
                                  size: 20.sp,
                                ),
                                iconSize: 20.sp,
                                elevation: 8,
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                items: [
                                  DropdownMenuItem(
                                    value: const Locale('ru'),
                                    child: Text(
                                      "РУС",
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: const Locale('kk'),
                                    child: Text(
                                      "ҚАЗ",
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: const Locale('en'),
                                    child: Text(
                                      "ENG",
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (Locale? newLocale) {
                                  if (newLocale != null) {
                                    context.setLocale(newLocale);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        195.verticalSpace,
                        BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is LoginSuccess) {
                                context.router.replace(SidebarWrapper());
                              } else if (state is LoginFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Error: ${state.message.message}")),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is LoginLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 142.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            LocaleKeys.login_page_login.tr(),
                                            style: GoogleFonts.inter(
                                                fontSize: 24.sp,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          30.verticalSpace,
                                          CustomTextField(
                                            label: LocaleKeys.login_page_email.tr(),
                                            keyboardType: TextInputType.emailAddress,
                                            controller: emailController,
                                          ),
                                          14.verticalSpace,
                                          CustomTextField(
                                            label: LocaleKeys.login_page_password.tr(),
                                            keyboardType: TextInputType.text,
                                            controller: passwordController,
                                            obscureText: !_isPasswordVisible,
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.only(right: 15.w),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isPasswordVisible = !_isPasswordVisible;
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  _isPasswordVisible
                                                      ? AppIcons.showPassword // Use appropriate show icon
                                                      : AppIcons.hidePassword,
                                                  width: 14.w,
                                                  height: 7.h,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          24.verticalSpace,
                                          PrimaryButton(
                                            text: LocaleKeys.login_page_login_button.tr(),
                                            onPressed: () {
                                              final username = emailController.text;
                                              final password = passwordController.text;

                                              context.read<LoginBloc>().add(
                                                Login(
                                                  user: LoginRequestModel(
                                                      identifier: username,
                                                      password: password),
                                                ),
                                              );
                                            },
                                          ),
                                          18.verticalSpace,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(LocaleKeys.login_page_no_acc.tr(),
                                                  style: GoogleFonts.inter(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black)),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RegistrationScreen()));
                                                },
                                                child: Text(
                                                  LocaleKeys.login_page_sign_up.tr(),
                                                  style: GoogleFonts.inter(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.darkGreen),
                                                ),
                                              ),
                                            ],
                                          )]));
                            })
                      ],
                    ),
                  ),
                ))
              ],
            ),
        ),
    );
  }
}