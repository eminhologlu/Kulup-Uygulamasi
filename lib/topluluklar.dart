import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Topluluklar extends StatefulWidget {
  const Topluluklar({super.key});

  @override
  State<Topluluklar> createState() => _TopluluklarState();
}

class _TopluluklarState extends State<Topluluklar> {
  late List<String> topluluklar = [];
  late Map<String, String> logolar = {};
  late List<String> filteredTopluluklar = [];

  @override
  void initState() {
    super.initState();
    _loadTopluluklar();
  }

  Future<void> _loadTopluluklar() async {
    String jsonString =
        await rootBundle.loadString('assets/json/topluluklar.json');
    Map<String, dynamic> data = json.decode(jsonString);
    List<String> topluluklarList = [];
    Map<String, String> logolarMap =
        {}; // Logo URL'lerini saklamak için boş bir Map oluşturuyoruz
    data['Sayfa1'].forEach((key, value) {
      topluluklarList.add(value['TOPLULUKLAR']);
      logolarMap[value['TOPLULUKLAR']] = value['LOGO'];
    });
    setState(() {
      topluluklar = topluluklarList;
      logolar = logolarMap; // Oluşturduğumuz Map'i setState içinde atıyoruz
      filteredTopluluklar = topluluklar;
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
                    color: Color.fromARGB(255, 25, 139, 28)),
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
                onChanged: (value) {
                  setState(() {
                    filteredTopluluklar = _filterTopluluklar(value);
                  });
                },
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 25, 139, 28),
            body: ListView.separated(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              itemCount: filteredTopluluklar.length,
              itemBuilder: (BuildContext context, int index) {
                final toplulukAdi = filteredTopluluklar[index];
                String? logoURL = logolar[toplulukAdi];
                return Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
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
                            child: Text(
                              '${toplulukAdi}',
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            )),
      ),
    );
  }

  List<String> _filterTopluluklar(String query) {
    query = query.toLowerCase();
    return topluluklar
        .where((toplulukAdi) => toplulukAdi.toLowerCase().contains(query))
        .toList();
  }
}
