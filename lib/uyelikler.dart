import 'package:flutter/material.dart';
import 'package:kulup/toplulukhub.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Uyelikler extends StatefulWidget {
  const Uyelikler({super.key});

  @override
  State<Uyelikler> createState() => _UyeliklerState();
}

class _UyeliklerState extends State<Uyelikler> {
  List<String> topluluklar = [];

  @override
  void initState() {
    super.initState();
    _fetchTopluluklar();
  }

  Future<void> _fetchTopluluklar() async {
    // Kullanıcının uyelikler sütunundan topluluk adlarını çekme
    final user = await ParseUser.currentUser() as ParseUser;
    final uyelikler = user.get<List>('uyelikler');
    if (uyelikler != null) {
      setState(() {
        topluluklar = uyelikler.cast<String>();
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
            body: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              itemCount: topluluklar.length,
              itemBuilder: (BuildContext context, int index) {
                final toplulukAdi = "filteredTopluluklar[index]";
                String? logoURL = "logolar[toplulukAdi]";
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ToplulukHub(
                            toplulukAdi: toplulukAdi,
                            toplulukLogo: logoURL ?? "nan",
                          ),
                        ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.115,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 133, 202, 149),
                        border: Border.all(
                            color: Color.fromARGB(255, 133, 202, 149)),
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.05)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.03),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage: logoURL != null && logoURL != "nan"
                                ? NetworkImage(logoURL)
                                : NetworkImage(
                                    "https://unievi.firat.edu.tr/assets/front/img/firat-logo-yeni.png"),
                            backgroundColor: Colors.white,
                            radius: MediaQuery.of(context).size.width * 0.085,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.03),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: SingleChildScrollView(
                                child: Text(
                                  topluluklar[index],
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      fontFamily: "Lalezar",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
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
            )),
      ),
    );
  }
}
