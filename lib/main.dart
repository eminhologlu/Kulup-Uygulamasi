import 'package:flutter/material.dart';
import 'package:kulup/loading.dart';
import 'package:kulup/login.dart';
import 'package:kulup/topluluklar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shequ',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 0)), // 5 saniye bekle
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen(); // Bekleme ekranını göster
          } else {
            return LoginPage(); // Bekleme süresi dolduktan sonra giriş sayfasını göster
          }
        },
      ),
    );
  }
}
