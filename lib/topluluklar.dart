import 'package:flutter/material.dart';
import 'package:kulup/toplulukdetay.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Topluluklar extends StatefulWidget {
  const Topluluklar({super.key});

  @override
  State<Topluluklar> createState() => _TopluluklarState();
}

class _TopluluklarState extends State<Topluluklar> {
  List<Map<String, String>> topluluklar = [];
  List<Map<String, String>> filteredTopluluklar = [];

  @override
  void initState() {
    super.initState();
    _fetchTopluluklar();
  }

  Future<void> _fetchTopluluklar() async {
    // Topluluklar koleksiyonundan verileri çekme
    final query = QueryBuilder(ParseObject('Topluluklar'));
    final response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        topluluklar = response.results!.map<Map<String, String>>((result) {
          return {
            'logo': result.get<String>('logo') ?? '',
            'danisman': result.get<String>('danisman') ?? '',
            'baskan': result.get<String>('baskan') ?? '',
            'toplulukadi': result.get<String>('toplulukadi') ?? '',
            'kolu': result.get<String>('kolu') ?? '',
          };
        }).toList();
        filteredTopluluklar = List.from(topluluklar);
      });
    } else {
      print('Topluluklar çekilemedi: ${response.error?.message}');
    }
  }

  void _filterTopluluklar(String searchText) {
    setState(() {
      filteredTopluluklar = topluluklar
          .where((topluluk) => topluluk['toplulukadi']!
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  )),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 42, 98, 154)),
              ),
              title: TextField(
                cursorHeight: MediaQuery.of(context).size.height * 0.02,
                controller: searchController,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.042),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  prefixIcon: GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.search_rounded,
                          color: Colors.white)),
                  hintText: 'Topluluk ara...',
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(137, 255, 255, 255),
                      height:
                          MediaQuery.of(context).size.height * 0.00000000001),
                  border: InputBorder.none,
                ),
                onChanged: _filterTopluluklar,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 42, 98, 154),
            body: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              itemCount: filteredTopluluklar.length,
              itemBuilder: (BuildContext context, int index) {
                final topluluk = filteredTopluluklar[index];
                String? toplulukAdi = topluluk['toplulukadi'];
                String? logoURL = topluluk['logo'];
                String? danisman = topluluk['danisman'];
                String? baskan = topluluk['baskan'];
                String? kol = topluluk['kolu'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ToplulukDetay(
                            toplulukAdi: toplulukAdi ?? "",
                            toplulukDanismani: danisman ?? "",
                            toplulukBaskani: baskan ?? "",
                            toplulukKolu: kol ?? "",
                            toplulukLogo: logoURL ?? "",
                          ),
                        ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.115,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 218, 120),
                        border: Border.all(
                            color: const Color.fromARGB(255, 83, 124, 84)),
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.13)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.03),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage: logoURL != null && logoURL != "nan"
                                ? NetworkImage(logoURL)
                                : const NetworkImage(
                                    "https://unievi.firat.edu.tr/assets/front/img/firat-logo-yeni.png"),
                            backgroundColor:
                                const Color.fromARGB(0, 255, 255, 255),
                            radius: MediaQuery.of(context).size.width * 0.085,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.03),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: SingleChildScrollView(
                                child: Text(
                                  '$toplulukAdi',
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 50, 133),
                                      fontFamily: "Lalezar",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
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
