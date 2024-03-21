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
      backgroundColor: Color.fromARGB(255, 25, 139, 28),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "assets/images/firatlogo.png",
                scale: MediaQuery.of(context).size.width * 0.005,
              ),
            ),
            Text(
              "Fırat Üniversitesi",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: "Lalezar"),
            ),
            Text(
              "Öğrenci Toplulukları",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: "Lalezar"),
            ),
            Text(
              "Mobil Uygulaması",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: "Lalezar"),
            ),
          ],
        ),
      ),
    );
  }
}
