import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pecs_new_arch/features/board/data/models/board_tabs_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_update_request_model.dart';
import 'package:pecs_new_arch/features/board/presentation/widgets/bottom_board.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/board/data/models/board_details_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tts_play_request_model.dart';
import 'package:pecs_new_arch/features/board/presentation/bloc/board_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../../library/data/models/categories_global_model.dart';

@RoutePage()
class BoardScreen extends StatefulWidget {
  final String boardId;

  const BoardScreen({required this.boardId, super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final List<Color> colors = [
    Color(0xFF619451),
    Color(0xFFFFCC00),
    Color(0xFF236DF6),
    Color(0xFFEE61D8),
    Color(0xFF9747FF),
    Color(0xFFEF3A17),
    Color(0xFFCDEE59),
    Color(0xFF373737),
    Color(0xFF373737),
  ];
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  final ValueNotifier<bool> isOverDeleteZone = ValueNotifier(false);
  int chosenCategoryId = 0;
  String chosenCategoryName = '';
  bool isImagesVisible = false;
  int curTabId = 0;
  late final List<ImageElement> _alternativeContainerItems = [];
  bool _dragImages = false;
  bool isTTSLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int categoriesCount = 0;
  late List<BaseItem>? categories = [];
  int offset = 0;
  final int limit = 20;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  List<CategoriesImagesListModel> images = [];
  int imageOffset = 0;
  late int imageLimit = 20;
  bool isLoadingMoreImage = false;
  bool hasMoreImage = true;
  final ScrollController _scrollImageController = ScrollController();
  BoardsTabsResponseModel tabDetails = BoardsTabsResponseModel(images: []);
  bool isHoveringOverDeleteZone = false;
  Timer? _searchDebounce;

  void onCategoryTap(int? id, String? name) {
    setState(() {
      searchQuery = '';
      searchController.clear();
      isImagesVisible = !isImagesVisible;
      chosenCategoryId = id!;
      chosenCategoryName = name!;
      if (chosenCategoryId != 0) {
        context
            .read<LibraryBloc>()
            .add(GetCategoryImagesById(id: chosenCategoryId, params: {
              'limit': imageLimit,
              'offset': imageOffset,
            }));
      } else {
        offset = 0;
        context.read<LibraryBloc>().add(GetCategoriesGlobal(params: {
              'limit': limit,
              'offset': offset,
            }));
      }
    });
  }

  Color lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, "Amount should be between 0 and 1");
    return Color.lerp(color, Colors.white, amount)!;
  }

  hexColor(String color) {
    String colorNew = '0xFF$color';
    colorNew = colorNew.replaceAll('#', '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !isLoadingMore &&
          hasMoreData) {
        _fetchMoreCategories();
      }
    });
    _scrollImageController.addListener(() {
      if (_scrollImageController.position.pixels >=
              _scrollImageController.position.maxScrollExtent - 300 &&
          !isLoadingMoreImage &&
          hasMoreImage) {
        _fetchMoreImages();
      }
    });
    context
        .read<BoardBloc>()
        .add(GetBoardDetails(id: int.parse(widget.boardId)));
    context
        .read<LibraryBloc>()
        .add(GetCategoriesGlobal(params: {'limit': limit, 'offset': offset}));
  }

  void _fetchMoreImages() {
    isLoadingMoreImage = true;
    imageOffset += imageLimit;

    context
        .read<LibraryBloc>()
        .add(GetCategoryImagesById(id: chosenCategoryId, params: {
          'limit': imageLimit,
          'offset': imageOffset,
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        }));
  }

  void _fetchMoreCategories() {
    isLoadingMore = true;
    offset += limit;

    context.read<LibraryBloc>().add(
          GetCategoriesGlobal(
            params: {
              'limit': limit,
              'offset': offset,
              if (searchQuery.isNotEmpty) 'search': searchQuery,
            },
          ),
        );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _player.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _playBytesAsAudio(List<int> bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/tts_audio.mp3');
      await file.writeAsBytes(bytes, flush: true);
      await _player.setFilePath(file.path);
      await _player.play();
    } catch (e) {
      log('Error playing audio: $e');
    }
  }

  void _showCreateDialog(BuildContext context, Board board) {
    String tabName = 'untitled';
    double selectedStraps = 3;
    Color selectedColor = colors[0];
    final TextEditingController textController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
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
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      LocaleKeys.boards_create_tab.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    LocaleKeys.boards_tab_name.tr(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: textController,
                                      decoration: InputDecoration(
                                        hintText: LocaleKeys.boards_enter.tr(),
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
                                          tabName = value;
                                        });
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    LocaleKeys.boards_straps.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Slider(
                                    value: selectedStraps,
                                    label: selectedStraps.round().toString(),
                                    min: 2,
                                    max: 6,
                                    divisions: 4,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedStraps = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    LocaleKeys.boards_tab_color.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
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
                                            margin: EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: selectedColor == color
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: colors[0]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    LocaleKeys.boards_cancel
                                                        .tr(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                if (board.tabs.length < 5) {
                                                  context.read<BoardBloc>().add(
                                                      (CreateTab(
                                                          tab: TabCreateRequestModel(
                                                              boardId: board.id,
                                                              name: tabName,
                                                              strapsNum:
                                                                  selectedStraps
                                                                      .round(),
                                                              color:
                                                                  '#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}'))));
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: colors[0],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    LocaleKeys
                                                        .boards_create_button
                                                        .tr(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                ])))));
          });
        });
  }

  void _showEditDialog(BuildContext context, Tab tab, Board board) {
    String tabName = tab.name;
    double selectedStraps = tab.strapsNum.toDouble();
    Color selectedColor = Color(hexColor(tab.color));
    final TextEditingController textController = TextEditingController();
    textController.text = tabName;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
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
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      LocaleKeys.boards_edit_tab.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    LocaleKeys.boards_tab_name.tr(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: textController,
                                      decoration: InputDecoration(
                                        hintText: LocaleKeys.boards_enter.tr(),
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
                                          tabName = value;
                                        });
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    LocaleKeys.boards_straps.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Slider(
                                    value: selectedStraps,
                                    label: selectedStraps.round().toString(),
                                    min: 2,
                                    max: 6,
                                    divisions: 4,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedStraps = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    LocaleKeys.boards_tab_color.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
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
                                            margin: EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: selectedColor == color
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                bool? confirm =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        LocaleKeys
                                                            .boards_confirm_delete
                                                            .tr(),
                                                      ),
                                                      content: Text(LocaleKeys
                                                          .boards_delete_tab
                                                          .tr()),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: Text(LocaleKeys
                                                              .boards_cancel
                                                              .tr()),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          style: TextButton
                                                              .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .red),
                                                          child: Text(LocaleKeys
                                                              .boards_delete
                                                              .tr()),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (confirm == true &&
                                                    board.tabs.length >= 2) {
                                                  context.read<BoardBloc>().add(
                                                      (DeleteTab(
                                                          tabId: tab.id)));
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Container(
                                                height: 40.h,
                                                width: 40.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.red),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
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
                                                  border: Border.all(
                                                      color: colors[0]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    LocaleKeys.boards_cancel
                                                        .tr(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                context.read<BoardBloc>().add(
                                                    (UpdateTab(
                                                        TabUpdateRequestModel(
                                                            tabId: tab.id,
                                                            name: tabName,
                                                            strapsNum:
                                                                selectedStraps
                                                                    .round(),
                                                            color:
                                                                '#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}'))));
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: colors[0],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    LocaleKeys.boards_save.tr(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                ])))));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardBloc, BoardState>(
      listener: (context, state) {
        if (state is PlayTtsSuccess) {
          setState(() {
            isTTSLoading = false;
          });
          _playBytesAsAudio(state.tts);
        } else if (state is PlayTtsLoading) {
          setState(() {
            isTTSLoading = true;
          });
        } else if (state is PlayTtsError) {
          setState(() {
            isTTSLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error playing audio: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocConsumer<BoardBloc, BoardState>(
        builder: (context, state) {
          if (state is BoardDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardDetailsError) {
            return const Center(child: Text("Ошибка загрузки доски"));
          } else if (state is BoardDetailsLoaded ||
              state is PlayTtsLoading ||
              state is PlayTtsSuccess ||
              state is PlayTtsError) {
            final BoardDetailsModel? boardDetails = state.maybeWhen(
              boardDetailsLoaded: (boardDetails) => boardDetails,
              playTtsLoading: (boardDetails) => boardDetails,
              playTtsSuccess: (boardDetails, _) => boardDetails,
              playTtsError: (boardDetails, _) => boardDetails,
              orElse: () => null,
            );
            if (boardDetails == null) {
              return const Center(child: Text("Ошибка загрузки доски"));
            }
            final board = boardDetails.board;
            final validTabId = curTabId < board.tabs.length ? curTabId : 0;
            final channel = WebSocketChannel.connect(
              Uri.parse(
                  'wss://api.hrilab.qys.kz/ws/tabs/${widget.boardId}/${board.tabs[validTabId].id}/?locale=en'),
            );
            return StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  String? jsonString;
                  if (snapshot.data is String) {
                    jsonString = snapshot.data as String;
                  } else {
                    jsonString = snapshot.data.toString();
                  }
                  if (!jsonString.trim().startsWith('{') &&
                      !jsonString.trim().startsWith('[')) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  tabDetails = boardsTabsResponseModelFromJson(jsonString);
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 8,
                                child: DragTarget<MapEntry<int, bool>>(
                                    onWillAccept: (data) {
                                  if (data?.value == true) {
                                    isOverDeleteZone.value = true;
                                  }
                                  return true;
                                }, onLeave: (data) {
                                  isOverDeleteZone.value = false;
                                }, onAccept: (data) {
                                  isOverDeleteZone.value = false;
                                  if (data.value == true) {
                                    setState(() {
                                      _alternativeContainerItems
                                          .removeAt(data.key);
                                    });
                                  }
                                }, builder:
                                        (context, candidateData, rejectedData) {
                                  return Column(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(hexColor(
                                                board.tabs[curTabId].color)),
                                          ),
                                          child: Stack(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ...List.generate(
                                                    board.tabs[curTabId]
                                                        .strapsNum,
                                                    (index) => _buildDragTarget(
                                                        index,
                                                        tabDetails,
                                                        board.tabs[curTabId].id,
                                                        lightenColor(
                                                            Color(hexColor(board
                                                                .tabs[curTabId]
                                                                .color)),
                                                            0.5))),
                                              ],
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 60.r,
                                                    height: 60.r,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                          _dragImages
                                                              ? Icons.lock
                                                              : Icons.lock_open,
                                                          color: Colors.white,
                                                          size: 40.r),
                                                      onPressed: () {
                                                        setState(() {
                                                          _dragImages =
                                                              !_dragImages;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  10.horizontalSpace,
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0).r,
                                                      child: Container(
                                                        width: 60.r,
                                                        height: 60.r,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.2),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            size: 40.r,
                                                          ),
                                                          color: Colors.white,
                                                          onPressed: () async {
                                                            bool? confirm =
                                                                await showDialog<
                                                                    bool>(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                title: Text(
                                                                    LocaleKeys
                                                                        .boards_confirm_delete
                                                                        .tr()),
                                                                content: Text(
                                                                    LocaleKeys
                                                                        .boards_delete_images
                                                                        .tr()),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(false),
                                                                    // cancel
                                                                    child: Text(
                                                                        LocaleKeys
                                                                            .boards_cancel
                                                                            .tr()),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(true),
                                                                    // confirm
                                                                    child: Text(
                                                                      LocaleKeys
                                                                          .boards_delete
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );

                                                            if (confirm ==
                                                                true) {
                                                              Map<String,
                                                                      dynamic>
                                                                  message = {
                                                                "type":
                                                                    "update_images",
                                                                "image_positions":
                                                                    [],
                                                              };

                                                              String
                                                                  jsonMessage =
                                                                  jsonEncode(
                                                                message,
                                                                toEncodable:
                                                                    (nonEncodable) {
                                                                  if (nonEncodable
                                                                      is Set) {
                                                                    return nonEncodable
                                                                        .toList();
                                                                  }
                                                                  throw UnsupportedError(
                                                                      'Cannot encode object of type ${nonEncodable.runtimeType}');
                                                                },
                                                              );

                                                              channel.sink.add(
                                                                  jsonMessage);
                                                            }
                                                          },
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ...board.tabs
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                int index = entry.key;
                                                final tab = entry.value;
                                                return Row(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              curTabId = index;
                                                            });
                                                          },
                                                          child: Container(
                                                            height: curTabId ==
                                                                    index
                                                                ? 70.h
                                                                : 60.h,
                                                            width: 188.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  hexColor(tab
                                                                      .color)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomRight:
                                                                    Radius.circular(
                                                                            30.0)
                                                                        .r,
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                            30.0)
                                                                        .r,
                                                              ),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        tab.name,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 16.sp),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      if(curTabId == index)
                                                                      10.horizontalSpace,
                                                                      if(curTabId == index)
                                                                      Container(
                                                                        width:
                                                                            30.r,
                                                                        height:
                                                                            30.r,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.3),
                                                                          // Dark circle background
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: Text(
                                                                            tabDetails.images.length
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 16.sp),
                                                                            textAlign: TextAlign.center),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if (curTabId ==
                                                                    index)
                                                                  Positioned(
                                                                    top: 6,
                                                                    right: 6,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        _showEditDialog(
                                                                            context,
                                                                            tab,
                                                                            board);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .edit_outlined,
                                                                        color: Colors
                                                                            .white,
                                                                        size: 30
                                                                            .r,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        if (curTabId != index)
                                                          Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: Container(
                                                              height: 20,
                                                              // Height of the gradient "shadow"
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    // Darker at top
                                                                    Colors
                                                                        .transparent,
                                                                    // Fades to transparent
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    7.horizontalSpace,
                                                  ],
                                                );
                                              }),
                                              Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _showCreateDialog(
                                                          context, board);
                                                    },
                                                    child: Container(
                                                      height: 60.h,
                                                      width: 188.w,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                      30.0)
                                                                  .r,
                                                          bottomLeft:
                                                              Radius.circular(
                                                                      30.0)
                                                                  .r,
                                                        ),
                                                      ),
                                                      child: Center(
                                                          child: Icon(Icons.add,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 20,
                                                      // Height of the gradient "shadow"
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.25),
                                                            // Darker at top
                                                            Colors.transparent,
                                                            // Fades to transparent
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                    child: _dragImages
                                        ? _buildAlternativeContainer(
                                            tabDetails, board)
                                        : DragTarget<int>(onWillAccept: (data) {
                                            isOverDeleteZone.value = true;
                                            return true;
                                          }, onLeave: (data) {
                                            isOverDeleteZone.value = false;
                                          }, onAccept: (data) async {
                                            isOverDeleteZone.value = false;

                                            Map<String, dynamic> message = {};
                                            final updatedImages = tabDetails
                                                .images
                                                .where((item) =>
                                                    item.image.id != data)
                                                .toList();
                                            Map<double,
                                                    List<Map<String, dynamic>>>
                                                columns = {};
                                            for (var item in updatedImages) {
                                              columns.putIfAbsent(
                                                  item.positionX, () => []);
                                              columns[item.positionX]!.add({
                                                "image_id": item.image.id,
                                                "position_x": item.positionX,
                                                "position_y": item.positionY,
                                              });
                                            }
                                            List<Map<String, dynamic>>
                                                imagePositions = [];
                                            for (var entry in columns.entries) {
                                              final colX = entry.key;
                                              final imagesInColumn =
                                                  entry.value;
                                              imagesInColumn.sort((a, b) =>
                                                  a["position_y"].compareTo(
                                                      b["position_y"]));
                                              for (int i = 0;
                                                  i < imagesInColumn.length;
                                                  i++) {
                                                imagePositions.add({
                                                  "image_id": imagesInColumn[i]
                                                      ["image_id"],
                                                  "position_x": colX,
                                                  "position_y": i.toDouble(),
                                                });
                                              }
                                            }
                                            imagePositions.sort((a, b) {
                                              int cmpX = a["position_x"]
                                                  .compareTo(b["position_x"]);
                                              return cmpX != 0
                                                  ? cmpX
                                                  : a["position_y"].compareTo(
                                                      b["position_y"]);
                                            });
                                            message = {
                                              "type": "update_images",
                                              "image_positions": imagePositions,
                                            };
                                            String jsonMessage = jsonEncode(
                                                message,
                                                toEncodable: (nonEncodable) {
                                              if (nonEncodable is Set) {
                                                return nonEncodable.toList();
                                              }
                                              throw UnsupportedError(
                                                  'Cannot encode object of type ${nonEncodable.runtimeType}');
                                            });

                                            channel.sink.add(jsonMessage);
                                          }, builder: (context, candidateData,
                                            rejectedData) {
                                            return SizedBox(
                                              child: isImagesVisible
                                                  ? _buildExtendedContainer(
                                                      id: chosenCategoryId,
                                                      name: chosenCategoryName)
                                                  : _buildLibraryContainer(),
                                            );
                                          })),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const SizedBox.shrink();
          }
        },
        listener: (BuildContext context, BoardState state) {
          if (state is CreateTabLoaded ||
              state is UpdateTabLoaded ||
              state is DeleteTabLoaded) {
            setState(() {
              curTabId = 0;
            });
            context
                .read<BoardBloc>()
                .add(GetBoardDetails(id: int.parse(widget.boardId)));
            context.read<LibraryBloc>().add(GetCategoriesGlobal(
                params: {'limit': limit, 'offset': offset}));
          }
        },
      ),
    );
  }

  Widget _buildDragTarget(
      int index, BoardsTabsResponseModel tabDetails, int id, Color color) {
    final images = tabDetails.getImagesByPositionX(index.toDouble());
    final locale = context.locale.toString();
    return Builder(builder: (context) {
      return Expanded(
          flex: 1,
          child: Stack(alignment: Alignment.center, children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10).r,
                  color: color,
                ),
                width: 10.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.w),
              child: Column(
                children: [
                  ...List.generate(
                    4,
                    (rowIndex) {
                      return Expanded(
                        child: DragTarget<int>(
                            onAcceptWithDetails: (details) async {
                          Map<String, dynamic> message = {};
                          ImageElement? draggedImage;
                          try {
                            draggedImage = tabDetails.images.firstWhere(
                              (item) => item.image.id == details.data,
                            );
                          } catch (e) {
                            draggedImage = null;
                          }
                          bool isDraggingFromSameColumn = false;
                          if (draggedImage != null) {
                            isDraggingFromSameColumn =
                                draggedImage.positionX == index.toDouble();
                          }
                          if (images.length == 4 && !isDraggingFromSameColumn) {
                            return;
                          }
                          List updatedImages = List.from(tabDetails.images)
                              .where((item) => item.image.id != details.data)
                              .toList();
                          Map<double, List<Map<String, dynamic>>> columns = {};
                          for (var item in updatedImages) {
                            columns.putIfAbsent(item.positionX, () => []);
                            columns[item.positionX]!.add({
                              "image_id": item.image.id,
                              "position_x": item.positionX,
                              "position_y": item.positionY,
                            });
                          }
                          double targetColumn = index.toDouble();
                          columns.putIfAbsent(targetColumn, () => []);
                          List<Map<String, dynamic>> targetItems =
                              columns[targetColumn]!;
                          targetItems.sort((a, b) =>
                              a["position_y"].compareTo(b["position_y"]));
                          int insertIndex =
                              rowIndex.clamp(0, targetItems.length);
                          targetItems.insert(insertIndex, {
                            "image_id": details.data,
                            "position_x": targetColumn,
                            "position_y": 0,
                          });
                          List<Map<String, dynamic>> imagePositions = [];
                          for (var entry in columns.entries) {
                            double colX = entry.key;
                            List<Map<String, dynamic>> colImages = entry.value;

                            for (int i = 0; i < colImages.length; i++) {
                              imagePositions.add({
                                "image_id": colImages[i]["image_id"],
                                "position_x": colX,
                                "position_y": i.toDouble(),
                              });
                            }
                          }
                          imagePositions.sort((a, b) {
                            int cmpX =
                                a["position_x"].compareTo(b["position_x"]);
                            return cmpX != 0
                                ? cmpX
                                : a["position_y"].compareTo(b["position_y"]);
                          });
                          message = {
                            "type": "update_images",
                            "image_positions": imagePositions,
                          };
                          String jsonMessage =
                              jsonEncode(message, toEncodable: (nonEncodable) {
                            if (nonEncodable is Set) {
                              return nonEncodable.toList();
                            }
                            throw UnsupportedError(
                                'Cannot encode object of type ${nonEncodable.runtimeType}');
                          });
                          WebSocket socket = await WebSocket.connect(
                              'wss://api.hrilab.qys.kz/ws/tabs/${widget.boardId}/$id/?locale=en');
                          socket.add(jsonMessage);
                        }, builder: (context, candidateData, rejectedData) {
                          return Center(
                              child: images.length >= rowIndex + 1 &&
                                      images[rowIndex].positionY ==
                                          rowIndex.toDouble()
                                  ? _dragImages
                                      ? Draggable<MapEntry<int, bool>>(
                                          maxSimultaneousDrags: 1,
                                          data: MapEntry(
                                              images[rowIndex].image.id, false),
                                          feedback: FolderWidget(
                                            labelText: images[rowIndex]
                                                .image
                                                .getLocalizedLabel(locale),
                                            imageUrl:
                                                images[rowIndex].image.imageUrl,
                                          ),
                                          child: FolderWidget(
                                              labelText: images[rowIndex]
                                                  .image
                                                  .getLocalizedLabel(locale),
                                              imageUrl: images[rowIndex]
                                                  .image
                                                  .imageUrl),
                                        )
                                      : Draggable<int>(
                                          maxSimultaneousDrags: 1,
                                          data: images[rowIndex].image.id,
                                          onDragEnd: (details) {
                                            if (!details.wasAccepted) {}
                                          },
                                          feedback: FolderWidget(
                                            labelText: images[rowIndex]
                                                .image
                                                .getLocalizedLabel(locale),
                                            imageUrl:
                                                images[rowIndex].image.imageUrl,
                                            isOverDeleteZone: isOverDeleteZone,
                                          ),
                                          child: FolderWidget(
                                            labelText: images[rowIndex]
                                                .image
                                                .getLocalizedLabel(locale),
                                            imageUrl:
                                                images[rowIndex].image.imageUrl,
                                          ),
                                        )
                                  : SizedBox());
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ]));
    });
  }

  Widget _buildImageGrid() {
    if (images.isEmpty && !isLoadingMoreImage) {
      return Center(
        child: Text(
          'No results found',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    final localeCode = context.locale.languageCode;

    return GridView.builder(
      controller: _scrollImageController,
      padding: EdgeInsets.all(5).r,
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: images.length + (isLoadingMoreImage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == images.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return Draggable<int>(
          maxSimultaneousDrags: 1,
          data: images[index].id,
          feedback: FolderWidget(
            labelText: images[index].getLocalizedName(localeCode),
            imageUrl: images[index].imageUrl,
          ),
          child: FolderWidget(
              labelText: images[index].getLocalizedName(localeCode),
              imageUrl: images[index].imageUrl!),
        );
      },
    );
  }

  Widget _buildExtendedContainer({required int id, required String name}) {
    return Column(children: [
      Expanded(
        flex: 3,
        child: Container(
          color: Color(0xFFFF9E00),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              10.horizontalSpace,
              GestureDetector(
                onTap: () {
                  images = [];
                  onCategoryTap(0, '');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_sharp,
                      color: Colors.white,
                      size: 20.r,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Row(
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: '${LocaleKeys.boards_search.tr()}...',
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10).r,
                            borderSide: BorderSide.none,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('.')), // Разрешить любые буквы
                        ],
                        textAlign: TextAlign.end,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
                          _searchDebounce = Timer(Duration(milliseconds: 400), () {
                            setState(() {
                              searchQuery = value;
                              imageOffset = 0;
                              images = [];
                              hasMoreImage = true;
                              isLoadingMoreImage = false;
                            });
                            context.read<LibraryBloc>().add(
                              GetCategoryImagesById(
                                id: chosenCategoryId,
                                params: {
                                  'limit': imageLimit,
                                  'offset': 0,
                                  if (value.isNotEmpty) 'search': value,
                                },
                              ),
                            );
                          });
                        },
                      )
                    ),
                    if (searchQuery.isNotEmpty) 10.horizontalSpace,
                    if (searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            searchQuery = '';
                            imageOffset = 0;
                            images = [];
                            searchController.clear();
                            hasMoreImage = true;
                            isLoadingMoreImage = false;
                          });
                          context.read<LibraryBloc>().add(
                                GetCategoryImagesById(
                                  id: chosenCategoryId,
                                  params: {
                                    'limit': imageLimit,
                                    'offset': 0,
                                  },
                                ),
                              );
                        },
                        child: Container(
                            height: 40.r,
                            width: 40.r,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.r)),
                            child:
                                const Icon(Icons.clear, color: Colors.white)),
                      ),
                  ],
                ),
              ),
              10.horizontalSpace,
            ],
          ),
        ),
      ),
      Expanded(
        flex: 7,
        child: Container(
          color: Color(0xFFFFD8A2),
          child:
              BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
            if (state is CategoryImagesLoading && images.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            if (state is CategoryImagesLoading && images.isNotEmpty) {
              isLoadingMoreImage = true;
              return _buildImageGrid();
            } else if (state is CategoryImagesLoaded) {
              if (imageOffset == 0) {
                images = state.images!;
              } else {
                images = [...images, ...state.images!];
              }

              isLoadingMoreImage = false;
              if (state.images!.isEmpty) {
                hasMoreImage = false;
              }
              return _buildImageGrid();
            } else if (state is CategoryImagesError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Offstage(
              child: Text('I am offstage'),
            );
          }),
        ),
      )
    ]);
  }

  Widget _buildGrid() {
    if (categories!.isEmpty && !isLoadingMore) {
      return Center(
        child: Text(
          'No results found',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(5).r,
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: categories!.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == categories!.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = categories![index];
        return item.type == "category"
            ? GestureDetector(
                onTap: () {
                  onCategoryTap(item.id, item.getLocalizedName(context));
                  searchQuery = '';
                  searchController.clear();
                },
                child: CategoryWidget(
                  labelText: item.getLocalizedName(context),
                  imageUrl: item.imageUrl,
                ),
              )
            : Draggable<int>(
                maxSimultaneousDrags: 1,
                data: item.id,
                feedback: FolderWidget(
                  labelText: item.getLocalizedName(context),
                  imageUrl: item.imageUrl,
                ),
                child: FolderWidget(
                  labelText: item.getLocalizedName(context),
                  imageUrl: item.imageUrl,
                ),
              );
      },
    );
  }

  Widget _buildLibraryContainer() {
    return Column(children: [
      Expanded(
        flex: 3,
        child: Container(
          color: Color(0xFFFF9E00),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              10.horizontalSpace,
              Text(
                LocaleKeys.boards_library.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Row(
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: '${LocaleKeys.boards_search.tr()}...',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10).r,
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textAlign: TextAlign.end,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          if (_searchDebounce?.isActive ?? false)
                            _searchDebounce?.cancel();
                          _searchDebounce =
                              Timer(Duration(milliseconds: 400), () {
                            setState(() {
                              searchQuery = value;
                              offset = 0;
                              categories = [];
                              hasMoreData = true;
                              isLoadingMore = false;
                            });

                            context.read<LibraryBloc>().add(
                                  GetCategoriesGlobal(
                                    params: {
                                      'limit': limit,
                                      'offset': 0,
                                      if (value.isNotEmpty) 'search': value,
                                    },
                                  ),
                                );
                          });
                        },
                      ),
                    ),
                    if (searchQuery.isNotEmpty) 10.horizontalSpace,
                    if (searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            searchQuery = '';
                            imageOffset = 0;
                            images = [];
                            searchController.clear();
                            hasMoreData = true;
                            isLoadingMore = false;
                          });
                          context.read<LibraryBloc>().add(
                                GetCategoriesGlobal(
                                  params: {
                                    'limit': limit,
                                    'offset': 0,
                                  },
                                ),
                              );
                        },
                        child: Container(
                            height: 40.r,
                            width: 40.r,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.r)),
                            child:
                                const Icon(Icons.clear, color: Colors.white)),
                      ),
                  ],
                ),
              ),
              10.horizontalSpace,
            ],
          ),
        ),
      ),
      Expanded(
          flex: 7,
          child: Container(
            color: Color(0xFFFFD8A2),
            child: BlocBuilder<LibraryBloc, LibraryState>(
                builder: (context, state) {
              if (state is CategoriesGlobalLoading && categories!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }
              if (state is CategoriesGlobalLoading && categories!.isNotEmpty) {
                isLoadingMore = true;
                return _buildGrid();
              } else if (state is CategoriesGlobalLoaded) {
                if (offset == 0) {
                  categories = state.category!.items;
                } else {
                  categories!.addAll(state.category!.items);
                }

                isLoadingMore = false;
                if (state.category!.items.isEmpty) {
                  hasMoreData = false;
                }
                return _buildGrid();
              } else if (state is CategoriesGlobalError) {
                return Center(
                  child: Text(state.message),
                );
              }
              return const Offstage(
                child: Text('I am offstage'),
              );
            }),
          ))
    ]);
  }

  Widget _buildAlternativeContainer(
      BoardsTabsResponseModel tabDetails, Board board) {
    final locale = context.locale.toString();
    return Row(
      children: [
        Expanded(
          flex: 14,
          child: DragTarget<MapEntry<int, bool>>(
            onAcceptWithDetails: (details) {
              setState(() {
                if (details.data.value) {
                  final changedItem =
                      _alternativeContainerItems.removeAt(details.data.key);
                  _alternativeContainerItems.add(changedItem);
                } else {
                  for (var item in tabDetails.images) {
                    if (item.image.id == details.data.key) {
                      _alternativeContainerItems.add(item);
                    }
                  }
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                color: Color(0xFFF9B641),
                child: Stack(children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10).r,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10).r,
                          color: lightenColor(Color(0xFFF9B641), 0.5),
                        ),
                        height: 10.h,
                      ),
                    ),
                  ),
                  GridView.builder(
                      padding: EdgeInsets.all(5).r,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 1,
                      ),
                      itemCount: _alternativeContainerItems.length,
                      itemBuilder: (context, index) {
                        return DragTarget<MapEntry<int, bool>>(
                            onAcceptWithDetails: (details) {
                          setState(() {
                            if (details.data.value) {
                              final changeItem = _alternativeContainerItems
                                  .removeAt(details.data.key);
                              if (index <= _alternativeContainerItems.length) {
                                _alternativeContainerItems.insert(
                                    index, changeItem);
                              } else {
                                _alternativeContainerItems.add(changeItem);
                              }
                            } else {
                              for (var item in tabDetails.images) {
                                if (item.image.id == details.data.key) {
                                  if (index >=
                                      _alternativeContainerItems.length) {
                                    _alternativeContainerItems.add(item);
                                    break;
                                  } else {
                                    _alternativeContainerItems.insert(
                                        index, item);
                                    break;
                                  }
                                }
                              }
                            }
                          });
                        }, builder: (context, candidateData, rejectedData) {
                          return Transform.scale(
                            scaleX: index > _alternativeContainerItems.length
                                ? 5.0
                                : 1.0,
                            child: Container(
                                color: Colors.transparent,
                                child: index < _alternativeContainerItems.length
                                    ? Draggable<MapEntry<int, bool>>(
                                        data: MapEntry(index, true),
                                        feedback: FolderWidget(
                                          labelText:
                                              _alternativeContainerItems[index]
                                                  .image
                                                  .getLocalizedLabel(locale),
                                          imageUrl:
                                              _alternativeContainerItems[index]
                                                  .image
                                                  .imageUrl,
                                          isOverDeleteZone: isOverDeleteZone,
                                        ),
                                        child: FolderWidget(
                                          labelText:
                                              _alternativeContainerItems[index]
                                                  .image
                                                  .getLocalizedLabel(locale),
                                          imageUrl:
                                              _alternativeContainerItems[index]
                                                  .image
                                                  .imageUrl,
                                        ),
                                      )
                                    : SizedBox()),
                          );
                        });
                      }),
                ]),
              );
            },
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              color: Color(0xFFF9B641),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 60.r,
                      height: 60.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: isTTSLoading
                          ? IconButton(
                              icon: SizedBox(
                                width: 40.r,
                                height: 40.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5.w,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              onPressed: () {},
                            )
                          : IconButton(
                              icon: Icon(Icons.play_arrow,
                                  color: Colors.white, size: 40.r),
                              onPressed: () {
                                setState(() {
                                  final imageIds = _alternativeContainerItems
                                      .map((item) => item.image.id)
                                      .toList();
                                  context.read<BoardBloc>().add(
                                      BoardEvent.playTts(
                                          tts: TtsPlayRequestModel(
                                              imageIds: imageIds,
                                              voiceLanguage:
                                                  context.locale.languageCode,
                                              boardID: board.id)));
                                });
                              },
                            )),
                  Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: Colors.white, size: 40.r),
                      onPressed: () {
                        setState(() {
                          _alternativeContainerItems.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
