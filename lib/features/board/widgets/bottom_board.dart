import 'package:flutter/material.dart';

class BottomLibrary extends StatefulWidget {
  const BottomLibrary({super.key});

  @override
  State<BottomLibrary> createState() => _BottomLibraryState();
}

class _BottomLibraryState extends State<BottomLibrary> {
  bool _showPecsExpandedBubbles = false; // Show PECS expanded bubbles
  String? _selectedBubble;
  bool _expandedBubbles = false;

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
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Бешбармак'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Варенье'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Гречка'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Соль'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Бешбармак'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Варенье'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Гречка'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Соль'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Гречка'},
      {'imageUrl': 'assets/jpg/food.jpg', 'label': 'Соль'},
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
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Бизон'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Барс'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Корова'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Осел'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Мышь'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Лошадь'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Гусь'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Петух'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Орел'},
      {'imageUrl': 'assets/jpg/animal.jpg', 'label': 'Ястреб'},
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
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Майка'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Шорты '},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Штаны'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Толстовка'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Свитер'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Пальто'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Майка'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Шорты'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Штаны'},
      {'imageUrl': 'assets/jpg/clothes.jpg', 'label': 'Толстовка'},
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
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Океан'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Луг'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Каньон'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Гейзер'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Болото'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Дюны'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Залив'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Архипелаг'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Вулкан'},
      {'imageUrl': 'assets/jpg/nature.jpg', 'label': 'Ледник'},
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
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Какой?'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Привет'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Спасибо'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Как дела?'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Доброе утро'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Добрый вечер'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Извините'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Пожалуйста'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'Хорошего дня'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'После'},
      {'imageUrl': 'assets/jpg/word.jpg', 'label': 'До свидания'},
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
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 11'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 12'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 13'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 14'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 15'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 16'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 17'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 18'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 19'},
      {'imageUrl': 'assets/jpg/kairat.jpg', 'label': 'Моя Карточка 20'},
    ]
  };

  // Method to handle bubble tap and show images or expanded bubbles
  void _onBubbleTap(String bubbleName) {
    setState(() {
      if (bubbleName == 'Карточки PECS') {
        _showPecsExpandedBubbles = true;
        _selectedBubble = null;
        _expandedBubbles = true;
      } else {
        _selectedBubble = bubbleName;
        _showPecsExpandedBubbles = false;
      }
    });
  }

  // Method to handle back button tap
  void _onBackButtonTap() {
    setState(() {
      _selectedBubble = null;
      _showPecsExpandedBubbles = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        color: Colors.grey,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeader(), // Header section
            _selectedBubble != null
                ? _buildImageGrid(_selectedBubble!)
                : _showPecsExpandedBubbles
                ? _buildPecsExpandedBubbles()
                : _buildBubbles(),
          ],
        ),
      ),
    );
  }

  // Header with back button, title, and search bar
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 50,
      color: const Color.fromRGBO(77, 77, 77, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 25, color: Colors.white),
                onPressed: _onBackButtonTap,
              ),
              const SizedBox(width: 10),
              const Text(
                'Медиатека',
                style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Montserrat'),
              ),
            ],
          ),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Container(
          height: 35,
          width: 220,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, size: 20, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                'Search',
                style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Montserrat'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(Icons.arrow_drop_up, size: 35, color: Colors.black),
        ),
        const SizedBox(width: 5),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color.fromRGBO(197, 73, 7, 1),
          child: Icon(Icons.close, size: 25, color: Colors.black),
        ),
      ],
    );
  }

  // Builds the expanded PECS bubbles
  Widget _buildPecsExpandedBubbles() {
    final categories = ['Еда', 'Животные', 'Одежда', 'Природа'];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Число элементов по вертикали
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onBubbleTap(categories[index]),
            child: _buildExpandedBubble(categories[index], _getIconForCategory(categories[index])),
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

  // Builds the image grid for the selected bubble
  Widget _buildImageGrid(String bubbleName) {
    final imageSet = _bubbleImages[bubbleName] ?? [];

    if (imageSet.isEmpty) {
      return const Expanded(child: Center(child: Text('No images available')));
    }

    return Expanded(
      child: Container(
        color: Colors.grey,
        child: GridView.builder(
          padding: const EdgeInsets.all(3),
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width ~/ 120),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: imageSet.length,
          itemBuilder: (context, index) {
            final imageInfo = imageSet[index];
            return ImageCard(
              imageUrl: imageInfo['imageUrl']!,
              labelText: imageInfo['label']!,
            );
          },
        ),
      ),
    );
  }


  Widget _buildBubbles() {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(3),
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: 2,
        mainAxisSpacing: 5,
        crossAxisCount: 1,
        childAspectRatio: 0.75,
        children: [
          GestureDetector(
            onTap: () => _onBubbleTap('Вводные Фразы'),
            child: const CustomSpeechBubbleWidget(labelText: 'Вводные Фразы', icon: Icons.message_rounded),
          ),
          GestureDetector(
            onTap: () => _onBubbleTap('Карточки PECS'),
            child: const CustomSpeechBubbleWidget(labelText: 'Карточки PECS', icon: Icons.image),
          ),
          GestureDetector(
            onTap: () => _onBubbleTap('Мои Карточки'),
            child: const CustomSpeechBubbleWidget(labelText: 'Мои Карточки', icon: Icons.person_outline),
          ),
        ],
      ),
    );
  }
}

// Custom Widgets below remain unchanged
class CustomSpeechBubbleWidget extends StatelessWidget {
  final String labelText;
  final IconData icon;

  const CustomSpeechBubbleWidget({
    Key? key,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 75,
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            labelText,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 50,
                color: const Color.fromRGBO(0, 0, 0, 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FolderWidget extends StatelessWidget {
  final String labelText;
  final IconData icon;

  const FolderWidget({
    Key? key,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            labelText,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 50,
                color: const Color.fromRGBO(0, 0, 0, 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String labelText;

  const ImageCard({
    required this.imageUrl,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<Map<String, String>>(
      data: {'imageUrl': imageUrl, 'labelText': labelText}, // Передача данных при перетаскивании
      feedback: Material(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
            width: 120,
            height: 100,
            child: _buildCard(),
        ),),
      childWhenDragging: SizedBox(
        width: 120,
        height: 100,
        child: _buildCard(), // Визуальное представление во время перетаскивания
      ),
      child: SizedBox(
        width: 120,
        height: 100,
        child: _buildCard(), // Визуальное представление во время перетаскивания
      ), // Обычный виджет
    );
  }

  Widget _buildCard() {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            labelText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat',fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}





// Sample image sets for each bubble
