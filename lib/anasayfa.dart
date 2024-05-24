import 'package:flutter/material.dart';
import 'package:kulup/ayarlar.dart';
import 'package:kulup/kulupyonetim.dart';
import 'package:kulup/topluluklar.dart';
import 'package:kulup/uyelikler.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 98, 154),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.085),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Topluluklar()));
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.stacked_bar_chart_rounded,
                      size: MediaQuery.of(context).size.width * 0.3,
                      color: Color.fromARGB(255, 255, 218, 120),
                    ),
                    Text(
                      "Öğrenci Toplulukları",
                      style: TextStyle(
                          fontFamily: "Lalezar",
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    )
                  ],
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Uyelikler()));
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_person_rounded,
                      size: MediaQuery.of(context).size.width * 0.3,
                      color: Color.fromARGB(255, 255, 218, 120),
                    ),
                    Text(
                      "Üye Olduğun Topluluklar",
                      style: TextStyle(
                          fontFamily: "Lalezar",
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    )
                  ],
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const KulupYonetim()));
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      size: MediaQuery.of(context).size.width * 0.3,
                      color: Color.fromARGB(255, 255, 218, 120),
                    ),
                    Text(
                      "Yönetici Olduğun Topluluklar",
                      style: TextStyle(
                          fontFamily: "Lalezar",
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    )
                  ],
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Ayarlar()));
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.settings_applications_rounded,
                      size: MediaQuery.of(context).size.width * 0.3,
                      color: Color.fromARGB(255, 255, 218, 120),
                    ),
                    Text(
                      "Ayarlar",
                      style: TextStyle(
                          fontFamily: "Lalezar",
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(String text) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
          color: Colors.black),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontFamily: "Lalezar",
            color: Colors.white),
      )),
    );
  }
}
