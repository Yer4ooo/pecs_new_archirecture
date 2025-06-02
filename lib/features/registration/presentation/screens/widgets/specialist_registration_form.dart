import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/components/custom_text_field.dart';
import 'package:pecs_new_arch/core/components/primary_button.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/features/registration/data/models/registration_model.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:pecs_new_arch/features/registration/presentation/screens/widgets/specialists_dropdown.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';

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
    "Логопед",
    "Сурдопедагог",
    "Психолог",
    "ABA-терапист (прикладной анализ поведения)",
    "Детский нейропсихолог",
  ];

  List<String> selectedSpecializations = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            label: "Имя", // Email
            keyboardType: TextInputType.emailAddress,
            controller: nameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: "Фамилия", // Email
            keyboardType: TextInputType.emailAddress,
            controller: surnameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: "Имя пользователя", // Email
            keyboardType: TextInputType.emailAddress,
            controller: usernameController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: "Номер телефона", // Email
            keyboardType: TextInputType.emailAddress,
            controller: phoneController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: "Электронная почта", // Email
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          15.verticalSpace,
          CustomTextField(
            label: "Пароль", // Email
            keyboardType: TextInputType.emailAddress,
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
              text: 'Зарегистрироваться',
              onPressed: () {
                context.read<RegistrationBloc>().add(RegisterUser(user: RegistrationModel(
                firstName: nameController.text,
                lastName: surnameController.text,
                email: emailController.text,
                phone: phoneController.text,
                password: passwordController.text,
                role: 'specialist',
                
                )));
              }),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Нет аккаунта?',
                  style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black)),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StartPage()));
                },
                child: Text(
                  'Войти',
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
