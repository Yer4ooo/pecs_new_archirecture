import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/presentation/screens/widgets/home_top_widget.dart';
import '../logic/bloc/board_bloc.dart';
import '../widgets/bottom_board.dart';
import '../logic/models/board_details_model.dart';

class Board extends StatefulWidget {
  final String boardId;
  const Board({required this.boardId, super.key});


  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  int curBoardId = 0;
  final List<Map<String, String>> _alternativeContainerItems = [];
  bool _showPecsExpandedBubbles = false;
  String? _selectedBubble;
  bool _dragImages = false;
  bool _isMediaGridVisible = true;
  bool _expandedBubbles = false;
  String name = 'untitled';
  Color color = Color.fromRGBO(97, 148, 81, 1);
  int numOfRows = 5;

  int dropdownvalue = 5;
  @override
  void initState() {
    super.initState();
    context.read<BoardBloc>().add(FetchBoardDetails(boardId: widget.boardId));
  }
  void _onBubbleTap(String bubbleName) {
    setState(() {
      if (bubbleName == 'Карточки PECS') {
        _showPecsExpandedBubbles = true;
        _selectedBubble = null;
      } else
      if (['Еда', 'Животные', 'Одежда', 'Природа'].contains(bubbleName)) {
        _expandedBubbles = true;
        _selectedBubble = bubbleName;
        _showPecsExpandedBubbles = false;
      }
      else {
        _selectedBubble = bubbleName;
        _showPecsExpandedBubbles = false;
      }
    });
  }

  void _onCloseIconTap() {
    setState(() {
      _isMediaGridVisible = false;
    });
  }

  void _onReturnIconTap() {
    setState(() {
      _isMediaGridVisible = true;
    });
  }

  void _onBackButtonTap() {
    setState(() {
      if (_expandedBubbles) {
        _expandedBubbles = false;
        _selectedBubble = null;
        _showPecsExpandedBubbles = true;
      }
      else {
        _selectedBubble = null;
        _showPecsExpandedBubbles = false;
      }
    });
  }
  hexColor(String color) {
    String colorNew = '0xFF' + color;
    colorNew = colorNew.replaceAll('#', '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeTopWidget(),
          Expanded(
            child: BlocBuilder<BoardBloc, BoardState>(
              builder: (context, state) {
                if (state is BoardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BoardDetailsFailure) {
                  return const Center(child: Text("Ошибка загрузки доски"));
                } else if (state is BoardDetailsSuccess) {
                  final board = state.boardDetails.board;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 400,
                        color: Color(hexColor(board.tabs[curBoardId].color)),
                        child: Stack(
                          children: [Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...List.generate(board.tabs[curBoardId].strapsNum, (index) => _buildDragTarget(index)),
                          ]
                        ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                    _dragImages ? Icons.lock_open : Icons.lock, color: Colors.white, size: 30),
                                onPressed: () {
                                  setState(() {
                                    _dragImages = !_dragImages;
                                  });
                                },
                              ),
                            ),)
                                ],)
                      ),
                      Stack(
                        children: [
                          Row(children: [
                            ...board.tabs.asMap().entries.map((entry) {
                              int index = entry.key;
                              final tab = entry.value;
                              return InkWell(
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
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Text(
                                              tab.name,
                                              style: TextStyle(color: Colors.white, fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon: Icon(Icons.settings),
                                                onPressed: () {
                                                  setState(() {
                                                    curBoardId = index;
                                                  });
                                                },
                                              ))
                                        ],
                                      ),
                                    )),
                                onTap: () {
                                  setState(() {
                                    curBoardId = index;
                                  });
                                  ();
                                },
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
                                  },
                                  icon: const Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: _dragImages ? _buildAlternativeContainer() : _buildLibraryContainer(),
                    )
                  ]
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLibraryContainer(){
    return Container(color: Colors.deepOrange,);
  }

  Widget _buildAlternativeContainer() {
    final AudioPlayer _player = AudioPlayer();

    Future<void> _playBytesAsAudio(List<int> bytes) async {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/tts_audio.mp3');
      await file.writeAsBytes(bytes, flush: true);
      await _player.setFilePath(file.path);
      _player.play();
    }
    return DragTarget<Map<String, String>>(
      onAccept: (data) {
        setState(() {
          _alternativeContainerItems.add(data);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Center(
          child: Container(
            width: double.infinity,
            color: Colors.amber.shade500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display dropped items
                Expanded(
                  child: Row(
                    children: _alternativeContainerItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: 120,
                          height: 100,
                          child: Stack(children: [
                            _buildDroppedImageThumbnail(item),
                            Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                radius: 15,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 15,
                                      color: Colors.black),
                                  onPressed: (){
                                    setState(() {
                                      _alternativeContainerItems.remove(item);
                                    });
                                  },
                                ),
                              ),
                            ),]),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                            Icons.close, color: Colors.white, size: 30),
                        onPressed: () {
                          setState(() {
                            _alternativeContainerItems
                                .clear();
                          });
                        },
                      ),
                    ),
                      const SizedBox(height: 10),
                      BlocConsumer<BoardBloc, BoardState>(
                        listener: (context, state) {
                          if (state is TTSPlaySuccess) {
                            _playBytesAsAudio(state.text);
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                              onPressed: () {
                                final combined = _alternativeContainerItems.map((item) => item['labelText']).join(' ');
                                context.read<BoardBloc>().add(PlayTTS(text: combined));
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildDroppedImageThumbnail(Map<String, String> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      width: 120,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 50, // Adjust image size as needed
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(data['imageUrl']!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Text
          Text(
            data['labelText'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDragTarget(int index) {
    if(_isMediaGridVisible){
      return DragTarget<Map<String, String>>(
        onAccept: (data) {
          setState(() {
          });
        },
        builder: (context, candidateData, rejectedData) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 350,
                    color: Colors.grey,
                  ),
                  Container(
                    width: 200,
                    // Remove fixed height to allow content to expand
                    color: Colors.transparent,
                    // child: Column(
                    //   children: boards[curBoardId].rows[index].map((image) {
                    //     if (_isMediaGridVisible) {
                    //       return SizedBox(
                    //         width: 120,
                    //         height: 100,
                    //         child: Stack(
                    //           children: [
                    //             _buildDroppedImageThumbnail(image),
                    //             Align(
                    //               alignment: Alignment.topRight,
                    //               child: CircleAvatar(
                    //                 radius: 15,
                    //                 child: IconButton(
                    //                   icon: const Icon(Icons.close, size: 15,
                    //                       color: Colors.black),
                    //                   onPressed: (){
                    //                     setState(() {
                    //                     });
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     }
                    //     else {
                    //       return Draggable<Map<String, String>>(
                    //         data: image, // Enable dragging specific items
                    //         feedback: Material(
                    //           borderRadius: BorderRadius.circular(10),
                    //           child: SizedBox(
                    //             width: 120,
                    //             height: 100,
                    //             child: _buildDroppedImageThumbnail(image),
                    //           ),
                    //         ),
                    //         child: SizedBox(
                    //           width: 120,
                    //           height: 100,
                    //           child: _buildDroppedImageThumbnail(image),
                    //         ),
                    //       );
                    //     }
                    //   }).toList(),
                    // ),
                  ),
                ],
              ),
            ),
          );
        },
      );}
    else{
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 10,
                height: 350,
                color: Colors.grey,
              ),
              Container(
                width: 200,
                // Remove fixed height to allow content to expand
                color: Colors.transparent,
                // child: Column(
                //   children: boards[curBoardId].rows[index].map((image) {
                //     if (_isMediaGridVisible) {
                //       return SizedBox(
                //         width: 120,
                //         height: 100,
                //         child: Stack(
                //           children: [
                //             _buildDroppedImageThumbnail(image),
                //             Align(
                //               alignment: Alignment.topRight,
                //               child: CircleAvatar(
                //                 radius: 15,
                //                 child: IconButton(
                //                   icon: const Icon(Icons.close, size: 15,
                //                       color: Colors.black),
                //                   onPressed: (){
                //                     setState(() {
                //                     });
                //                   },
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     }
                //     else {
                //       return Draggable<Map<String, String>>(
                //         data: image, // Enable dragging specific items
                //         feedback: Material(
                //           borderRadius: BorderRadius.circular(10),
                //           child: SizedBox(
                //             width: 120,
                //             height: 100,
                //             child: _buildDroppedImageThumbnail(image),
                //           ),
                //         ),
                //         child: SizedBox(
                //           width: 120,
                //           height: 100,
                //           child: _buildDroppedImageThumbnail(image),
                //         ),
                //       );
                //     }
                //   }).toList(),
                // ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildPecsExpandedBubbles() {
    final categories = ['Еда', 'Животные', 'Одежда', 'Природа'];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onBubbleTap(categories[index]),
            child: _buildExpandedBubble(
                categories[index], _getIconForCategory(categories[index])),
          );
        },
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Еда':
        return Icons.fastfood;
      case 'Животные':
        return Icons.pan_tool;
      case 'Одежда':
        return Icons.accessibility_new_sharp;
      case 'Природа':
        return Icons.table_restaurant_sharp;
      default:
        return Icons.category;
    }
  }

  Widget _buildExpandedBubble(String label, IconData icon) {
    return FolderWidget(labelText: label, icon: icon);
  }

  Widget _buildImageGrid(String bubbleName) {
    final imageSet = _bubbleImages[bubbleName] ?? [];

    if (imageSet.isEmpty) {
      return const Expanded(child: Center(child: Text('No images available')));
    }

    return Expanded(
      child: Container(
        color: Colors.grey,
        child: ListView.builder(
          padding: const EdgeInsets.all(3),
          scrollDirection: Axis.horizontal,
          itemCount: imageSet.length,
          itemBuilder: (context, index) {
            final imageInfo = imageSet[index];
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 120,
                child: ImageCard(
                  imageUrl: imageInfo['imageUrl']!,
                  labelText: imageInfo['label']!,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBubbles() {
    return Expanded(
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 1,
        childAspectRatio: 1,
        children: [
          GestureDetector(
            onTap: () => _onBubbleTap('Вводные Фразы'),
            child: const CustomSpeechBubbleWidget(
                labelText: 'Вводные Фразы', icon: Icons.message_rounded),
          ),
          GestureDetector(
            onTap: () => _onBubbleTap('Карточки PECS'),
            child: const CustomSpeechBubbleWidget(
                labelText: 'Карточки PECS', icon: Icons.image),
          ),
          GestureDetector(
            onTap: () => _onBubbleTap('Мои Карточки'),
            child: const CustomSpeechBubbleWidget(
                labelText: 'Мои Карточки', icon: Icons.person_outline),
          ),
        ],
      ),
    );
  }

  Widget buildColorPicker() =>
      ColorPicker(
        pickerColor: Color.fromRGBO(97, 148, 81, 1),
        onColorChanged: (color) => (this.color = color),
      );

  void _onCreateNewBoard() {
    String dialogName = name;
    int dialogNumOfRows = numOfRows;
    final parentContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Center(child: Text("Создать новую доску", style: TextStyle(fontSize: 22))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Введи имя", style: TextStyle(fontSize: 20))),
                  TextField(
                    decoration: InputDecoration(hintText: "Без названия"),
                    onChanged: (text) {
                      dialogName = text;
                    },
                  ),
                  SizedBox(height: 50),
                  SizedBox(height: 200, child: buildColorPicker()),
                  SizedBox(height: 50),
                  Text("Веди количество строк", style: TextStyle(fontSize: 20)),
                  DropdownButton<int>(
                    items: List.generate(5, (index) {
                      int value = index + 1;
                      return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
                    }),
                    value: dialogNumOfRows,
                    icon: const Icon(Icons.arrow_downward),
                    onChanged: (int? value) {
                      setDialogState(() {
                        dialogNumOfRows = value!;
                      });
                    },
                  )
                ],
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      parentContext.read<BoardBloc>().add(CreateBoard(name: dialogName));
                      setState(() {
                        name = 'Без названия';
                        color = Color.fromRGBO(97, 148, 81, 1);
                      });
                    },
                    child: Text("Создать"),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }


  final Map<String, List<Map<String, String>>> _bubbleImages = {
    'Еда': [
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Пицца'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Бургер'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Котлеты'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Манты'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Плов'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Банан'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Лагман'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Хлеб'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Орама'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Яйцо'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Яйцо'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Яйцо'},
    ],
    'Животные': [
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Кошка'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Собака'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Лев'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Волк'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Тигр'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Панда'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Кит'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Крыса'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Слон'},

    ],
    'Одежда': [
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Футболка'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Джинсы'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Шорты'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Куртка'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Худи'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Брюки'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Рубашка'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Пиджак'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Свитер'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Пальто'},

    ],
    'Природа': [
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Горы'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Море'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Лес'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Река'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Озеро'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Пустыня'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Водопад'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Поле'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Саванна'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Пещера'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Джунгли'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Степь'},

    ],
    'Вводные Фразы': [
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Привет'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Спасибо'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Как дела?'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Доброе утро'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Добрый вечер'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Извините'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Пожалуйста'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Как?'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Рад видеть'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Чем?'},

    ],
    'Мои Карточки': [
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 1'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 2'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 3'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 4'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 5'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 6'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 7'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 8'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 9'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 10'},

    ]
  };

  void _onEditBoard() {
    String dialogName = name;
    int dialogNumOfRows = numOfRows;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Center(child: Text(
                  "Edit your board22", style: TextStyle(fontSize: 22),)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(alignment: Alignment.topLeft,
                        child: Text("Change the name of your board22:",
                          style: TextStyle(fontSize: 20),)),
                    TextField(
                      decoration: InputDecoration(
                          hintText: ""),
                      onChanged: (text) {
                        dialogName = text;
                      },
                    ),
                    SizedBox(height: 50),
                    SizedBox(height: 200, child: buildColorPicker()),
                    SizedBox(height: 50),
                  ],
                ),
                actions: [
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            name = 'untitled';
                            color = Color.fromRGBO(97, 148, 81, 1);
                          });
                        },
                        child: Text("Change")
                    ),
                  )
                ],
              );
            }
        );
      },
    );
  }

}