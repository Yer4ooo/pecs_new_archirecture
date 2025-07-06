import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/components/custom_text_field.dart';
import 'package:pecs_new_arch/core/components/primary_button.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:pecs_new_arch/features/registration/presentation/screens/widgets/specialists_dropdown.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/registration_request_model.dart';

class SpecialistRegistrationForm extends StatefulWidget {
  const SpecialistRegistrationForm({super.key});

  @override
  State<SpecialistRegistrationForm> createState() => _SpecialistRegistrationFormState();
}

class _SpecialistRegistrationFormState extends State<SpecialistRegistrationForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<String> specializations = [
    LocaleKeys.registration_page_speech_th.tr(),
    LocaleKeys.registration_page_deaf.tr(),
    LocaleKeys.registration_page_psycho.tr(),
    LocaleKeys.registration_page_child.tr(),
    LocaleKeys.registration_page_aba.tr()

  ];

  List<String> selectedSpecializations = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            label: LocaleKeys.registration_page_name.tr(), // Email
            keyboardType: TextInputType.text,
            controller: nameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_surname.tr(), // Email
            keyboardType: TextInputType.text,
            controller: surnameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_username.tr(), // Email
            keyboardType: TextInputType.text,
            controller: usernameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_phone.tr(), // Email
            keyboardType: TextInputType.phone,
            controller: phoneController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_email.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_password.tr(), // Email
            keyboardType: TextInputType.text,
            controller: passwordController,
          ),
          15.verticalSpace,
          SpecializationDropdown(
            allSpecializations: specializations,
            selected: selectedSpecializations,
            onChanged: (List<String> values) {
              setState(() {
                selectedSpecializations = values;
              });
            },
          ),
          30.verticalSpace,
          PrimaryButton(
              text: LocaleKeys.registration_page_register.tr(),
              onPressed: () {
                context.read<RegisterBloc>().add(Register(
                    user: RegisterRequestModel(
                firstName: nameController.text,
                lastName: surnameController.text,
                email: emailController.text,
                phone: phoneController.text,
                password: passwordController.text,
                role: 'specialist_solo',
                
                )));
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
