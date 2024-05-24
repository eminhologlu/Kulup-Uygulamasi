import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 98, 154),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "assets/images/firatlogo.png",
                scale: MediaQuery.of(context).size.width * 0.007,
              ),
            ),
            Text(
              "Fırat Üniversitesi",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 218, 120),
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: "Lalezar"),
            ),
            Text(
              "Öğrenci Toplulukları",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 218, 120),
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: "Lalezar"),
            ),
            Text(
              "Mobil Uygulaması",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 218, 120),
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: "Lalezar"),
            ),
          ],
        ),
      ),
    );
  }
}
