import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/components/custom_text_field.dart';
import 'package:pecs_new_arch/core/components/primary_button.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/features/registration/data/models/registration_request_model.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/registration_bloc.dart';

class OrganizationRegistrationForm extends StatefulWidget {
  const OrganizationRegistrationForm({super.key});

  @override
  State<OrganizationRegistrationForm> createState() =>
      _OrganizationRegistrationFormState();
}

class _OrganizationRegistrationFormState
    extends State<OrganizationRegistrationForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController binController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            label: LocaleKeys.registration_page_org_name.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: nameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_bin.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: binController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: LocaleKeys.registration_page_email.tr(), // Email
            keyboardType: TextInputType.emailAddress,
            controller: addressController,
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
          30.verticalSpace,
          PrimaryButton(
              text: LocaleKeys.registration_page_register.tr(),
              onPressed: () {
                context.read<RegisterBloc>().add(Register(
                        user: RegisterRequestModel(
                      orgName: nameController.text,
                      bin: binController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      password: passwordController.text,
                      role: 'organisation',
                    )));
              }),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(LocaleKeys.registration_page_have_acc.tr(),
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StartPage()));
                },
                child: Text(
                  LocaleKeys.registration_page_login.tr(),
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
