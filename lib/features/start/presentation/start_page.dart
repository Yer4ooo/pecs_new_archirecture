import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/components/custom_text_field.dart';
import 'package:pecs_new_arch/core/components/left_nav_bar.dart';
import 'package:pecs_new_arch/core/components/primary_button.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/core/constants/app_icons.dart';
import 'package:pecs_new_arch/core/constants/app_images.dart';
import 'package:pecs_new_arch/features/login/presentation/screens/login_screen.dart';
import 'package:pecs_new_arch/features/profile/presentation/screens/profile_screen.dart';
import 'package:pecs_new_arch/features/registration/presentation/screens/registration_screen.dart';
import 'package:pecs_new_arch/features/start/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/start/presentation/bloc/login_bloc.dart';
import 'package:pecs_new_arch/features/start/presentation/widgets/logo_part_screen.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    // final registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    // final loginBloc = BlocProvider.of<LoginBloc>(context);
    // final libraryBloc = BlocProvider.of<LibraryBloc>(context);
    // final boardBloc = BlocProvider.of<BoardBloc>(context);
    final locale = context.locale;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: WelcomeLeftPanel()
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // Top-right language switcher
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Locale>(
                              value: locale,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              items: [
                                DropdownMenuItem(
                                  value: const Locale('ru'),
                                  child: Text("РУС",
                                      style: GoogleFonts.inter(
                                          fontSize: 13.sp, color: AppColors.black, fontWeight: FontWeight.w400)),
                                ),
                                DropdownMenuItem(
                                  value: const Locale('kk'),
                                  child: Text("ҚАЗ",
                                      style: GoogleFonts.inter(
                                          fontSize: 13.sp, color: AppColors.black, fontWeight: FontWeight.w400)),
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
                      ],
                    ),
                    195.verticalSpace,
                    BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                          if (state is LoginSuccess) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SidebarWrapper()));
                          } else if (state is LoginFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${state.message.message}")),
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
                                'Войти', // 'Login'
                                style: GoogleFonts.inter(
                                    fontSize: 20.sp, color: AppColors.black, fontWeight: FontWeight.w600),
                              ),
                              30.verticalSpace,
                              CustomTextField(
                                label: "Электронная почта", // Email
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                              ),
                              14.verticalSpace,
                              CustomTextField(
                                label: "Пароль", // Email
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 15.w),
                                  child: SvgPicture.asset(
                                    AppIcons.hidePassword,
                                    width: 14.w,
                                    height: 7.h,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              24.verticalSpace,
                              PrimaryButton(
                                text: 'Войти',
                                onPressed: () {
                                  final username = emailController.text;
                                    final password = passwordController.text;

                                    context.read<LoginBloc>().add(
                                          Login(
                                            user: LoginRequestModel(identifier: username, password: password),
                                          ),
                                        );
                                },
                              ),
                              18.verticalSpace,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Нет аккаунта?',
                                      style: GoogleFonts.inter(
                                          fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                                    },
                                    child: Text(
                                      'Зарегистрироваться',
                                      style: GoogleFonts.inter(
                                          fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.darkGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
