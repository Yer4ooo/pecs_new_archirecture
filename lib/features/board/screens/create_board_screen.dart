import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/bloc/board_bloc.dart';

class CreateBoardScreen extends StatefulWidget {
  String? childId;
  CreateBoardScreen({required this.childId, super.key});

  @override
  State<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && widget.childId != null) {
      context.read<BoardBloc>().add(CreateBoardForChild(name: name, color: '#F3EFDD', childId: widget.childId!, private: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Создание доски"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<BoardBloc, BoardState>(
        listener: (context, state) {
          if (state is BoardCreated) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Доска '${state.boardName}' успешно создана")),
            );
            context.read<BoardBloc>().add(FetchBoardsById(childId: widget.childId!));
          } else if (state is BoardFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Ошибка: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Введите название новой доски",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Например: Животные",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    state is BoardLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Создать доску", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
