import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pproj/features/board/screens/boards_screen.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../logic/bloc/board_bloc.dart';
import 'board.dart';

class CreateTabScreen extends StatefulWidget {
  String? boardId;
  CreateTabScreen({required this.boardId, super.key});
  @override
  State<CreateTabScreen> createState() => _CreateTabScreenState();
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

class _CreateTabScreenState extends State<CreateTabScreen> {
  final TextEditingController _nameController = TextEditingController();
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  int? selectedValue; // Moved outside the builder to persist across rebuilds

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void _submit() {
    print(colorToHex(currentColor));
    setState(() => currentColor = pickerColor);
    final name = _nameController.text.trim();
    if (name.isNotEmpty && widget.boardId != null) {
      context.read<BoardBloc>().add(
        CreateTabForChild(
          name: name,
          color: colorToHex(currentColor)[0] + colorToHex(currentColor).substring(3),
          boardId: int.parse(widget.boardId!),
          strapsNum: selectedValue ?? 6,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Создание вкладки"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<BoardBloc, BoardState>(
        listener: (context, state) {
          if (state is TabCreated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BoardScreen(boardId: widget.boardId!),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Вкладка '${state.tabName}' успешно создана")),
            );
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
                      "Введите название новой вкладки",
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
                    SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Select a number of straps"),
                    DropdownButton<int>(
                      value: selectedValue,
                      hint: const Text("Select a number of straps"),
                      items: List.generate(6, (index) => index + 1)
                          .map(
                            (value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
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
