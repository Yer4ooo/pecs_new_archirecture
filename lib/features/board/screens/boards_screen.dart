import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/features/board/logic/bloc/board_bloc.dart';
import 'package:pecs_new_arch/features/board/screens/board.dart';
import 'package:pecs_new_arch/features/board/screens/create_board_screen.dart';
import 'package:pecs_new_arch/features/home/presentation/screens/widgets/home_top_widget.dart';

class BoardsScreen extends StatefulWidget {
  const BoardsScreen({super.key});

  @override
  State<BoardsScreen> createState() => _BoardsScreenState();
}

class _BoardsScreenState extends State<BoardsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BoardBloc>().add(FetchBoards());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeTopWidget(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Мои доски",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: BlocBuilder<BoardBloc, BoardState>(
              builder: (context, state) {
                if (state is BoardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BoardFailure) {
                  return Center(child: Text("Ошибка: ${state.error}"));
                } else if (state is BoardSuccess) {
                  final boards = state.boardData.boards;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      itemCount: boards!.length + 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        if (index < boards.length) {
                          final board = boards[index];
                          return Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Board(),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        // You can customize board appearance here
                                        Divider(thickness: 20, color: Color(0xFFF3EFDD)),
                                        Divider(thickness: 10, color: Color(0xFFD7DB3F)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(board.name ?? "Без названия",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CreateBoardScreen()),
                              );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add, size: 40, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text("Добавить новую доску"),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                // trigger edit action
              },
              icon: const Icon(Icons.edit),
              label: const Text("Редактировать доски"),
            ),
          ),
        ],
      ),
    );
  }
}
