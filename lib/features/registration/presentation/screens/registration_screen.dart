import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:pecs_new_arch/features/registration/data/models/signup_request_model.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart'; // Import Dio

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
      _firstnameError = _firstnameController.text.isEmpty ? 'Имя обязательно для заполнения' : null;
      _surnameError = _surnameController.text.isEmpty ? 'Фамилия обязательно для заполнения' : null;
      _usernameError = _usernameController.text.isEmpty ? 'Имя пользователя обязательно для заполнения' : null;

      final emailPattern = r'^[^@]+@[^@]+\.[^@]+';
      _emailError =
          !_emailController.text.contains(RegExp(emailPattern)) ? 'Введите корректный электронный адрес' : null;

      if (_passwordController.text.length < 6 && _passwordController.text != _againPasswordController.text) {
        _passwordError = 'Пароль должен содержать минимум 6 символов и совпадать с повторным паролем';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(), // Provide the SignUpBloc
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 250, 245, 1),
        body: SafeArea(
          child: BlocConsumer<RegistrationBloc, RegistrationState>(
            listener: (context, state) {
              if (state is RegistrationLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is RegistrationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Регистрация прошла успешно!')),
                );
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StartPage()));
              } else if (state is RegistrationFailure) {
                Navigator.of(context).pop(); // Remove loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message.message)),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/jpg/logo.jpg',
                            height: 100,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 550,
                        width: 450,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromRGBO(102, 102, 102, 1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Регистрация',
                              style: TextStyle(fontSize: 24, fontFamily: 'Montserrat'),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _firstnameController,
                                    decoration: InputDecoration(
                                      hintText: 'Имя',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorText: _firstnameError,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: _surnameController,
                                    decoration: InputDecoration(
                                      hintText: 'Фамилия',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorText: _surnameError,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      hintText: 'Имя пользователя',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorText: _usernameError,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Электронный адрес',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorText: _emailError,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  /// Dropdown for Role Selection
                                  DropdownButtonFormField<String>(
                                    value: _selectedRole,
                                    decoration: InputDecoration(
                                      hintText: 'Выберите роль',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorText: _roleError,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'cg_role',
                                        child: Text('Опекун'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'cr_role',
                                        child: Text('Пациент'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            hintText: 'Пароль',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            errorText: _passwordError,
                                          ),
                                          obscureText: !_showPasswords,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: _againPasswordController,
                                          decoration: InputDecoration(
                                            hintText: 'Повторите пароль',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            errorText: _againPasswordError,
                                          ),
                                          obscureText: !_showPasswords,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _showPasswords,
                                        onChanged: (value) {
                                          setState(() {
                                            _showPasswords = value!;
                                          });
                                        },
                                      ),
                                      const Text("Показать"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _validateFields();
                                if (_firstnameError == null &&
                                    _surnameError == null &&
                                    _usernameError == null &&
                                    _emailError == null &&
                                    _passwordError == null) {
                                  context.read<RegistrationBloc>().add(RegisterUser(
                                        user: SignupRequestModel(
                                            username: _usernameController.text,
                                            password: _passwordController.text,
                                            email: _emailController.text,
                                            firstName: _firstnameController.text,
                                            lastName: _surnameController.text,
                                            role: _selectedRole!),
                                      ));
                                }
                              },
                              child: const Text('Создать аккаунт'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
