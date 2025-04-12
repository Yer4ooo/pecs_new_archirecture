import 'package:flutter/material.dart';

class HomeBottomWidget extends StatefulWidget {
  const HomeBottomWidget({super.key});

  @override
  State<HomeBottomWidget> createState() => _HomeBottomWidgetState();
}

class _HomeBottomWidgetState extends State<HomeBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          // Ensures proper layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'SOYLEM: ваш помощник\n в терапии РАС',
                style: TextStyle(
                  fontSize: 30,
                  color: const Color.fromRGBO(97, 148, 81, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Начните использовать SӨYLEM и улучшите коммуникацию\n вашего ребенка сегодня!',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Color.fromRGBO(97, 148, 81, 1)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      'Попробовать Бесплатно',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Color.fromRGBO(87, 156, 163, 1),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Узнать подробнее',
                          style: TextStyle(
                            color: Color.fromRGBO(87, 156, 163, 1),
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.play_arrow,
                          color: Color.fromRGBO(87, 156, 163, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 40,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/jpg/kid2.jpg'),
                          radius: 30,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/jpg/kid3.jpg'),
                          radius: 30,
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/jpg/kid1.jpg'),
                        radius: 30,
                      ),
                    ],
                  ),
                  SizedBox(width: 100),
                  Column(
                    children: [
                      Text(
                        '100',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Kid Users'),
                    ],
                  ),
                  SizedBox(width: 70),
                  Column(
                    children: [
                      Text(
                        '4.8/5',
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star_half, color: Colors.yellow),
                          Text('Rating')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center, // Ensures the children are aligned centrally
          children: [
            // Blue circle behind the kid image
            Container(
              width: 450, // Adjust size for the circle
              height: 450,
              decoration: BoxDecoration(
                color: Color.fromRGBO(184, 213, 217, 1), // Blue color for the circle
                shape: BoxShape.circle, // Makes it a circle
              ),
            ),
            // Base image (kid4)
            Container(
              width: 400, // Adjust width and height as needed
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/jpg/kid4.png'),
                  fit: BoxFit.contain, // Covers the container with the image
                ),
                borderRadius: BorderRadius.circular(20), // Optional: rounded corners
              ),
            ),
            // "Car" image positioned on top
            Positioned(
              top: 170, // Adjust position for overlap
              right: 370,
              child: SizedBox(
                width: 180,
                height: 180, // Adjust height as needed
                child: Stack(
                  children: [
                    // Image with opacity
                    Opacity(
                      opacity: 0.7, // Adjust opacity (0.0 is fully transparent, 1.0 is fully opaque)
                      child: Container(
                        width: 180, // Adjust width if needed
                        height: 180, // Increased height for overlap
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/jpg/car.jpg'), // Replace with your image path
                            fit: BoxFit.contain, // Ensures the image covers the container
                          ),
                          borderRadius: BorderRadius.circular(20), // Optional: rounded corners
                        ),
                      ),
                    ),
                    // Text directly on the image (no changes needed)
                    Positioned(
                      bottom: 110, // Adjust position for placement
                      left: 0,
                      right: -100,
                      child: Text(
                        'Көлік',
                        textAlign: TextAlign.center, // Center the text
                        style: TextStyle(
                          color: Colors.black, // Adjust text color for contrast
                          fontSize: 18, // Adjust font size as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // "Sab" image positioned on top
            Positioned(
              top: 40, // Adjust position for overlap
              right: -10,
              child: SizedBox(
                width: 150,
                height: 160, // Adjust height as needed
                child: Stack(
                  children: [
                    // Image with opacity
                    Opacity(
                      opacity: 0.7, // Adjust opacity (0.0 is fully transparent, 1.0 is fully opaque)
                      child: Container(
                        width: 150, // Adjust width if needed
                        height: 300, // Increased height for overlap
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/jpg/sab.jpg'), // Replace with your image path
                            fit: BoxFit.contain, // Ensures the image covers the container
                          ),
                          borderRadius: BorderRadius.circular(20), // Optional: rounded corners
                        ),
                      ),
                    ),
                    // Text directly on the image (no changes needed)
                    Positioned(
                      bottom: 110, // Adjust position for placement
                      left: 0,
                      right: 75,
                      child: Text(
                        'Сәбіз',
                        textAlign: TextAlign.center, // Center the text
                        style: TextStyle(
                          color: Colors.black, // Adjust text color for contrast
                          fontSize: 18, // Adjust font size as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 50)
          ],
        )
      ],
    );
  }
}
