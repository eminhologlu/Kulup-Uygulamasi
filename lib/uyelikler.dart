import 'package:flutter/material.dart';
import 'package:kulup/services/fetch_uyelik.dart';
import 'package:kulup/toplulukhub.dart';
import 'package:kulup/topluluklar.dart';

class Uyelikler extends StatefulWidget {
  const Uyelikler({super.key});
  @override
  State<Uyelikler> createState() => _UyeliklerState();
}

class _UyeliklerState extends State<Uyelikler> {
  UyelikCek uyelikcek = UyelikCek();

  List<Map<String, dynamic>> topluluklar = [];
  Future<void> _initializeData() async {
    try {
      List<Map<String, dynamic>> fetchedData =
          await uyelikcek.fetchTopluluklar();
      setState(() {
        topluluklar = fetchedData;
      });
    } catch (e) {
      print('Verileri alma işlemi sırasında bir hata oluştu: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Topluluklarım",
                style: TextStyle(
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: Colors.white),
              ),
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
            backgroundColor: const Color.fromARGB(255, 79, 93, 154),
            body: topluluklar.isEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.1),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Henüz bir topluluğa üye değilsin.',
                            style: TextStyle(
                                fontFamily: "Lalezar",
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.1,
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Topluluklar(),
                              ));
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 0, 0, 0),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.6,
                                MediaQuery.of(context).size.height * 0.05)),
                        child: Text(
                          "Topluluklara Göz At",
                          style: TextStyle(
                              fontFamily: "Lalezar",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.98,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      itemCount: topluluklar.length,
                      itemBuilder: (BuildContext context, int index) {
                        final topluluk = topluluklar[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ToplulukHub(
                                    toplulukAdi: topluluk['toplulukadi'],
                                    toplulukLogo: topluluk['logo'] ?? "nan",
                                  ),
                                ));
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.115,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 133, 202, 149),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 133, 202, 149)),
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.05)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    foregroundImage: topluluk['logo'] != null &&
                                            topluluk['logo'] != "nan"
                                        ? NetworkImage(topluluk['logo'])
                                        : const NetworkImage(
                                            "https://unievi.firat.edu.tr/assets/front/img/firat-logo-yeni.png"),
                                    backgroundColor: Colors.white,
                                    radius: MediaQuery.of(context).size.width *
                                        0.085,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          topluluk['toplulukadi'],
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontFamily: "Lalezar",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.045),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        color: Colors.transparent,
                      ),
                    ),
                  )),
      ),
    );
  }
}
