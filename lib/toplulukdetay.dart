import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kulup/toplulukhub.dart';

class ToplulukDetay extends StatefulWidget {
  @override
  State<ToplulukDetay> createState() => _ToplulukDetayState();
  final String toplulukAdi;
  final String toplulukBaskani;
  final String toplulukDanismani;
  final String toplulukKolu;
  final String toplulukLogo;

  const ToplulukDetay({
    required this.toplulukAdi,
    required this.toplulukBaskani,
    required this.toplulukDanismani,
    required this.toplulukKolu,
    required this.toplulukLogo,
  });
}

class _ToplulukDetayState extends State<ToplulukDetay> {
  late String toplulukAdi;
  late String toplulukBaskani;
  late String toplulukDanismani;
  late String toplulukKolu;
  late String toplulukLogo;

  @override
  void initState() {
    super.initState();
    toplulukAdi = widget.toplulukAdi;
    toplulukBaskani = widget.toplulukBaskani;
    toplulukDanismani = widget.toplulukDanismani;
    toplulukKolu = widget.toplulukKolu;
    toplulukLogo = widget.toplulukLogo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 79, 93, 154),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 79, 93, 154),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: MediaQuery.of(context).size.width * 0.17,
                foregroundImage: toplulukLogo != "nan"
                    ? NetworkImage(toplulukLogo)
                    : const NetworkImage(
                        "https://unievi.firat.edu.tr/assets/front/img/firat-logo-yeni.png"),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
                style: TextStyle(
                    color: Color.fromARGB(255, 216, 245, 135),
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.06),
                textAlign: TextAlign.center,
                toplulukAdi),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Text(
            "Topluluk Danışmanı",
            style: TextStyle(
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.07),
          ),
          Text(
            toplulukDanismani,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.06),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Text(
            "Topluluk Başkanı",
            style: TextStyle(
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.07),
          ),
          Text(
            toplulukBaskani,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.06),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Text(
            "Topluluk Kolu",
            style: TextStyle(
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.07),
          ),
          Text(
            toplulukKolu,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.06),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.08,
          ),
          FilledButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToplulukHub(
                      toplulukAdi: toplulukAdi,
                      toplulukLogo: toplulukLogo,
                    ),
                  ));
            },
            style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.6,
                    MediaQuery.of(context).size.height * 0.05)),
            child: Text(
              "Topluluk Sayfasına Git",
              style: TextStyle(
                  fontFamily: "Lalezar",
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ],
      ),
    );
  }
}
