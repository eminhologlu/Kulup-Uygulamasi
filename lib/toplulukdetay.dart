import 'package:flutter/material.dart';
import 'package:kulup/services/fetch_uyelik.dart';
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
  late String toplulukAdi;
  late String toplulukBaskani;
  late String toplulukDanismani;
  late String toplulukKolu;
  late String toplulukLogo;
  bool _isMember = false;
  bool _isButtonDisabled = false;
  bool _isSnackBarActive = false;

  UyelikCek uyelikcek = UyelikCek();

  List<String> topluluklar = [];
  Future<void> _initializeData() async {
    try {
      List<String> fetchedData = await uyelikcek.fetchTopluluklarIsim();
      setState(() {
        topluluklar = fetchedData;
        _isMember = topluluklar.contains(toplulukAdi);
      });
    } catch (e) {
      print('Verileri alma işlemi sırasında bir hata oluştu: $e');
    }
  }

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
                  onPressed: _isButtonDisabled ? null : _sendJoinRequest,
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

  void _sendJoinRequest() async {
    if (_isSnackBarActive) {
      return; // Eğer bir SnackBar zaten gösteriliyorsa işlemi durdur
    }
    try {
      setState(() {
        _isButtonDisabled = true; // Butonu devre dışı bırak
      });

      final currentUser = await ParseUser.currentUser();
      final String? currentUsername = currentUser?.username;

      if (currentUsername != null) {
        QueryBuilder<ParseObject> queryBuilder =
            QueryBuilder<ParseObject>(ParseObject('Topluluklar'))
              ..whereEqualTo('toplulukadi', toplulukAdi);

        ParseResponse response = await queryBuilder.query();

        if (response.results != null) {
          List<ParseObject> results = response.results!.cast<ParseObject>();

          if (results.isNotEmpty) {
            ParseObject topluluk = results.first;
            List<dynamic>? istekler = topluluk.get('istekler');

            if (istekler != null && istekler.contains(currentUsername)) {
              // Eğer istek atanlar arasında mevcut kullanıcı varsa uyarı yap
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                    backgroundColor: const Color.fromARGB(255, 34, 202, 152),
                    content: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Zaten bu topluluğa bir istek göndermişsiniz.",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.045),
                      ),
                    ),
                  ))
                  .closed
                  .then((_) {
                _isSnackBarActive =
                    false; // SnackBar kapatıldığında kontrolü geri çevir
              });
              _isSnackBarActive = true;
            } else {
              // İstek atanlar listesine mevcut kullanıcıyı ekle
              if (istekler == null) {
                istekler = [];
              }
              istekler.add(currentUsername);
              topluluk.set('istekler', istekler);

              await topluluk.save();

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                    backgroundColor: const Color.fromARGB(255, 34, 202, 152),
                    content: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Topluluğa katılma isteği başarıyla gönderildi.",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.045),
                      ),
                    ),
                  ))
                  .closed
                  .then((_) {
                _isSnackBarActive =
                    false; // SnackBar kapatıldığında kontrolü geri çevir
              });
            }
          } else {
            throw Exception('Belirtilen topluluk bulunamadı.');
          }
        } else {
          throw Exception('Topluluklar bulunamadı.');
        }
      } else {
        throw Exception('Kullanıcı adı alınamadı.');
      }
    } catch (e) {
      print('Topluluğa katılma isteği gönderilirken hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Topluluğa katılma isteği gönderilirken bir hata oluştu.'),
        ),
      );
    } finally {
      setState(() {
        _isButtonDisabled = false; // Butonu etkinleştir
      });
    }
  }
}
