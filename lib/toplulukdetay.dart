import 'package:flutter/material.dart';
import 'package:kulup/toplulukhub.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ToplulukDetay extends StatefulWidget {
  @override
  State<ToplulukDetay> createState() => _ToplulukDetayState();
  final String toplulukAdi;
  final String toplulukBaskani;
  final String toplulukDanismani;
  final String toplulukKolu;
  final String toplulukLogo;

  const ToplulukDetay({
    super.key,
    required this.toplulukAdi,
    required this.toplulukBaskani,
    required this.toplulukDanismani,
    required this.toplulukKolu,
    required this.toplulukLogo,
  });
}

class _ToplulukDetayState extends State<ToplulukDetay> {
  Future<List<Map<String, dynamic>>> fetchTopluluklar() async {
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
        return topluluklarWithLogos;
      } else {
        print('Kullanıcı bulunamadı veya üyelikler alınamadı');
      }
    } catch (e) {
      print('Hata: $e');
    }
    return [];
  }

  List<dynamic> topluluklar = [];
  bool _isMember = false;
  Future<void> _initializeData() async {
    try {
      topluluklar = await fetchTopluluklar();
      bool isMember = isUserMemberOfCommunity(toplulukAdi, topluluklar);
      setState(() {
        _isMember = isMember;
      });
    } catch (e) {
      print('Verileri alma işlemi sırasında bir hata oluştu: $e');
    }
  }

  late String toplulukAdi;
  late String toplulukBaskani;
  late String toplulukDanismani;
  late String toplulukKolu;
  late String toplulukLogo;

  @override
  void initState() {
    super.initState();
    _initializeData();
    toplulukAdi = widget.toplulukAdi;
    toplulukBaskani = widget.toplulukBaskani;
    toplulukDanismani = widget.toplulukDanismani;
    toplulukKolu = widget.toplulukKolu;
    toplulukLogo = widget.toplulukLogo;
  }

  bool isUserMemberOfCommunity(
      String communityName, List<dynamic> memberships) {
    return memberships.contains(communityName);
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
                style: TextStyle(
                    color: const Color.fromARGB(255, 216, 245, 135),
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
          _isMember
              ? FilledButton(
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
                )
              : FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.6,
                          MediaQuery.of(context).size.height * 0.05)),
                  child: Text(
                    "Toplululuğa Üye Ol",
                    style: TextStyle(
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                )
        ],
      ),
    );
  }
}
