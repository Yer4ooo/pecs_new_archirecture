import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final String? labelText;
  final String? imageUrl;


  const FolderWidget({
    super.key,
    required this.labelText, required this.imageUrl,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(imageUrl!,
                  fit: BoxFit.contain,
                  width: double.infinity,),
        ),),
            const SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: Text(
                labelText!,
                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    ],)
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
