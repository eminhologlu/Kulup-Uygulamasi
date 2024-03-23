import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Duyuru extends StatefulWidget {
  const Duyuru(
      {required this.duyurubaslik,
      required this.toplulukLogo,
      required this.duyurutext});
  final String duyurubaslik;
  final String toplulukLogo;
  final String duyurutext;

  @override
  State<Duyuru> createState() => _DuyuruState();
}

class _DuyuruState extends State<Duyuru> {
  late String duyurubaslik;
  late String toplulukLogo;
  late String duyurutext;
  @override
  void initState() {
    super.initState();
    duyurubaslik = widget.duyurubaslik;
    toplulukLogo = widget.toplulukLogo;
    duyurutext = widget.duyurutext;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 79, 93, 154),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
        backgroundColor: Color.fromARGB(255, 79, 93, 154),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            duyurubaslik,
            style: TextStyle(fontFamily: "Lalezar", color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              radius: MediaQuery.of(context).size.width * 0.15,
              foregroundImage: toplulukLogo != "nan"
                  ? NetworkImage(toplulukLogo)
                  : const NetworkImage(
                      "https://unievi.firat.edu.tr/assets/front/img/firat-logo-yeni.png"),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 216, 245, 135),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                ),
                height: MediaQuery.of(context).size.height * 0.69,
                width: MediaQuery.of(context).size.width * 0.96,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  child: SingleChildScrollView(
                    child: Text(
                      duyurutext,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
