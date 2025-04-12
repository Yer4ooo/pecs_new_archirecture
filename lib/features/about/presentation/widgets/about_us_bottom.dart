import 'package:flutter/cupertino.dart';

class AboutUsBottom extends StatefulWidget {
  const AboutUsBottom({super.key});

  @override
  State<AboutUsBottom> createState() => _AboutUsBottomState();
}

class _AboutUsBottomState extends State<AboutUsBottom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 400),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 135,),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('О нас',
                      style: TextStyle(
                        color: Color.fromRGBO(97, 148, 81, 1),
                        fontSize: 25,
                        fontWeight: FontWeight.w400
                      ),),
                    SizedBox(height: 10,),
                    Text(' Мы - команда предпринимателей,\n инженеров и исследователей, посвятивших\n себя созданию инновационных решений для\n улучшения жизни детей с расстройствами\n аутистического спектра (РАС).\n \n Наша миссия - сделать коммуникацию и\n обучение детей с РАС более доступными и\n эффективными, используя современные\n технологии и индивидуальный подход.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                    ),),
                    Text(' \n Мы гордимся тем, что были удостоены\n звания финалистов в конкурсе "Social Impact 2023",\n организованном Фондом социального развития\n Назарбаев Университета. Это признание подчеркивает\n наш вклад в социальное развитие и\n подтверждает важность нашего проекта.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                      ),),
                  ],
                ),
                SizedBox(width: 100,),
                Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          top: 5,
                          left: 8,
                          child: Transform.rotate(
                            angle: -0.2, // Adjust the angle as needed
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 290,
                                width: 360,
                                color: Color.fromRGBO(87, 156, 163, 1), // Replace with your figure or background color
                              ),
                            ),
                          ),
                        ),
                        // The image on top
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/jpg/team.jpg', // Replace with your image path
                            height: 300,
                            width: 370,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 200,),
                        Stack(
                          children: [
                            Positioned(
                              top: 12,
                              left: 20,
                              child: Transform.rotate(
                                angle: -0.05, // Adjust the angle as needed
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    height: 220,
                                    width: 200,
                                    color: Color.fromRGBO(97, 148, 81, 1), // Replace with your figure or background color
                                  ),
                                ),
                              ),
                            ),
                            // The image on top
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                'assets/jpg/prof.png', // Replace with your image path
                                height: 250,
                                width: 250,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
            
          ],
        ),
      ),
    );
  }
}
