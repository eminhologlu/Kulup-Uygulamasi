import 'package:flutter/material.dart';
import 'package:kulup/yonetimislemleri.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class KulupYonetim extends StatefulWidget {
  const KulupYonetim({super.key});

  @override
  State<KulupYonetim> createState() => _KulupYonetimState();
}

class _KulupYonetimState extends State<KulupYonetim> {
  List<Map<String, dynamic>> topluluklar = [];

  @override
  void initState() {
    super.initState();
    _fetchTopluluklar();
  }

  Future<void> _fetchTopluluklar() async {
    // Kullanıcının uyelikler sütunundan topluluk adlarını çekme
    final user = await ParseUser.currentUser() as ParseUser;
    final uyelikler = user.get<List>('yoneticilikler');

    if (uyelikler != null) {
      final List<Map<String, dynamic>> topluluklarWithLogos = [];

      // Her bir topluluk adı için logo bilgisini al
      for (final toplulukAdi in uyelikler) {
        final query = QueryBuilder(ParseObject('Topluluklar'))
          ..whereEqualTo('toplulukadi', toplulukAdi);
        final response = await query.query();

        if (response.success && response.results != null) {
          final result = response.results!.first;
          final logo = result.get<String>('logo');

          // Topluluk adı ve logo bilgisini bir harita olarak ekle
          topluluklarWithLogos.add({
            'toplulukadi': toplulukAdi,
            'logo': logo,
          });
        }
      }

      setState(() {
        topluluklar = topluluklarWithLogos.cast<Map<String, dynamic>>();
      });
    }
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
                "Yönetim",
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
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.1),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Yönetici olduğun topluluk yok.',
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
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
                                  builder: (context) => YonetimIslemleri(
                                    toplulukAdi: topluluk['toplulukadi'],
                                    toplulukLogo: topluluk['logo'],
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
