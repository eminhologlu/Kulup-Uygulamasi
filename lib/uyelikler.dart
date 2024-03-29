import 'package:flutter/material.dart';
import 'package:kulup/toplulukhub.dart';
import 'package:kulup/topluluklar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Uyelikler extends StatefulWidget {
  const Uyelikler({super.key});

  @override
  State<Uyelikler> createState() => _UyeliklerState();
}

class _UyeliklerState extends State<Uyelikler> {
  List<Map<String, dynamic>> topluluklar = [];

  @override
  void initState() {
    super.initState();
    _fetchTopluluklar();
  }

  Future<void> _fetchTopluluklar() async {
    // Kullanıcının üyeliklerini çekmek için Uyelikler tablosundan sorgu oluştur
    final ParseUser user = await ParseUser.currentUser() as ParseUser;
    final ParseObject memberships = ParseObject('Uyelikler');
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(memberships);
    query.whereEqualTo('username', user.username);

    try {
      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        final List<dynamic> uyelikler =
            response.results!.first.get<List>('uyelikler') ?? [];
        final List<Map<String, dynamic>> topluluklarWithLogos = [];

        // Her bir topluluk adı için logo bilgisini al
        for (final toplulukAdi in uyelikler) {
          final QueryBuilder<ParseObject> toplulukQuery =
              QueryBuilder<ParseObject>(ParseObject('Topluluklar'));
          toplulukQuery.whereEqualTo('toplulukadi', toplulukAdi);
          final ParseResponse toplulukResponse = await toplulukQuery.query();

          if (toplulukResponse.success && toplulukResponse.results != null) {
            final ParseObject result = toplulukResponse.results!.first;
            final String? logo = result.get<String>('logo');

            // Topluluk adı ve logo bilgisini bir harita olarak ekle
            topluluklarWithLogos.add({
              'toplulukadi': toplulukAdi,
              'logo': logo,
            });
          }
        }

        setState(() {
          topluluklar = topluluklarWithLogos;
        });
      } else {
        print('Kullanıcı bulunamadı veya üyelikler alınamadı');
      }
    } catch (e) {
      print('Hata: $e');
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
