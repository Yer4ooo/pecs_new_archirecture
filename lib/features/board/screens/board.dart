import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pecs_new_arch/features/board/screens/create_tab_screen.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../injection_container.dart';
import '../../home/presentation/screens/widgets/home_top_widget.dart';
import '../../library/data/models/categories_images_list_model.dart';
import '../../library/data/models/categories_list_model.dart';
import '../../library/presentation/bloc/library_bloc.dart';
import '../../tab/logic/models/board_tabs_response_model.dart';
import '../logic/bloc/board_bloc.dart';
import '../widgets/bottom_board.dart';

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
  final List<ImageElement> _alternativeContainerItems = [];
  bool _dragImages = false;
  String name = 'untitled';
  Color color = Color.fromRGBO(97, 148, 81, 1);
  int numOfRows = 5;
  Offset? draggableTopPosition;
  int dropDownValue = 5;
  void onCategoryTap(int id, String? name){
    setState(() {
      isImagesVisible = !isImagesVisible;
      chosenCategoryId = id;
      chosenCategoryName = name!;
    });
  }
  Color lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, "Amount should be between 0 and 1");
    return Color.lerp(color, Colors.white, amount)!;
  }
  @override
  void initState() {
    super.initState();
    context.read<BoardBloc>().add(FetchBoardDetails(boardId: widget.boardId));
  }
  hexColor(String color) {
    String colorNew = '0xFF' + color;
    colorNew = colorNew.replaceAll('#', '');
    int colorInt = int.parse(colorNew);
    return colorInt;
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
          BlocProvider<LibraryBloc>(
            create: (context) => sl<LibraryBloc>()..add(GetCategories()),),
          BlocProvider<BoardBloc>.value(
            value: context.read<BoardBloc>(),),
        ],
        
        child: BlocListener<BoardBloc, BoardState>(listener: (context, state) {
          if (state is TTSPlaySuccess) {
            _playBytesAsAudio(state.text);
          }
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                BlocBuilder<BoardBloc, BoardState>(
                  builder: (context, state) {
                    if (state is BoardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BoardDetailsFailure) {
                      return const Center(child: Text("Ошибка загрузки доски"));
                    } else if (state is BoardDetailsSuccess) {
                      final board = state.boardDetails.board;
                      final validTabId = curTabId < board.tabs.length ? curTabId : 0;
                      final channel = WebSocketChannel.connect(Uri.parse('wss://api.pecs.qys.kz/ws/tabs/${widget.boardId}/${board.tabs[validTabId].id}/?locale=en'),);
                      return Expanded(
                          child : StreamBuilder(
                            stream: channel.stream,
                            builder: (context, snapshot) {
                              String? jsonString;
                              if (snapshot.data is String) {
                                jsonString = snapshot.data as String;
                              } else {
                                jsonString = snapshot.data.toString();
                              }
                              if (!jsonString.trim().startsWith('{') && !jsonString.trim().startsWith('[')) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              BoardsTabsResponseModel tabDetails = boardsTabsResponseModelFromJson(jsonString);
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: 400,
                                  color: Color(hexColor(
                                      board.tabs[curTabId].color)),
                                  child: Stack(
                                    children: [Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          ...List.generate(
                                              board.tabs[curTabId].strapsNum, (
                                              index) =>
                                              _buildDragTarget(
                                                  index, tabDetails, board.tabs[curTabId].id, lightenColor(Color(hexColor(board.tabs[curTabId].color)), 0.5))),
                                        ], 
                                    ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                    _dragImages ? Icons.lock : Icons
                                                        .lock_open,
                                                    color: Colors.white, size: 30),
                                                onPressed: () {
                                                  setState(() {
                                                    _dragImages = !_dragImages;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.delete_outline_outlined, size: 30,),
                                                color: Colors.white,
                                                onPressed: () async {
                                                    Map<String,
                                                        dynamic> message = {
                                                      "type": "update_images",
                                                      "image_positions": []
                                                    };
                                                    String jsonMessage = jsonEncode(
                                                        message, toEncodable: (
                                                        nonEncodable) {
                                                      if (nonEncodable is Set) {
                                                        return nonEncodable
                                                            .toList();
                                                      }
                                                      throw UnsupportedError(
                                                          'Cannot encode object of type ${nonEncodable
                                                              .runtimeType}');
                                                    });
                                                    WebSocket socket = await WebSocket
                                                        .connect(
                                                        'wss://api.pecs.qys.kz/ws/tabs/${widget
                                                            .boardId}/${board
                                                            .tabs[validTabId]
                                                            .id}/?locale=en');
                                                    socket.add(jsonMessage);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),),

                                    ],)
                              ),
                              Row(children: [
                                ...board.tabs
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  final tab = entry.value;
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        curTabId = index;
                                      });
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Color(hexColor(tab.color)),
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(16.0),
                                            bottomLeft: Radius.circular(16.0),
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
                                                  textAlign: TextAlign.center,
                                                ),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    icon: Icon(Icons.mode_edit_outline_outlined, size: 20,),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      setState(() {
                                                      });
                                                    },
                                                  ))
                                            ],
                                          ),
                                        ),
                                  );
                                }),
                                Container(
                                  height: 50,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(16.0),
                                      bottomLeft: Radius.circular(16.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => CreateTabScreen(boardId: widget.boardId)),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.add, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                              ),
                              SizedBox(height: 10,),
                              Expanded(child: _dragImages
                                  ? _buildAlternativeContainer(tabDetails)
                                  : isImagesVisible
                                  ? _buildExtendedContainer(
                                  id: chosenCategoryId, name: chosenCategoryName)
                                  : _buildLibraryContainer(),),
                            ]
                        );
                      }));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
  Widget _buildExtendedContainer({required int id, required String name}){
    return BlocProvider(
      create: (context) => sl<LibraryBloc>()..add(GetCategoryImagesById(id: id)),
      child: BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        } else if (state is CategoryImagesLoaded) {
          List<CateoriesImagesListModel>? filteredImages = state.images?.where((image) {
            if (searchQuery.isNotEmpty &&
                !(image.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)) {
              return false;
            }
            return true;
          }).toList();
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.red[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () => onCategoryTap(0, ''),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios_sharp, color: Colors.white,),
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
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            filled: true,
                            fillColor: Colors.red[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
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
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  color: Colors.deepOrange,
                  child: GridView.builder(
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
                      if(filteredImages?[index].name != null && filteredImages?[index].imageUrl != null){
                        return Draggable<int>(
                          data: filteredImages![index].id,
                          feedback: SizedBox(
                              height: 150,
                              width: 150,
                              child: FolderWidget(
                                  labelText: filteredImages[index].name!,
                                  imageUrl: filteredImages[index].imageUrl!),
                            ),
                          child: FolderWidget(
                              labelText: filteredImages[index].name!,
                              imageUrl: filteredImages[index].imageUrl!),
                        );
                      }
                      return null;},
                  ),
                ),
              ),
            ],
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
    );
  }
  Widget _buildLibraryContainer() {
    return BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
      if (state is CategoriesLoading) {
        return Column(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      } else if (state is CategoriesLoaded) {
        final List<CateoriesListModel>? filteredCategories = searchQuery.isEmpty
            ? state.categories
            : state.categories
            ?.where((category) => (category.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        return Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.red[700],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      'Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          filled: true,
                          fillColor: Colors.red[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
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
                    SizedBox(width: 10,),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                color: Colors.deepOrange,
                child: GridView.builder(
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: filteredCategories?.length,
                  itemBuilder: (context, index) {
                    if(filteredCategories?[index].name != null && filteredCategories?[index].imageUrl != null){
                      return GestureDetector(
                        onTap: () {
                          onCategoryTap(filteredCategories?[index].id ??
                              -1, filteredCategories![index].name);
                          searchQuery = '';
                          searchController.clear();},
                        child: FolderWidget(
                          labelText: filteredCategories?[index].name!,
                          imageUrl: filteredCategories?[index].imageUrl!,
                        ),
                      );
                    }
                    return null;},
                ),
              ),
            ),
          ],
        );
      }
      else if (state is CategoriesError) {
        return Center(
          child: Text(state.message),
        );
      }
      return const Offstage(
        child: Text('I am offstage'),
      );
    }
    );
  }
  Widget _buildAlternativeContainer(BoardsTabsResponseModel tabDetails) {
    return Row(
        children: [
          Expanded(
            flex: 14,
            child: DragTarget<int>(
                onAcceptWithDetails: (details){
                  setState(() {
                    for (var item in tabDetails.images) {
                      if (item.image.id == details.data) {
                        _alternativeContainerItems.add(item);
                        break;
                      }
                    }
                  });
                },
        builder: (context, candidateData, rejectedData) {
          return Container(
            color: Colors.amber,
            child: GridView.builder(
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
                return FolderWidget(
                    labelText: _alternativeContainerItems[index].image.name,
                    imageUrl: _alternativeContainerItems[index].image.imageUrl);},
            ),
          );
        },
            )),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.amber,
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
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      setState(() {
                        _alternativeContainerItems.clear();
                      });
                    },
                  ),
                ),
                  Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                          onPressed: () {
                            setState(() {
                              final imageIds = _alternativeContainerItems.map((item) => item.image.id).toList();
                              context.read<BoardBloc>().add(PlayTTS(image_ids: imageIds));
                            });
                          },
                        ),
                      ),
              ],),)),
    ],);
  }
  Widget _buildDragTarget(int index, BoardsTabsResponseModel tabDetails, int id, Color color) {
    return Builder(
        builder: (context)
    {
      return DragTarget<int>(
        onAcceptWithDetails: (details) async {
          if (!_dragImages) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition = renderBox.globalToLocal(details.offset);
            draggableTopPosition = Offset(
              localPosition.dx,
              localPosition.dy,
            );
            final y = draggableTopPosition!.dy <= 300 &&
                draggableTopPosition!.dy >= 0
                ? draggableTopPosition!.dy / 300
                : -1;
            draggableTopPosition = null;
            if (y != -1) {
              Map<String, dynamic> message = {};
              if(tabDetails.images.isEmpty){
                message = {
                  "type": "update_images",
                  "image_positions": [
                    {
                      "image_id": details.data,
                      "position_x": index.toDouble(),
                      "position_y": y,
                    }
                  ]
                };
              }else{
              message = {
                "type": "update_images",
                "image_positions": [
                  ...tabDetails.images
                      .where((item) => item.image.id != details.data)
                      .map((item) =>
                  {
                    "image_id": item.image.id,
                    "position_x": item.positionX,
                    "position_y": item.positionY,
                  }),
                  {
                    "image_id": details.data,
                    "position_x": index.toDouble(),
                    "position_y": y,
                  }
                ]
              };
              }
              String jsonMessage = jsonEncode(
                  message, toEncodable: (nonEncodable) {
                if (nonEncodable is Set) {
                  return nonEncodable.toList();
                }
                throw UnsupportedError(
                    'Cannot encode object of type ${nonEncodable.runtimeType}');
              });
              WebSocket socket = await WebSocket.connect(
                  'wss://api.pecs.qys.kz/ws/tabs/${widget.boardId}/$id/?locale=en');
              socket.add(jsonMessage);
            }}},
        builder: (context, candidateData, rejectedData) {
          return Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 10,
                height: 300,
                color: color,
              ),
              Container(
                height: 300,
                color: Colors.transparent,
                width: 150,
                child: Stack(
                  children: tabDetails.images.map((image) {
                    if (image.positionX == index) {
                      double alignmentY = (image.positionY * 2) - 1;
                      return Align(
                        alignment: Alignment(0, alignmentY),
                        child:  Draggable<int>(
                      data: image.image.id,
                        feedback: SizedBox(
                            height: 150,
                            width: 150,
                            child: FolderWidget(
                                labelText: image.image.name,
                                imageUrl: image.image.imageUrl),
                        ),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: FolderWidget(
                              labelText: image.image.name,
                              imageUrl: image.image.imageUrl),
                        ),),
                        );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList(),
                ),
              )
          ]));
        },
      );
    }
    );
  }
}