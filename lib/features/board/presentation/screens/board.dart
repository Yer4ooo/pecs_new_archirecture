import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pecs_new_arch/features/board/data/models/board_tabs_response_model.dart';
import 'package:pecs_new_arch/features/board/presentation/widgets/bottom_board.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/board/data/models/board_details_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tts_play_request_model.dart';
import 'package:pecs_new_arch/features/board/presentation/bloc/board_bloc.dart';
import 'package:pecs_new_arch/injection_container.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BoardScreen extends StatefulWidget {
  final String boardId;

  const BoardScreen({required this.boardId, super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  int chosenCategoryId = 0;
  String chosenCategoryName = '';
  bool isImagesVisible = false;
  int curTabId = 0;
  late final List<ImageElement> _alternativeContainerItems = [];
  bool _dragImages = false;
  bool isTTSLoading = false;
  late int offset = 0;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int categoriesCount = 0;
  late List<CategoryItem>? categories = [];

  void onCategoryTap(int? id, String? name) {
    setState(() {
      isImagesVisible = !isImagesVisible;
      chosenCategoryId = id!;
      chosenCategoryName = name!;
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
        offset += 20;
      });
      if (offset + 20 < categoriesCount) {
        context
            .read<LibraryBloc>()
            .add(GetCategories(params: {'limit': 20, 'offset': offset}));
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    context
        .read<BoardBloc>()
        .add(GetBoardDetails(id: int.parse(widget.boardId)));
    context
        .read<LibraryBloc>()
        .add(GetCategories(params: {'limit': 20, 'offset': 0}));
  }

  @override
  void dispose() {
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
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LibraryBloc>.value(
          value: context.read<LibraryBloc>(),
        ),
        BlocProvider<BoardBloc>.value(
          value: context.read<BoardBloc>(),
        ),
      ],
      child: BlocListener<BoardBloc, BoardState>(
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
        child: BlocBuilder<BoardBloc, BoardState>(
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
                    BoardsTabsResponseModel tabDetails =
                        boardsTabsResponseModelFromJson(jsonString);
                    return Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: Column(children: [
                          Expanded(
                              flex: 8,
                              child: DragTarget<MapEntry<int, bool>>(
                                  onAcceptWithDetails: (details) {
                                setState(() {
                                  if (details.data.value) {
                                    _alternativeContainerItems
                                        .removeAt(details.data.key);
                                  }
                                });
                              }, builder:
                                      (context, candidateData, rejectedData) {
                                return Column(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                          color: Color(hexColor(
                                              board.tabs[curTabId].color)),
                                          child: Stack(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ...List.generate(
                                                      board.tabs[curTabId]
                                                          .strapsNum,
                                                      (index) => _buildDragTarget(
                                                          index,
                                                          tabDetails,
                                                          board.tabs[curTabId]
                                                              .id,
                                                          lightenColor(
                                                              Color(hexColor(board
                                                                  .tabs[
                                                                      curTabId]
                                                                  .color)),
                                                              0.5))),
                                                ],
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                            _dragImages
                                                                ? Icons.lock
                                                                : Icons
                                                                    .lock_open,
                                                            color: Colors.white,
                                                            size: 30),
                                                        onPressed: () {
                                                          setState(() {
                                                            _dragImages =
                                                                !_dragImages;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .delete_outline_outlined,
                                                          size: 30,
                                                        ),
                                                        color: Colors.white,
                                                        onPressed: () async {
                                                          Map<String, dynamic>
                                                              message = {
                                                            "type":
                                                                "update_images",
                                                            "image_positions":
                                                                []
                                                          };
                                                          String jsonMessage =
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
                                                          });
                                                          channel.sink
                                                              .add(jsonMessage);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          ...board.tabs
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            final tab = entry.value;
                                            return Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    curTabId = index;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                    color: Color(
                                                        hexColor(tab.color)),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(16.0),
                                                      bottomLeft:
                                                          Radius.circular(16.0),
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Text(
                                                        tab.name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .mode_edit_outline_outlined,
                                                              size: 20,
                                                            ),
                                                            color: Colors.white,
                                                            onPressed: () {
                                                              setState(() {});
                                                            },
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 50,
                                              width: 180,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(16.0),
                                                  bottomLeft:
                                                      Radius.circular(16.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (_) =>
                                                    //           CreateTabScreen(
                                                    //               boardId: widget
                                                    //                   .boardId)),
                                                    // );
                                                  },
                                                  icon: const Icon(Icons.add,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              })),
                          Expanded(
                              flex: 3,
                              child: _dragImages
                                  ? _buildAlternativeContainer(tabDetails)
                                  : DragTarget<int>(onAcceptWithDetails:
                                      (details) async {
                                      Map<String, dynamic> message = {};

                                      message = {
                                        "type": "update_images",
                                        "image_positions": [
                                          ...tabDetails.images
                                              .where((item) =>
                                                  item.image.id != details.data)
                                              .map((item) => {
                                                    "image_id": item.image.id,
                                                    "position_x":
                                                        item.positionX,
                                                    "position_y":
                                                        item.positionY,
                                                  }),
                                        ]
                                      };
                                      String jsonMessage = jsonEncode(message,
                                          toEncodable: (nonEncodable) {
                                        if (nonEncodable is Set) {
                                          return nonEncodable.toList();
                                        }
                                        throw UnsupportedError(
                                            'Cannot encode object of type ${nonEncodable.runtimeType}');
                                      });
                                      channel.sink.add(jsonMessage);
                                    }, builder:
                                      (context, candidateData, rejectedData) {
                                      return SizedBox(
                                        child: isImagesVisible
                                            ? _buildExtendedContainer(
                                                id: chosenCategoryId,
                                                name: chosenCategoryName)
                                            : _buildLibraryContainer(),
                                      );
                                    })),
                        ]));
                  });
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
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
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => onCategoryTap(0, ''),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_sharp,
                      color: Colors.white,
                      size: 15,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40,
                  width: 150,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textAlign: TextAlign.end,
                    textAlignVertical: TextAlignVertical.bottom,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              if (searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      searchQuery = '';
                      searchController.clear();
                    });
                  },
                  child: const Icon(Icons.clear, color: Colors.grey),
                ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      Expanded(
          flex: 8,
          child: Container(
            color: Color(0xFFFFD8A2),
            child: BlocProvider(
              create: (context) =>
                  sl<LibraryBloc>()..add(GetCategoryImagesById(id: id)),
              child: BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                if (state is CategoryImagesLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                } else if (state is CategoryImagesLoaded) {
                  List<CategoriesImagesListModel>? filteredImages =
                      state.images?.where((image) {
                    if (searchQuery.isNotEmpty &&
                        !(image.name
                                ?.toLowerCase()
                                .contains(searchQuery.toLowerCase()) ??
                            false)) {
                      return false;
                    }
                    return true;
                  }).toList();
                  return GridView.builder(
                    padding: const EdgeInsets.all(5),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: filteredImages?.length,
                    itemBuilder: (context, index) {
                      if (filteredImages?[index].name != null &&
                          filteredImages?[index].imageUrl != null) {
                        return Draggable<int>(
                          maxSimultaneousDrags: 1,
                          data: filteredImages![index].id,
                          feedback: FolderWidget(
                            labelText: filteredImages[index].name,
                            imageUrl: filteredImages[index].imageUrl,
                          ),
                          child: FolderWidget(
                              labelText: filteredImages[index].name!,
                              imageUrl: filteredImages[index].imageUrl!),
                        );
                      }
                      return null;
                    },
                  );
                } else if (state is CategoriesError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return const Offstage(
                  child: Text('I am offstage'),
                );
              }),
            ),
          ))
    ]);
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
              SizedBox(
                width: 10,
              ),
              Text(
                'Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textAlign: TextAlign.end,
                    textAlignVertical: TextAlignVertical.bottom,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              if (searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      searchQuery = '';
                      searchController.clear();
                    });
                  },
                  child: const Icon(Icons.clear, color: Colors.white),
                ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      Expanded(
          flex: 8,
          child: Container(
            color: Color(0xFFFFD8A2),
            child: BlocBuilder<LibraryBloc, LibraryState>(
                builder: (context, state) {
              if (state is CategoriesLoading && categories!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              } else if (state is CategoriesLoading && categories!.isNotEmpty) {
                return GridView.builder(
                  key: const PageStorageKey('categoriesGrid'),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: categories!.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == categories!.length) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        onCategoryTap(
                            categories![index].id, categories![index].name);
                        searchQuery = '';
                        searchController.clear();
                      },
                      child: CategoryWidget(
                        labelText: categories![index].name,
                        imageUrl: categories![index].imageUrl,
                      ),
                    );
                  },
                );
              } else if (state is CategoriesLoaded) {
                if (categoriesCount == 0) {
                  categoriesCount = state.categories!.count;
                }
                if (categories!.isEmpty) {
                  categories = state.categories!.items;
                } else if (offset + 20 < categoriesCount) {
                  categories = [...?categories, ...?state.categories?.items];
                }
                return GridView.builder(
                  key: const PageStorageKey('categoriesGrid'),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: categories!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        onCategoryTap(
                            categories![index].id, categories![index].name);
                        searchQuery = '';
                        searchController.clear();
                      },
                      child: CategoryWidget(
                        labelText: categories![index].name,
                        imageUrl: categories![index].imageUrl,
                      ),
                    );
                  },
                );
              } else if (state is CategoriesError) {
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

  Widget _buildAlternativeContainer(BoardsTabsResponseModel tabDetails) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightenColor(Color(0xFFF9B641), 0.5),
                        ),
                        height: 10,
                      ),
                    ),
                  ),
                  GridView.builder(
                      padding: const EdgeInsets.all(5),
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
                                        maxSimultaneousDrags: 1,
                                        data: MapEntry(index, true),
                                        feedback: FolderWidget(
                                          labelText:
                                              _alternativeContainerItems[index]
                                                  .image
                                                  .name,
                                          imageUrl:
                                              _alternativeContainerItems[index]
                                                  .image
                                                  .imageUrl,
                                        ),
                                        child: FolderWidget(
                                          labelText:
                                              _alternativeContainerItems[index]
                                                  .image
                                                  .name,
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: isTTSLoading
                          ? IconButton(
                              icon: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              onPressed: () {},
                            )
                          : IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 30),
                              onPressed: () {
                                setState(() {
                                  final imageIds = _alternativeContainerItems
                                      .map((item) => item.image.id)
                                      .toList();
                                  context.read<BoardBloc>().add(
                                      BoardEvent.playTts(
                                          tts: TtsPlayRequestModel(
                                              imageIds: imageIds,
                                              voiceLanguage: 'en')));
                                });
                              },
                            )),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 30),
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

  Widget _buildDragTarget(
      int index, BoardsTabsResponseModel tabDetails, int id, Color color) {
    return Builder(builder: (context) {
      return Expanded(
        flex: 1,
        child: DragTarget<int>(
          onAcceptWithDetails: (details) async {
            if (!_dragImages) {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final localPosition = renderBox.globalToLocal(details.offset);
              final Size containerSize = renderBox.size;

              final double relativeX = localPosition.dx / containerSize.width;
              final double relativeY = localPosition.dy / containerSize.height;
              if (relativeX >= 0.0 &&
                  relativeX <= 1.0 &&
                  relativeY >= 0.0 &&
                  relativeY <= 1.0) {
                Map<String, dynamic> message = {};
                if (tabDetails.images.isEmpty) {
                  message = {
                    "type": "update_images",
                    "image_positions": [
                      {
                        "image_id": details.data,
                        "position_x": index.toDouble(),
                        "position_y": relativeY,
                      }
                    ]
                  };
                } else {
                  message = {
                    "type": "update_images",
                    "image_positions": [
                      ...tabDetails.images
                          .where((item) => item.image.id != details.data)
                          .map((item) => {
                                "image_id": item.image.id,
                                "position_x": item.positionX,
                                "position_y": item.positionY,
                              }),
                      {
                        "image_id": details.data,
                        "position_x": index.toDouble(),
                        "position_y": relativeY,
                      }
                    ]
                  };
                }

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
              }
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 50),
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: color,
                    ),
                    width: 10,
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: tabDetails.images.map((image) {
                        if (image.positionX == index) {
                          double alignmentY = (image.positionY * 2) - 1;
                          return Align(
                              alignment: Alignment(0, alignmentY),
                              child: _dragImages
                                  ? Draggable<MapEntry<int, bool>>(
                                      maxSimultaneousDrags: 1,
                                      data: MapEntry(image.image.id, false),
                                      feedback: FolderWidget(
                                        labelText: image.image.name,
                                        imageUrl: image.image.imageUrl,
                                      ),
                                      child: FolderWidget(
                                          labelText: image.image.name,
                                          imageUrl: image.image.imageUrl),
                                    )
                                  : Draggable<int>(
                                      maxSimultaneousDrags: 1,
                                      data: image.image.id,
                                      feedback: FolderWidget(
                                        labelText: image.image.name,
                                        imageUrl: image.image.imageUrl,
                                      ),
                                      child: FolderWidget(
                                          labelText: image.image.name,
                                          imageUrl: image.image.imageUrl),
                                    ));
                        } else {
                          return const SizedBox.shrink();
                        }
                      }).toList(),
                    ),
                  )
                ]));
          },
        ),
      );
    });
  }
}
