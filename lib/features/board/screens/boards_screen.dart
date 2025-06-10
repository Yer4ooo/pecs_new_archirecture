import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../children/logic/bloc/children_bloc.dart';
import '../../children/logic/bloc/children_event.dart';
import '../../children/logic/bloc/children_state.dart';
import '../../home/presentation/screens/widgets/home_top_widget.dart';
import '../logic/bloc/board_bloc.dart';
import 'board.dart';
import 'create_board_screen.dart';

class BoardsScreen extends StatefulWidget {
  const BoardsScreen({super.key});

  @override
  State<BoardsScreen> createState() => _BoardsScreenState();

}

class _BoardsScreenState extends State<BoardsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChildrenBloc>().add(FetchChildren());
  }
  String? selectedChildName;
  String? selectedChildId;

  hexColor(String color) {
    String colorNew = '0xFF$color';
    colorNew = colorNew.replaceAll('#', '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BoardBloc>(create: (context) => BoardBloc()),
          BlocProvider<ChildrenBloc>(create: (context) => ChildrenBloc()),
        ],
    child: Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeTopWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Мои доски",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
              Row(
                  children: [
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 30, color: Colors.green),
                    ),
                    SizedBox(width: 10),
                    Text(
                      selectedChildName ?? "Выберите ребёнка",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(97, 148, 81, 1),
                      ),
                    ),
                    BlocBuilder<ChildrenBloc, ChildrenState>(
                builder: (context, childrenState) {
                  if (childrenState is ChildrenSuccess) {
                    final children = childrenState.childrenData.children;
                    return PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(97, 148, 81, 1),
                      ),
                      color: Colors.white,
                      onSelected: (String selectedName) {
                        final selected = children.firstWhere((child) => child.firstName == selectedName);
                        setState(() {
                          selectedChildName = selected.firstName;
                          selectedChildId = selected.id.toString();
                        });
                        context.read<BoardBloc>().add(FetchBoardsById(childId: selectedChildId!));
                      },
                      itemBuilder: (BuildContext context) {
                        return children.map((child) {
                          return PopupMenuItem<String>(
                            value: child.firstName,
                            child: Text(
                              child.firstName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(97, 148, 81, 1),
                              ),
                            ),
                          );
                        }).toList();
                      },
                    );
                  } else {
                    return const SizedBox(); // Placeholder while loading
                  }
                },
              ),])
            ]
      ),
          Expanded(
            child: BlocListener<ChildrenBloc, ChildrenState>(
                listener: (context, childrenState) {
                    if (childrenState is ChildrenSuccess) {
                        if (childrenState.childrenData.children.isNotEmpty) {
                            final firstChild = childrenState.childrenData.children.first;
                            if (selectedChildId == null) {
                              setState(() {
                                selectedChildName = firstChild.firstName;
                                selectedChildId = firstChild.id.toString();
                              });
                            context.read<BoardBloc>().add(FetchBoardsById(childId: selectedChildId!));
                            }
                        }
                    }
                },

              child: BlocBuilder<ChildrenBloc, ChildrenState>(
                builder: (context, childrenState) {
                  if (childrenState is ChildrenLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (childrenState is ChildrenFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error loading children: ${childrenState.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChildrenBloc>().add(FetchChildren());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (childrenState is ChildrenSuccess && childrenState.childrenData.children.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.child_care, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No children found'),
                        ],
                      ),
                    );
                  }
                  return BlocBuilder<BoardBloc, BoardState>(
                    builder: (context, state) {
                      if (state is BoardLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is BoardFailure) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            itemCount: 1,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 3 / 4,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => CreateBoardScreen(childId: selectedChildId,)),
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
                            },
                          ),
                        );
                      } else if (state is BoardSuccess) {
                        final boards = state.boardData.boards;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            itemCount: boards.length + 1,
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
                                            builder: (_) => BoardScreen(boardId: board.id.toString(),)
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(hexColor(board.color)),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Align(alignment: Alignment.topRight,
                                                    child: IconButton(
                                                      icon: Icon(Icons.edit),
                                                      color: Colors.white,
                                                      onPressed: () {},)),
                                              ),
                                              SizedBox(height: 50,),
                                              Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(height: 30, color: Color(0xFFF3EFDD)),
                                                    Container(height: 10, color: Color(0xFFD7DB3F)),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      board.name ?? "Без названия",
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => CreateBoardScreen(childId: selectedChildId,)),
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
                  );
                },
              ),
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
    ));
  }
}