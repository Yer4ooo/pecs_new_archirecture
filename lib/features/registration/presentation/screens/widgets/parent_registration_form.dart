import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/components/custom_text_field.dart';
import 'package:pecs_new_arch/core/components/primary_button.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/registration_request_model.dart';

class ParentRegistrationForm extends StatefulWidget {
  const ParentRegistrationForm({super.key});

  @override
  State<ParentRegistrationForm> createState() => _ParentRegistrationFormState();
}

class _ParentRegistrationFormState extends State<ParentRegistrationForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            label: LocaleKeys.registration_page_name.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: nameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_surname.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: surnameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_email.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_phone.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: phoneController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_username.tr(), // Email
            keyboardType: TextInputType.phone,
            controller: usernameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_password.tr(), // Email
            keyboardType: TextInputType.text,
            controller: passwordController,
          ),
          30.verticalSpace,
          PrimaryButton(
              text: LocaleKeys.registration_page_register.tr(),
              onPressed: () {
                context.read<RegisterBloc>().add(Register(
                    user: RegisterRequestModel(
                role: 'parent',
                email: emailController.text,
                password: passwordController.text,
                firstName: nameController.text,
                lastName: surnameController.text,
                phone: phoneController.text,
                )
                ));
              }),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(LocaleKeys.registration_page_have_acc.tr(),
                  style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black)),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StartPage()));
                },
                child: Text(
                  LocaleKeys.registration_page_login.tr(),
                  style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.darkGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
