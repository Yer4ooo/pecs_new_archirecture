import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';
import 'package:pecs_new_arch/core/navigation/app_router.gr.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_update_request_model.dart';
import 'package:pecs_new_arch/features/board/presentation/bloc/board_bloc.dart';
import 'package:pecs_new_arch/features/parent/presentation/bloc/parent_bloc.dart';
import 'package:pecs_new_arch/features/stickers/data/models/sticker_model.dart';
import 'package:pecs_new_arch/features/stickers/presentation/bloc/stickers_bloc.dart';

import '../../../../core/utils/key_value_storage_service.dart';
import '../../../../translations/locale_keys.g.dart';

@RoutePage()
class BoardsListScreen extends StatefulWidget {
  const BoardsListScreen({super.key});

  @override
  State<BoardsListScreen> createState() => _BoardsListScreenState();
}

class _BoardsListScreenState extends State<BoardsListScreen> {
  final List<Alignment> positions = [
    Alignment.topLeft,
    Alignment.centerRight,
    Alignment.bottomLeft
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ParentBloc>().add(GetChildrenList());
  }

  String selectedChildName = '';
  String selectedChildSurname = '';
  String? selectedChildId;
  Color selectedColor = Color(0xFF619451);

  final List<Color> colors = [
    Color(0xFF619451),
    Color(0xFFFFCC00),
    Color(0xFF236DF6),
    Color(0xFFEE61D8),
    Color(0xFF9747FF),
    Color(0xFFEF3A17),
    Color(0xFFCDEE59),
    Color(0xFF373737),
  ];

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

  void _showEditDialog(BuildContext context, Board board) {
    context.read<StickersBloc>().add(StickersEvent.getStickers());
    final TextEditingController textController = TextEditingController();
    textController.text = board.name;
    List<(int, String, String)> stickersOnBoard =
        List.generate(3, (index) => (-1, '', ''));
    for (StickerElement element in board.stickers) {
      int index = element.position - 1;
      if (index >= 0 && index < 3) {
        stickersOnBoard[index] = (
          element.sticker.id,
          element.sticker.name,
          element.sticker.imageUrl,
        );
      }
    }
    Color selectedColor = Color(hexColor(board.color));
    bool isDragOverTarget = false;

    String boardName = board.name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10).r,
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.boards_edit.tr(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            height: 400,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: selectedColor, width: 7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/Badge.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        color: lightenColor(selectedColor, 0.5)
                                            .withOpacity(0.5),
                                        width: 5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              children: [
                                                Flexible(
                                                    child: DragTarget<
                                                        (
                                                          StickerModel,
                                                          int
                                                        )>(onLeave: (data) {
                                                  setState(() {
                                                    isDragOverTarget = false;
                                                  });
                                                }, onAcceptWithDetails:
                                                        (details) {
                                                  setState(() {
                                                    isDragOverTarget = true;
                                                    if (details.data.$2 >= 0) {
                                                      final temp =
                                                          stickersOnBoard[0];
                                                      stickersOnBoard[0] =
                                                          stickersOnBoard[
                                                              details.data.$2];
                                                      stickersOnBoard[details
                                                          .data.$2] = temp;
                                                    } else {
                                                      stickersOnBoard[0] = (
                                                        details.data.$1.id,
                                                        details.data.$1.name,
                                                        details.data.$1.imageUrl
                                                      );
                                                    }
                                                  });
                                                }, builder: (context,
                                                        candidateData,
                                                        rejectedData) {
                                                  return Align(
                                                      alignment: positions[0],
                                                      child: Draggable<
                                                          (StickerModel, int)>(
                                                        data: (
                                                          StickerModel(
                                                              id: stickersOnBoard[
                                                                      0]
                                                                  .$1,
                                                              name:
                                                                  stickersOnBoard[
                                                                          0]
                                                                      .$2,
                                                              imageUrl:
                                                                  stickersOnBoard[
                                                                          0]
                                                                      .$3),
                                                          0
                                                        ),
                                                        feedback:
                                                            stickersOnBoard[0]
                                                                        .$1 !=
                                                                    -1
                                                                ? SvgPicture
                                                                    .network(
                                                                    stickersOnBoard[
                                                                            0]
                                                                        .$3,
                                                                  )
                                                                : SizedBox(),
                                                        childWhenDragging:
                                                            SizedBox(),
                                                        onDragEnd: (details) {
                                                          if (!isDragOverTarget) {
                                                            setState(() {
                                                              stickersOnBoard[
                                                                      0] =
                                                                  (-1, '', '');
                                                            });
                                                          }
                                                        },
                                                        child:
                                                            stickersOnBoard[0]
                                                                        .$1 !=
                                                                    -1
                                                                ? SvgPicture
                                                                    .network(
                                                                    stickersOnBoard[
                                                                            0]
                                                                        .$3,
                                                                  )
                                                                : SizedBox(),
                                                      ));
                                                })),
                                                Flexible(
                                                    child: DragTarget<
                                                        (
                                                          StickerModel,
                                                          int
                                                        )>(onLeave: (data) {
                                                  setState(() {
                                                    isDragOverTarget = false;
                                                  });
                                                }, onAcceptWithDetails:
                                                        (details) {
                                                  setState(() {
                                                    isDragOverTarget = true;

                                                    if (details.data.$2 >= 0) {
                                                      final temp =
                                                          stickersOnBoard[1];
                                                      stickersOnBoard[1] =
                                                          stickersOnBoard[
                                                              details.data.$2];
                                                      stickersOnBoard[details
                                                          .data.$2] = temp;
                                                    } else {
                                                      stickersOnBoard[1] = (
                                                        details.data.$1.id,
                                                        details.data.$1.name,
                                                        details.data.$1.imageUrl
                                                      );
                                                    }
                                                  });
                                                }, builder: (context,
                                                        candidateData,
                                                        rejectedData) {
                                                  return Align(
                                                      alignment: positions[1],
                                                      child: Draggable<
                                                          (StickerModel, int)>(
                                                        data: (
                                                          StickerModel(
                                                              id: stickersOnBoard[
                                                                      1]
                                                                  .$1,
                                                              name:
                                                                  stickersOnBoard[
                                                                          1]
                                                                      .$2,
                                                              imageUrl:
                                                                  stickersOnBoard[
                                                                          1]
                                                                      .$3),
                                                          1
                                                        ),
                                                        feedback: stickersOnBoard[
                                                                        1]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        1]
                                                                    .$3)
                                                            : SizedBox(),
                                                        childWhenDragging:
                                                            SizedBox(),
                                                        onDragEnd: (details) {
                                                          if (!isDragOverTarget) {
                                                            setState(() {
                                                              stickersOnBoard[
                                                                      1] =
                                                                  (-1, '', '');
                                                            });
                                                          }
                                                        },
                                                        child: stickersOnBoard[
                                                                        1]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        1]
                                                                    .$3)
                                                            : SizedBox(),
                                                      ));
                                                })),
                                                Flexible(
                                                    child: DragTarget<
                                                        (
                                                          StickerModel,
                                                          int
                                                        )>(onLeave: (data) {
                                                  setState(() {
                                                    isDragOverTarget = false;
                                                  });
                                                }, onAcceptWithDetails:
                                                        (details) {
                                                  setState(() {
                                                    isDragOverTarget = true;
                                                    if (details.data.$2 >= 0) {
                                                      final temp =
                                                          stickersOnBoard[2];
                                                      stickersOnBoard[2] =
                                                          stickersOnBoard[
                                                              details.data.$2];
                                                      stickersOnBoard[details
                                                          .data.$2] = temp;
                                                    } else {
                                                      stickersOnBoard[2] = (
                                                        details.data.$1.id,
                                                        details.data.$1.name,
                                                        details.data.$1.imageUrl
                                                      );
                                                    }
                                                  });
                                                }, builder: (context,
                                                        candidateData,
                                                        rejectedData) {
                                                  return Align(
                                                      alignment: positions[2],
                                                      child: Draggable<
                                                          (StickerModel, int)>(
                                                        data: (
                                                          StickerModel(
                                                              id: stickersOnBoard[
                                                                      2]
                                                                  .$1,
                                                              name:
                                                                  stickersOnBoard[
                                                                          2]
                                                                      .$2,
                                                              imageUrl:
                                                                  stickersOnBoard[
                                                                          2]
                                                                      .$3),
                                                          2
                                                        ),
                                                        feedback: stickersOnBoard[
                                                                        2]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        2]
                                                                    .$3)
                                                            : SizedBox(),
                                                        childWhenDragging:
                                                            SizedBox(),
                                                        onDragEnd: (details) {
                                                          if (!isDragOverTarget) {
                                                            setState(() {
                                                              stickersOnBoard[
                                                                      2] =
                                                                  (-1, '', '');
                                                            });
                                                          }
                                                        },
                                                        child: stickersOnBoard[
                                                                        2]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        2]
                                                                    .$3)
                                                            : SizedBox(),
                                                      ));
                                                })),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    boardName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Color(0xFF676767),
                                                      fontFamily: 'Caveat',
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
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
                                Text(
                                  boardName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.boards_name.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: textController,
                                        decoration: InputDecoration(
                                          hintText: boardName,
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 16,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: colors[0],
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            boardName = value != ''
                                                ? value
                                                : board.name;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.boards_color.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: colors.length,
                                          itemBuilder: (context, index) {
                                            final color = colors[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedColor = color;
                                                });
                                              },
                                              child: Container(
                                                width: 60,
                                                margin:
                                                    EdgeInsets.only(right: 12),
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: selectedColor ==
                                                            color
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          width: 300,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  LocaleKeys.boards_stickers
                                                      .tr(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 5),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    height: 195,
                                                    child: BlocBuilder<
                                                        StickersBloc,
                                                        StickersState>(
                                                      builder:
                                                          (context, state) {
                                                        if (state
                                                            is StickersLoading) {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else if (state
                                                            is StickersError) {
                                                          return Text(
                                                              state.message);
                                                        } else if (state
                                                            is StickersLoaded) {
                                                          final stickers =
                                                              state.stickers;
                                                          return GridView
                                                              .builder(
                                                                  primary:
                                                                      false,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        5,
                                                                    crossAxisSpacing:
                                                                        10,
                                                                    mainAxisSpacing:
                                                                        10,
                                                                  ),
                                                                  itemCount:
                                                                      stickers!
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Draggable<
                                                                        (
                                                                          StickerModel,
                                                                          int
                                                                        )>(
                                                                      data: (
                                                                        stickers[
                                                                            index],
                                                                        -1
                                                                      ),
                                                                      feedback:
                                                                          SizedBox(
                                                                        width:
                                                                            50,
                                                                        child: stickers[index].imageUrl.toLowerCase().endsWith('.svg')
                                                                            ? SvgPicture.network(stickers[index].imageUrl)
                                                                            : Image.network(stickers[index].imageUrl),
                                                                      ),
                                                                      child: stickers[index]
                                                                              .imageUrl
                                                                              .toLowerCase()
                                                                              .endsWith(
                                                                                  '.svg')
                                                                          ? SvgPicture.network(stickers[index]
                                                                              .imageUrl)
                                                                          : Image.network(
                                                                              stickers[index].imageUrl),
                                                                    );
                                                                  });
                                                        }
                                                        return SizedBox();
                                                      },
                                                    )),
                                              ]))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    bool? confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(LocaleKeys
                                              .boards_confirm_delete
                                              .tr()),
                                          content: Text(LocaleKeys
                                              .boards_delete_board
                                              .tr()),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text(LocaleKeys
                                                  .boards_cancel
                                                  .tr()),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red),
                                              child: Text(LocaleKeys
                                                  .boards_delete
                                                  .tr()),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm == true) {
                                      // ignore: use_build_context_synchronously
                                      context.read<BoardBloc>().add(
                                          (DeleteBoard(
                                              childId:
                                                  int.parse(selectedChildId!),
                                              boardId: board.id)));
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 40.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                10.horizontalSpace,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: colors[0]),
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        LocaleKeys.boards_cancel.tr(),
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: colors[0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    List<Sticker> stickers = stickersOnBoard
                                        .asMap()
                                        .entries
                                        .where((entry) => entry.value.$1 != -1)
                                        .map((entry) {
                                      int index = entry.key;
                                      var tuple = entry.value;
                                      return Sticker(
                                        position: index + 1,
                                        stickerId: tuple.$1,
                                      );
                                    }).toList();
                                    context.read<BoardBloc>().add((UpdateBoard(
                                        board: BoardUpdateRequestModel(
                                            name: boardName,
                                            private: true,
                                            color:
                                                '#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}',
                                            stickers: stickers),
                                        boardId: board.id,
                                        childId: int.parse(selectedChildId!))));
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: colors[0],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        LocaleKeys.boards_save.tr(),
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context) {
    context.read<StickersBloc>().add(StickersEvent.getStickers());
    final TextEditingController textController = TextEditingController();
    List<(int, String, String)> stickersOnBoard = [
      (-1, '', ''),
      (-1, '', ''),
      (-1, '', '')
    ];
    Color selectedColor = colors[0];
    bool isDragOverTarget = false;

    String boardName = LocaleKeys.boards_create.tr();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.boards_create.tr(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            height: 400,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: selectedColor, width: 7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/Badge.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        color: lightenColor(selectedColor, 0.5)
                                            .withOpacity(0.5),
                                        width: 5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              children: [
                                                Flexible(
                                                    child: DragTarget<
                                                        (
                                                          StickerModel,
                                                          int
                                                        )>(onLeave: (data) {
                                                  setState(() {
                                                    isDragOverTarget = false;
                                                  });
                                                }, onAcceptWithDetails:
                                                        (details) {
                                                  setState(() {
                                                    isDragOverTarget = true;
                                                    if (details.data.$2 >= 0) {
                                                      final temp =
                                                          stickersOnBoard[0];
                                                      stickersOnBoard[0] =
                                                          stickersOnBoard[
                                                              details.data.$2];
                                                      stickersOnBoard[details
                                                          .data.$2] = temp;
                                                    } else {
                                                      stickersOnBoard[0] = (
                                                        details.data.$1.id,
                                                        details.data.$1.name,
                                                        details.data.$1.imageUrl
                                                      );
                                                    }
                                                  });
                                                }, builder: (context,
                                                        candidateData,
                                                        rejectedData) {
                                                  return Align(
                                                      alignment: positions[0],
                                                      child: Draggable<
                                                          (StickerModel, int)>(
                                                        data: (
                                                          StickerModel(
                                                              id: stickersOnBoard[
                                                                      0]
                                                                  .$1,
                                                              name:
                                                                  stickersOnBoard[
                                                                          0]
                                                                      .$2,
                                                              imageUrl:
                                                                  stickersOnBoard[
                                                                          0]
                                                                      .$3),
                                                          0
                                                        ),
                                                        feedback: stickersOnBoard[
                                                                        0]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        0]
                                                                    .$3)
                                                            : SizedBox(),
                                                        childWhenDragging:
                                                            SizedBox(),
                                                        onDragEnd: (details) {
                                                          if (!isDragOverTarget) {
                                                            setState(() {
                                                              stickersOnBoard[
                                                                      0] =
                                                                  (-1, '', '');
                                                            });
                                                          }
                                                        },
                                                        child: stickersOnBoard[
                                                                        0]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        0]
                                                                    .$3)
                                                            : SizedBox(),
                                                      ));
                                                })),
                                                Flexible(
                                                    child: DragTarget<
                                                        (
                                                          StickerModel,
                                                          int
                                                        )>(onLeave: (data) {
                                                  setState(() {
                                                    isDragOverTarget = false;
                                                  });
                                                }, onAcceptWithDetails:
                                                        (details) {
                                                  setState(() {
                                                    isDragOverTarget = true;

                                                    if (details.data.$2 >= 0) {
                                                      final temp =
                                                          stickersOnBoard[1];
                                                      stickersOnBoard[1] =
                                                          stickersOnBoard[
                                                              details.data.$2];
                                                      stickersOnBoard[details
                                                          .data.$2] = temp;
                                                    } else {
                                                      stickersOnBoard[1] = (
                                                        details.data.$1.id,
                                                        details.data.$1.name,
                                                        details.data.$1.imageUrl
                                                      );
                                                    }
                                                  });
                                                }, builder: (context,
                                                        candidateData,
                                                        rejectedData) {
                                                  return Align(
                                                      alignment: positions[1],
                                                      child: Draggable<
                                                          (StickerModel, int)>(
                                                        data: (
                                                          StickerModel(
                                                              id: stickersOnBoard[
                                                                      1]
                                                                  .$1,
                                                              name:
                                                                  stickersOnBoard[
                                                                          1]
                                                                      .$2,
                                                              imageUrl:
                                                                  stickersOnBoard[
                                                                          1]
                                                                      .$3),
                                                          1
                                                        ),
                                                        feedback: stickersOnBoard[
                                                                        1]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        1]
                                                                    .$3)
                                                            : SizedBox(),
                                                        childWhenDragging:
                                                            SizedBox(),
                                                        onDragEnd: (details) {
                                                          if (!isDragOverTarget) {
                                                            setState(() {
                                                              stickersOnBoard[
                                                                      1] =
                                                                  (-1, '', '');
                                                            });
                                                          }
                                                        },
                                                        child: stickersOnBoard[
                                                                        1]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        1]
                                                                    .$3)
                                                            : SizedBox(),
                                                      ));
                                                })),
                                                Flexible(
                                                    child: DragTarget<
                                                        (
                                                          StickerModel,
                                                          int
                                                        )>(onLeave: (data) {
                                                  setState(() {
                                                    isDragOverTarget = false;
                                                  });
                                                }, onAcceptWithDetails:
                                                        (details) {
                                                  setState(() {
                                                    isDragOverTarget = true;
                                                    if (details.data.$2 >= 0) {
                                                      final temp =
                                                          stickersOnBoard[2];
                                                      stickersOnBoard[2] =
                                                          stickersOnBoard[
                                                              details.data.$2];
                                                      stickersOnBoard[details
                                                          .data.$2] = temp;
                                                    } else {
                                                      stickersOnBoard[2] = (
                                                        details.data.$1.id,
                                                        details.data.$1.name,
                                                        details.data.$1.imageUrl
                                                      );
                                                    }
                                                  });
                                                }, builder: (context,
                                                        candidateData,
                                                        rejectedData) {
                                                  return Align(
                                                      alignment: positions[2],
                                                      child: Draggable<
                                                          (StickerModel, int)>(
                                                        data: (
                                                          StickerModel(
                                                              id: stickersOnBoard[
                                                                      2]
                                                                  .$1,
                                                              name:
                                                                  stickersOnBoard[
                                                                          2]
                                                                      .$2,
                                                              imageUrl:
                                                                  stickersOnBoard[
                                                                          2]
                                                                      .$3),
                                                          2
                                                        ),
                                                        feedback: stickersOnBoard[
                                                                        2]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        2]
                                                                    .$3)
                                                            : SizedBox(),
                                                        childWhenDragging:
                                                            SizedBox(),
                                                        onDragEnd: (details) {
                                                          if (!isDragOverTarget) {
                                                            setState(() {
                                                              stickersOnBoard[
                                                                      2] =
                                                                  (-1, '', '');
                                                            });
                                                          }
                                                        },
                                                        child: stickersOnBoard[
                                                                        2]
                                                                    .$1 !=
                                                                -1
                                                            ? SvgPicture.network(
                                                                stickersOnBoard[
                                                                        2]
                                                                    .$3)
                                                            : SizedBox(),
                                                      ));
                                                })),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    boardName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Color(0xFF676767),
                                                      fontFamily: 'Caveat',
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
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
                                Text(
                                  boardName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.boards_name.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: textController,
                                        decoration: InputDecoration(
                                          hintText:
                                              LocaleKeys.boards_enter.tr(),
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 16,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: colors[0],
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            boardName = value != ''
                                                ? value
                                                : LocaleKeys.boards_create.tr();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.boards_color.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: colors.length,
                                          itemBuilder: (context, index) {
                                            final color = colors[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedColor = color;
                                                });
                                              },
                                              child: Container(
                                                width: 60,
                                                margin:
                                                    EdgeInsets.only(right: 12),
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: selectedColor ==
                                                            color
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          width: 300,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  LocaleKeys.boards_stickers
                                                      .tr(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 5),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    height: 195,
                                                    child: BlocBuilder<
                                                        StickersBloc,
                                                        StickersState>(
                                                      builder:
                                                          (context, state) {
                                                        if (state
                                                            is StickersLoading) {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else if (state
                                                            is StickersError) {
                                                          return Text(
                                                              state.message);
                                                        } else if (state
                                                            is StickersLoaded) {
                                                          final stickers =
                                                              state.stickers;
                                                          return GridView
                                                              .builder(
                                                                  primary:
                                                                      false,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        5,
                                                                    crossAxisSpacing:
                                                                        10,
                                                                    mainAxisSpacing:
                                                                        10,
                                                                  ),
                                                                  itemCount:
                                                                      stickers!
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Draggable<
                                                                        (
                                                                          StickerModel,
                                                                          int
                                                                        )>(
                                                                      data: (
                                                                        stickers[
                                                                            index],
                                                                        -1
                                                                      ),
                                                                      feedback:
                                                                          SizedBox(
                                                                        width:
                                                                            50,
                                                                        child: stickers[index].imageUrl.toLowerCase().endsWith('.svg')
                                                                            ? SvgPicture.network(stickers[index].imageUrl)
                                                                            : Image.network(stickers[index].imageUrl),
                                                                      ),
                                                                      child: stickers[index]
                                                                              .imageUrl
                                                                              .toLowerCase()
                                                                              .endsWith(
                                                                                  '.svg')
                                                                          ? SvgPicture.network(stickers[index]
                                                                              .imageUrl)
                                                                          : Image.network(
                                                                              stickers[index].imageUrl),
                                                                    );
                                                                  });
                                                        }
                                                        return SizedBox();
                                                      },
                                                    )),
                                              ]))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: colors[0]),
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        LocaleKeys.boards_cancel.tr(),
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: colors[0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    List<Sticker> stickers = stickersOnBoard
                                        .asMap()
                                        .entries
                                        .where((entry) => entry.value.$1 != -1)
                                        .map((entry) {
                                      int index = entry.key;
                                      var tuple = entry.value;
                                      return Sticker(
                                        position: index + 1,
                                        stickerId: tuple.$1,
                                      );
                                    }).toList();
                                    context.read<BoardBloc>().add((CreateBoard(
                                        board: BoardCreateRequestModel(
                                            name: boardName,
                                            private: true,
                                            color:
                                                '#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}',
                                            stickers: stickers),
                                        id: int.parse(selectedChildId!))));

                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: colors[0],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        LocaleKeys.boards_create_button.tr(),
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.boards_my_boards.tr(),
                  style:
                      TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                BlocBuilder<ParentBloc, ParentState>(
                    builder: (context, parentState) {
                  if (parentState is ChildrenListLoaded) {
                    final children = parentState.childrenList?.children ?? [];
                    if (children.isEmpty) {
                      return SizedBox();
                    }
                    return Row(
                      children: [
                        SizedBox(
                          height: 48.h,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromRGBO(97, 148, 81, 1),
                                width: 1.5.w,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                SizedBox(
                                  width: 300.w,
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: LocaleKeys.boards_search.tr(),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 16.sp),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        SizedBox(
                            width: 325.w,
                            height: 48.h,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color.fromRGBO(97, 148, 81, 1),
                                  width: 1.5.w,
                                ),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$selectedChildName $selectedChildSurname",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color.fromRGBO(97, 148, 81, 1),
                                    ),
                                    color: Colors.white,
                                    onSelected: (String selectedName) {
                                      final selected = children.firstWhere(
                                        (child) =>
                                            child.firstName == selectedName,
                                      );
                                      setState(() {
                                        selectedChildName = selected.firstName;
                                        selectedChildSurname =
                                            selected.lastName;
                                        selectedChildId =
                                            selected.id.toString();
                                      });
                                      context.read<BoardBloc>().add(
                                            BoardEvent.getBoard(
                                              id: int.parse(selectedChildId!),
                                            ),
                                          );
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return children.map((child) {
                                        return PopupMenuItem<String>(
                                          value: child.firstName,
                                          child: SizedBox(
                                            width: 325.w,
                                            child: Text(
                                              "${child.firstName} ${child.lastName}",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ],
                              ),
                            )),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                })
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<ParentBloc, ParentState>(
              listener: (context, parentState) {
                if (parentState is ChildrenListLoaded) {
                  if (parentState.childrenList!.children.isNotEmpty) {
                    final firstChild = parentState.childrenList!.children.first;
                    if (selectedChildId == null) {
                      setState(() {
                        selectedChildName = firstChild.firstName;
                        selectedChildSurname = firstChild.lastName;
                        selectedChildId = firstChild.id.toString();
                      });
                      context.read<BoardBloc>().add(
                          BoardEvent.getBoard(id: int.parse(selectedChildId!)));
                    }
                  }
                }
              },
              builder: (context, parentState) {
                if (parentState is ChildrenListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (parentState is ChildrenListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64.r, color: Colors.red),
                        SizedBox(height: 16.h),
                        Text('Error loading children: ${parentState.message}'),
                        SizedBox(height: 16.h),
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.child_care, size: 64.sp, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text('No children found'),
                      ],
                    ),
                  );
                }
                return BlocConsumer<BoardBloc, BoardState>(
                  builder: (context, state) {
                    if (state is BoardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BoardError) {
                      return Text('Error');
                    } else if (state is BoardLoaded) {
                      final List<Board>? filteredBoards = _searchQuery.isEmpty
                          ? state.boards?.boards
                          : state.boards?.boards
                              .where((board) => (board.name)
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()))
                              .toList();
                      return Padding(
                        padding: EdgeInsets.all(40.0).r,
                        child: GridView.builder(
                          itemCount: filteredBoards!.length + 1,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 45.w,
                            mainAxisSpacing: 45.h,
                            childAspectRatio: 3 / 4,
                          ),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showCreateDialog(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE3E3E3),
                                          border: Border.all(
                                            color: Color(0xFF767680),
                                            width: 7.w,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                            child: IconButton.filled(
                                          style: IconButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF767680)),
                                          onPressed: () {
                                            _showCreateDialog(context);
                                          },
                                          icon: Icon(Icons.add,
                                              size: 40.sp,
                                              color: Color(0xFFE3E3E3)),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(LocaleKeys.boards_create.tr(),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  )
                                ],
                              );
                            } else {
                              final boardIndex = index - 1;
                              final board = filteredBoards[boardIndex];
                              final sticPos = board.getPositions();
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: GestureDetector(
                                      onTap: () {
                                        context.router.popAndPush(
                                          BoardRoute(
                                              boardId: board.id.toString()),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Color(hexColor(board.color)),
                                              width: 7.w),
                                          borderRadius:
                                              BorderRadius.circular(12).r,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5).r,
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
                                                  width: 5.w)),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0).r,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: Column(children: [
                                                    Flexible(
                                                        flex: 3,
                                                        child: Stack(children: [
                                                          sticPos.contains(1)
                                                              ? Align(
                                                                  alignment:
                                                                      positions[
                                                                          0],
                                                                  child: SvgPicture
                                                                      .network(
                                                                    board
                                                                        .stickers[
                                                                            board.getIndexByPosition(1) ??
                                                                                0]
                                                                        .sticker
                                                                        .imageUrl,
                                                                  ),
                                                                )
                                                              : SizedBox
                                                                  .expand(),
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border.all(
                                                                      color: Color(
                                                                          0xFF8B8A8D)),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                              10)
                                                                          .r),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  _showEditDialog(
                                                                      context,
                                                                      board);
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                              2)
                                                                          .r,
                                                                  child: Icon(
                                                                    Icons
                                                                        .edit_outlined,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ])),
                                                    Flexible(
                                                        flex: 3,
                                                        child:
                                                            sticPos.contains(2)
                                                                ? Align(
                                                                    alignment:
                                                                        positions[
                                                                            1],
                                                                    child: SvgPicture
                                                                        .network(
                                                                      board
                                                                          .stickers[board.getIndexByPosition(2) ??
                                                                              0]
                                                                          .sticker
                                                                          .imageUrl,
                                                                    ),
                                                                  )
                                                                : SizedBox
                                                                    .expand()),
                                                    Flexible(
                                                        flex: 3,
                                                        child:
                                                            sticPos.contains(3)
                                                                ? Align(
                                                                    alignment:
                                                                        positions[
                                                                            2],
                                                                    child: SvgPicture
                                                                        .network(
                                                                      board
                                                                          .stickers[board.getIndexByPosition(3) ??
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                        left: 5)
                                                                    .w,
                                                            child: Text(
                                                              '${board.name} ',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF676767),
                                                                fontFamily:
                                                                    'Caveat',
                                                                fontSize: 24.sp,
                                                                // Reduced font size
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5)
                                                              .w,
                                                          child: Image.asset(
                                                            'assets/images/Vector.png',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
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
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      board.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18.sp,
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
                  listener: (BuildContext context, BoardState state) {
                    if (state is CreateBoardLoaded ||
                        state is DeleteBoardLoaded ||
                        state is UpdateBoardLoaded) {
                      context.read<BoardBloc>().add(
                            BoardEvent.getBoard(
                              id: int.parse(selectedChildId!),
                            ),
                          );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
