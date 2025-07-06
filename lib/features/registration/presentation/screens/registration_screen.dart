import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:pecs_new_arch/features/registration/presentation/screens/widgets/organization_registration_form.dart';
import 'package:pecs_new_arch/features/registration/presentation/screens/widgets/parent_registration_form.dart';
import 'package:pecs_new_arch/features/registration/presentation/screens/widgets/specialist_registration_form.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';
import 'package:pecs_new_arch/features/start/presentation/widgets/logo_part_screen.dart';

import '../../../../translations/locale_keys.g.dart'; // Import Dio

enum UserRole { parent, organisation, specialist_solo }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _firstnameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _againPasswordController = TextEditingController();

  bool _showPasswords = false;
  String? _firstnameError;
  String? _surnameError;
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _againPasswordError;
  String? _roleError;

  String? _selectedRole;

  void _validateFields() {
    setState(() {
      _firstnameError = _firstnameController.text.isEmpty
          ? 'Имя обязательно для заполнения'
          : null;
      _surnameError = _surnameController.text.isEmpty
          ? 'Фамилия обязательно для заполнения'
          : null;
      _usernameError = _usernameController.text.isEmpty
          ? 'Имя пользователя обязательно для заполнения'
          : null;

      final emailPattern = r'^[^@]+@[^@]+\.[^@]+';
      _emailError = !_emailController.text.contains(RegExp(emailPattern))
          ? 'Введите корректный электронный адрес'
          : null;

      if (_passwordController.text.length < 6 &&
          _passwordController.text != _againPasswordController.text) {
        _passwordError =
            'Пароль должен содержать минимум 6 символов и совпадать с повторным паролем';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Пароль должен содержать минимум 6 символов';
      } else if (_passwordController.text != _againPasswordController.text) {
        _passwordError = 'Пароли не совпадают';
      } else {
        _passwordError = null;
      }

      _againPasswordError = _passwordError;
    });
  }

  UserRole selectedRole = UserRole.parent;
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return BlocProvider(
      create: (context) => RegisterBloc(), // Provide the SignUpBloc
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Регистрация прошла успешно!')),
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const StartPage()));
              } else if (state is RegisterFailure) {
                Navigator.of(context).pop(); // Remove loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message.message)),
                );
              }
            },
            builder: (context, state) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WelcomeLeftPanel(),
                    SingleChildScrollView(
                    child: SizedBox(
                    width: 0.5.sw,
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
                              40.verticalSpace,
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 101.w),
                                child: Column(
                                  children: [
                                    Text(LocaleKeys.registration_page_create_acc.tr(),
                                        style: GoogleFonts.inter(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black)),
                                    20.verticalSpace,
                                    SegmentedTabBar(
                                      selectedRole: selectedRole,
                                      onChanged: (role) {
                                        setState(() {
                                          selectedRole = role;
                                        });
                                      },
                                    ),
                                    30.verticalSpace,
                                    Builder(
                                      builder: (context) {
                                        switch (selectedRole) {
                                          case UserRole.parent:
                                            return ParentRegistrationForm();
                                          case UserRole.organisation:
                                            return OrganizationRegistrationForm();
                                          case UserRole.specialist_solo:
                                            return SpecialistRegistrationForm();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
              )],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SegmentedTabBar extends StatelessWidget {
  final UserRole selectedRole;
  final Function(UserRole) onChanged;

  const SegmentedTabBar({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Row(
        children: [
          _buildTab(UserRole.parent, LocaleKeys.registration_page_parent.tr(), isFirst: true),
          _buildTab(UserRole.organisation, LocaleKeys.registration_page_organisation.tr()),
          _buildTab(UserRole.specialist_solo, LocaleKeys.registration_page_specialist.tr(), isLast: true),
        ],
      ),
    );
  }

  Widget _buildTab(UserRole role, String label,
      {bool isFirst = false, bool isLast = false}) {
    final bool isSelected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(role),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
