import 'package:flutter/material.dart';
import 'package:kulup/loading.dart';
import 'package:kulup/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
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
        future: Future.delayed(Duration(seconds: 3)), // 5 saniye bekle
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
