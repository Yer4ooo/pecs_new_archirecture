import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/features/board/presentation/bloc/board_bloc.dart';
import 'package:pecs_new_arch/features/board/presentation/screens/board.dart';
import 'package:pecs_new_arch/features/parent/presentation/bloc/parent_bloc.dart';

class BoardsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const BoardsScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<BoardsScreen> createState() => _BoardsScreenState();
}

class _BoardsScreenState extends State<BoardsScreen> {
  final List<Alignment> positions = [
    Alignment.topLeft,
    Alignment.centerRight,
    Alignment.bottomLeft
  ];
  @override
  void initState() {
    super.initState();
    context.read<ParentBloc>().add(GetChildrenList());
  }

  String? selectedChildName;
  String? selectedChildId;

  hexColor(String color) {
    String colorNew = '0xFF$color';
    colorNew = colorNew.replaceAll('#', '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }

  Color lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, "Amount should be between 0 and 1");
    return Color.lerp(color, Colors.white, amount)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Мои доски",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(children: [
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
              BlocBuilder<ParentBloc, ParentState>(
                builder: (context, parentState) {
                  if (parentState is ChildrenListLoaded) {
                    final children = parentState.childrenList!.children;
                    return PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(97, 148, 81, 1),
                      ),
                      color: Colors.white,
                      onSelected: (String selectedName) {
                        final selected = children.firstWhere(
                            (child) => child.firstName == selectedName);
                        setState(() {
                          selectedChildName = selected.firstName;
                          selectedChildId = selected.id.toString();
                        });
                        context.read<BoardBloc>().add(BoardEvent.getBoard(
                            id: int.parse(selectedChildId!)));
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
                    return const SizedBox();
                  }
                },
              ),
            ])
          ]),
          Expanded(
            child: BlocListener<ParentBloc, ParentState>(
              listener: (context, parentState) {
                if (parentState is ChildrenListLoaded) {
                  if (parentState.childrenList!.children.isNotEmpty) {
                    final firstChild = parentState.childrenList!.children.first;
                    if (selectedChildId == null) {
                      setState(() {
                        selectedChildName = firstChild.firstName;
                        selectedChildId = firstChild.id.toString();
                      });
                      context.read<BoardBloc>().add(
                          BoardEvent.getBoard(id: int.parse(selectedChildId!)));
                    }
                  }
                }
              },
              child: BlocBuilder<ParentBloc, ParentState>(
                builder: (context, parentState) {
                  if (parentState is ChildrenListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (parentState is ChildrenListError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                              'Error loading children: ${parentState.message}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ParentBloc>().add(GetChildrenList());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (parentState is ChildrenListLoaded &&
                      parentState.childrenList!.children.isEmpty) {
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
                      } else if (state is BoardError) {
                        return Text('Error');
                      } else if (state is BoardLoaded) {
                        final boards = state.boards!.boards;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            itemCount: boards.length + 1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 30,
                              childAspectRatio: 3 / 5,
                            ),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (_) => CreateBoardScreen(
                                    //             childId: selectedChildId,
                                    //           )),
                                    // );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE3E3E3),
                                            border: Border.all(
                                              color: Color(0xFF767680),
                                              width: 7,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                              child: IconButton.filled(
                                            style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF767680)),
                                            onPressed: () {},
                                            icon: const Icon(Icons.add,
                                                size: 40,
                                                color: Color(0xFFE3E3E3)),
                                          )),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        flex: 2,
                                        child:
                                            const Text("Добавить новую доску",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                final boardIndex = index - 1;
                                final board = boards[boardIndex];
                                final sticPos = board.getPositions();
                                final count = sticPos.length;
                                return Column(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: GestureDetector(
                                        onTap: () => widget
                                            .navigatorKey.currentState
                                            ?.push(
                                          MaterialPageRoute(
                                            builder: (_) => BoardScreen(
                                              boardId: board.id.toString(),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(
                                                    hexColor(board.color)),
                                                width: 7),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/Badge.png'),
                                                    fit: BoxFit.cover),
                                                border: Border.all(
                                                    color: lightenColor(
                                                            Color(hexColor(
                                                                board.color)),
                                                            0.5)
                                                        .withOpacity(0.5),
                                                    width: 5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Column(children: [
                                                      Flexible(
                                                          flex: 3,
                                                          child: Stack(
                                                              children: [
                                                                sticPos.contains(
                                                                        1)
                                                                    ? Align(
                                                                        alignment:
                                                                            positions[0],
                                                                        child: SvgPicture
                                                                            .network(
                                                                          board
                                                                              .stickers[board.getIndexByPosition(1) ?? 0]
                                                                              .sticker
                                                                              .imageUrl,
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .expand(),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        border: Border.all(
                                                                            color: Color(
                                                                                0xFF8B8A8D)),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .edit_outlined,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ])),
                                                      Flexible(
                                                          flex: 3,
                                                          child: sticPos
                                                                  .contains(2)
                                                              ? Align(
                                                                  alignment:
                                                                      positions[
                                                                          1],
                                                                  child: SvgPicture
                                                                      .network(
                                                                    board
                                                                        .stickers[
                                                                            board.getIndexByPosition(2) ??
                                                                                0]
                                                                        .sticker
                                                                        .imageUrl,
                                                                  ),
                                                                )
                                                              : SizedBox
                                                                  .expand()),
                                                      Flexible(
                                                          flex: 3,
                                                          child: sticPos
                                                                  .contains(3)
                                                              ? Align(
                                                                  alignment:
                                                                      positions[
                                                                          2],
                                                                  child: SvgPicture
                                                                      .network(
                                                                    board
                                                                        .stickers[
                                                                            board.getIndexByPosition(3) ??
                                                                                0]
                                                                        .sticker
                                                                        .imageUrl,
                                                                  ),
                                                                )
                                                              : SizedBox
                                                                  .expand()),
                                                    ]),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Text(
                                                            '${board.name} ',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF676767),
                                                              fontFamily:
                                                                  'Caveat',
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child: Image.asset(
                                                              fit: BoxFit.cover,
                                                              'assets/images/Vector.png'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        board.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
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
        ],
      ),
    );
  }
}
