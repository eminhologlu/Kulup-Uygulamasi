import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      backgroundColor: const Color.fromARGB(255, 79, 93, 154),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.13),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Topluluklar()));
                },
                child: buildContainer("Öğrenci Toplulukları")),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Uyelikler()));
                },
                child: buildContainer("Üyesi Olduğun Topluluklar")),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(
                onTap: () {},
                child: buildContainer("Yönetici Olduğun Topluluklar")),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(onTap: () {}, child: buildContainer("Ayarlar")),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(String text) {
    return Container(
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontFamily: "Lalezar",
              color: Colors.white),
        )),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
            color: Colors.black));
  }
}
