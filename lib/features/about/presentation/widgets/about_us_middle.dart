import 'package:flutter/material.dart';

class AboutUsMiddle extends StatefulWidget {
  const AboutUsMiddle({super.key});

  @override
  State<AboutUsMiddle> createState() => _AboutUsMiddleState();
}

class _AboutUsMiddleState extends State<AboutUsMiddle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 350,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 150),
                Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 8,
                      child: Transform.rotate(
                        angle: 0.3, // Adjust the angle as needed
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            height: 370,
                            width: 370,
                            color: Color.fromRGBO(226, 173, 81, 1), // Replace with your figure or background color
                          ),
                        ),
                      ),
                    ),
                    // The image on top
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/jpg/kid5.jpg', // Replace with your image path
                        height: 400,
                        width: 400,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0, // Adjust this value to position the top of the puzzle image
                      left: 220, // Adjust this value to position the left of the puzzle image
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/jpg/puzzle.png', // Replace with your new image path
                          height: 100, // Adjust the size as needed
                          width: 100, // Adjust the size as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                  SizedBox(width: 100),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Проблемы, которые мы решаем',
                          style: TextStyle(
                            color: Color.fromRGBO(87, 156, 163, 1),
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      SizedBox(height: 10,),
                      CardElement(number: 1, text: 'Постоянная необходимость\n распечатывать новые карточки',),
                      SizedBox(height: 3,),
                      CardElement(number: 2, text: 'Потеря или износ карточек',),
                      SizedBox(height: 3,),
                      CardElement(number: 3, text: 'Сложность переноски большого\n количества карточек',),
                      SizedBox(height: 3,),
                      CardElement(number: 4, text: 'Запутанность из-за большого количества\n карточек',)
                    ],
                  )

              ],
            ),
          ],
        ),
      ),
    );
  }
}
class CardElement extends StatelessWidget {
  final int number;
  final String text;

  const CardElement({
    Key? key,
    required this.number,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:EdgeInsets.all(8.0),
          child: Row(
            children: [
                CircleAvatar(
                    backgroundColor: Color.fromRGBO(226, 173, 81, 1),
                    radius: 29,
                    child: Center(
                        child: Text(
                          number.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                        ),
                      ),
                  ),
                   ),
                  SizedBox(width: 30.0),
                  Text(text,
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Montserrat'
                 ),
                ),
             ],
           ),
          );
  }
}