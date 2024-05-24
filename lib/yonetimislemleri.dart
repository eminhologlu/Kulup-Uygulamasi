import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulup/duyuru.dart';
import 'package:kulup/toplulukhub.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class YonetimIslemleri extends StatefulWidget {
  const YonetimIslemleri(
      {required this.toplulukAdi, required this.toplulukLogo});
  final String toplulukAdi;
  final String toplulukLogo;

  @override
  State<YonetimIslemleri> createState() => _YonetimIslemleriState();
}

class _YonetimIslemleriState extends State<YonetimIslemleri> {
  Duration duration = Duration(hours: 3);
  DateTime? selectedDateTime;
  DateFormat dateFormat = DateFormat("d MMMM yyyy EEEE", "tr_TR");
  DateFormat timeFormat = DateFormat("HH:mm");
  TextEditingController duyuruBaslik = TextEditingController();
  TextEditingController duyuruIcerik = TextEditingController();
  TextEditingController etkinlikBaslik = TextEditingController();
  TextEditingController etkinlikYer = TextEditingController();
  late String toplulukAdi;
  late String toplulukLogo;
  List<Announcement> announcements = [];
  List<Event> events = [];
  List<String> members = [];
  List<dynamic> istekler = [];
  bool isDuyuruButtonEnabled = false;
  bool isEtkinlikButtonEnabled = false;
  bool uyeVarMi = false;
  bool _isSnackBarActive = false;

  Future<void> reddetIstek(String kullaniciAdi) async {
    try {
      QueryBuilder<ParseObject> queryBuilder =
          QueryBuilder<ParseObject>(ParseObject('Topluluklar'))
            ..whereEqualTo('toplulukadi', widget.toplulukAdi);

      ParseResponse response = await queryBuilder.query();
      List<ParseObject> topluluklar =
          response.results?.cast<ParseObject>() ?? [];

      if (topluluklar.isNotEmpty) {
        ParseObject topluluk = topluluklar.first;
        List<dynamic> isteklerDynamic = topluluk.get<List>('istekler') ?? [];

        // isteği sil
        List<String> istekler =
            isteklerDynamic.map((item) => item.toString()).toList();
        istekler.remove(kullaniciAdi);

        topluluk.set('istekler', istekler);
        await topluluk.save();

        // istekleri güncelle
        setState(() {
          _fetchIstekler();
        });
      }
    } catch (e) {
      print('İstek reddedilirken hata oluştu: $e');
    }
  }

  Future<void> onaylaIstek(String kullaniciAdi) async {
    try {
      ParseObject? uyelik = await _getUyelik(kullaniciAdi);

      if (uyelik != null) {
        List<dynamic> uyeliklerDynamic = uyelik.get<List>('uyelikler') ?? [];
        List<String> uyelikler = uyeliklerDynamic.cast<String>();

        // üyelik ekle
        if (!uyelikler.contains(widget.toplulukAdi)) {
          uyelikler.add(widget.toplulukAdi);
          uyelik.set('uyelikler', uyelikler);
          await uyelik.save();
        }
      } else {
        // yeni üyelik
        if (kullaniciAdi.isNotEmpty) {
          ParseObject yeniUyelik = ParseObject('Uyelikler')
            ..set('username', kullaniciAdi)
            ..set('uyelikler', [widget.toplulukAdi]);
          await yeniUyelik.save();
        } else {
          throw Exception('Kullanıcı adı boş olamaz.');
        }
      }

      QueryBuilder<ParseObject> queryBuilder =
          QueryBuilder<ParseObject>(ParseObject('Topluluklar'))
            ..whereEqualTo('toplulukadi', widget.toplulukAdi);

      ParseResponse response = await queryBuilder.query();
      List<ParseObject> topluluklar =
          response.results?.cast<ParseObject>() ?? [];

      if (topluluklar.isNotEmpty) {
        ParseObject topluluk = topluluklar.first;
        List<dynamic> isteklerDynamic = topluluk.get<List>('istekler') ?? [];

        List<String> istekler =
            isteklerDynamic.map((item) => item.toString()).toList();

        // isteği sil
        istekler.remove(kullaniciAdi);

        topluluk.set('istekler', istekler);
        await topluluk.save();

        // istekleri güncelle, üyeleri güncelle
        setState(() {
          _fetchIstekler();
          _fetchMembers(widget.toplulukAdi);
        });
      }
    } catch (e) {
      print('İstek onaylanırken hata oluştu: $e');
    }
  }

  Future<ParseObject?> _getUyelik(String kullaniciAdi) async {
    try {
      QueryBuilder<ParseObject> queryBuilder =
          QueryBuilder<ParseObject>(ParseObject('Uyelikler'))
            ..whereEqualTo('username', kullaniciAdi);

      ParseResponse response = await queryBuilder.query();
      List<ParseObject> results = response.results!.cast<ParseObject>();

      if (results.isNotEmpty) {
        return results.first;
      } else {
        return null;
      }
    } catch (e) {
      print('Uyelik sorgulanırken hata oluştu: $e');
      return null;
    }
  }

  Future<void> _fetchIstekler() async {
    try {
      ParseResponse response = await ParseObject('Topluluklar').getAll();

      if (response.success && response.results != null) {
        List<ParseObject> topluluklar = response.results!.cast<ParseObject>();

        ParseObject topluluk = topluluklar.firstWhere(
          (topluluk) =>
              topluluk.get<String>('toplulukadi') == widget.toplulukAdi,
          orElse: () => ParseObject('Null'),
        );

        setState(() {
          istekler = topluluk.get<List>('istekler') ?? [];
        });
      } else {
        throw Exception('Topluluklar alınırken bir hata oluştu.');
      }
    } catch (e) {
      print('Topluluk istekleri alınırken hata oluştu: $e');
    }
  }

  Future<void> removeMembership(
      String username, String communityName, context) async {
    if (_isSnackBarActive) {
      return; // Eğer bir SnackBar zaten gösteriliyorsa işlemi durdur
    }

    final ParseObject memberships = ParseObject('Uyelikler');
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(memberships);
    query.whereEqualTo('username', username);

    try {
      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        final ParseObject userMembership = response.results!.first;
        List<dynamic> membershipsList = userMembership.get('uyelikler') ?? [];

        // Yönetici kontrolü
        final QueryBuilder<ParseUser> adminQuery =
            QueryBuilder<ParseUser>(ParseUser.forQuery());
        adminQuery.whereEqualTo('username', username);
        adminQuery.whereEqualTo('yoneticilikler', communityName);
        final ParseResponse adminResponse = await adminQuery.query();

        if (adminResponse.success && adminResponse.results != null) {
          // Kullanıcı yönetici ise uyarı göster
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                backgroundColor: const Color.fromARGB(255, 255, 127, 62),
                content: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "$username bu topluluğun yöneticisi olduğu için silinemez.",
                    style: TextStyle(
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.05),
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
          // Topluluğu üyelikler listesinden kaldır
          membershipsList.remove(communityName);

          userMembership.set('uyelikler', membershipsList);
          final ParseResponse updatedMembership = await userMembership.save();

          if (updatedMembership.success) {
            ScaffoldMessenger.of(context)
                .removeCurrentSnackBar(); // Mevcut SnackBar'ı kaldır

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                  backgroundColor: const Color.fromARGB(255, 255, 127, 62),
                  content: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$username topluluktan atıldı.",
                      style: TextStyle(
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                ))
                .closed
                .then((_) {
              _isSnackBarActive =
                  false; // SnackBar kapatıldığında kontrolü geri çevir
            });
            _fetchMembers(communityName);
          } else {
            print('Üyelik kaldırılamadı: ${updatedMembership.error?.message}');
          }
        }
      } else {
        print('Kullanıcı bulunamadı');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> _fetchMembers(String toplulukAdi) async {
    final query = QueryBuilder(ParseObject('Uyelikler'))
      ..whereEqualTo('uyelikler', toplulukAdi);

    final response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        uyeVarMi = true;
        members = (response.results as List<ParseObject>)
            .map((user) => user.get<String>('username')!)
            .toList();
      });
    } else {
      print('Üyeler getirilirken bir hata oluştu: ${response.error!.message}');
      setState(() {
        uyeVarMi = false;
      });
    }
  }

  bool isEmptyDuyuru(bool buttonEnabled, TextEditingController controller1,
      TextEditingController controller2) {
    setState(() {
      if (controller1.text.isNotEmpty && controller2.text.isNotEmpty) {
        buttonEnabled = true;
      }
    });
    return buttonEnabled;
  }

  Future<void> _deleteAnnouncement(Announcement announcement, context) async {
    try {
      final queryBuilder = QueryBuilder(ParseObject("Duyurular"))
        ..whereEqualTo(
            "objectId",
            announcement
                .objectId); // Announcement sınıfındaki benzersiz bir alanı belirtin

      final response = await queryBuilder.query();
      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        final announcementObject = response.results!.first;
        final deleteResponse = await announcementObject.delete();
        if (deleteResponse.success) {
          setState(() {
            announcements.remove(announcement);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: const Color.fromARGB(255, 255, 127, 62),
            content: Align(
              alignment: Alignment.center,
              child: Text(
                "Duyuru başarıyla silindi.",
                style: TextStyle(
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ));
        } else {
          print(
              'Duyuru silinirken bir hata oluştu: ${deleteResponse.error!.message}');
        }
      } else {
        print('Duyuru bulunamadı');
      }
    } catch (e) {
      print('Duyuru silinirken bir hata oluştu: $e');
    }
  }

  Future<void> _deleteEvent(Event event, context) async {
    try {
      final queryBuilder = QueryBuilder(ParseObject("Etkinlikler"))
        ..whereEqualTo(
            "objectId",
            event
                .objectId); // Announcement sınıfındaki benzersiz bir alanı belirtin

      final response = await queryBuilder.query();
      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        final eventObject = response.results!.first;
        final deleteResponse = await eventObject.delete();
        if (deleteResponse.success) {
          setState(() {
            events.remove(event);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: const Color.fromARGB(255, 255, 127, 62),
            content: Align(
              alignment: Alignment.center,
              child: Text(
                "Etkinlik başarıyla silindi.",
                style: TextStyle(
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: const Color.fromARGB(255, 255, 127, 62),
            content: Align(
              alignment: Alignment.center,
              child: Text(
                "Duyuru silinirken bir hata oluştu: ${deleteResponse.error!.message}",
                style: TextStyle(
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ));
        }
      } else {
        print('Duyuru bulunamadı');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color.fromARGB(255, 255, 127, 62),
        content: Align(
          alignment: Alignment.center,
          child: Text(
            "Duyuru silinirken bir hata oluştu: $e",
            style: TextStyle(
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
      ));
    }
  }

  void _clearFields() {
    setState(() {
      etkinlikBaslik.clear();
      etkinlikYer.clear();
      selectedDateTime = null;
    });
  }

  void _clearDuyuruFields() {
    setState(() {
      duyuruBaslik.clear();
      duyuruIcerik.clear();
    });
  }

  Future<void> _fetchAnnouncements(String communityName) async {
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Duyurular'))
      ..whereEqualTo('toplulukadi', communityName)
      ..orderByDescending('createdAt');

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      setState(() {
        announcements = response.results!
            .map((result) => Announcement.fromParseObject(result))
            .toList();
      });
    }
  }

  Future<void> _fetchEvents(String communityName) async {
    final queryBuilder = QueryBuilder(ParseObject('Etkinlikler'))
      ..whereEqualTo('toplulukadi', communityName)
      ..orderByAscending('etkinliktarih');

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      setState(() {
        events = response.results!
            .map((result) => Event.fromParseObject(result))
            .toList();
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime?.year ?? DateTime.now().year,
          selectedDateTime?.month ?? DateTime.now().month,
          selectedDateTime?.day ?? DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
          0,
        );
      });
    }
  }

  Future<void> _saveEvent(context) async {
    final parseObject = ParseObject('Etkinlikler');
    parseObject.set<DateTime>('etkinliktarih', selectedDateTime!);
    parseObject.set<String>('etkinlikbasligi', etkinlikBaslik.text.trim());
    parseObject.set<String>('etkinlikyeri', etkinlikYer.text.trim());
    parseObject.set<String>('toplulukadi', toplulukAdi);

    try {
      final response = await parseObject.save();
      if (response.success) {
        _clearFields();
        _fetchEvents(toplulukAdi);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 127, 62),
          content: Align(
            alignment: Alignment.center,
            child: Text(
              "Etkinlik başarıyla kaydedildi.",
              style: TextStyle(
                  fontFamily: "Lalezar",
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 127, 62),
          content: Align(
            alignment: Alignment.center,
            child: Text(
              "Etkinlik kaydedilirken bir hata oluştu: ${response.error!.message}",
              style: TextStyle(
                  fontFamily: "Lalezar",
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color.fromARGB(255, 255, 127, 62),
        content: Align(
          alignment: Alignment.center,
          child: Text(
            "Etkinlik kaydedilirken bir hata oluştu: $e",
            style: TextStyle(
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
      ));
    }
  }

  Future<void> _saveDuyuru(context) async {
    final parseObject = ParseObject('Duyurular');
    parseObject.set<DateTime>('duyurutarih', DateTime.now());
    parseObject.set<String>('duyurubaslik', duyuruBaslik.text.trim());
    parseObject.set<String>('duyurutext', duyuruIcerik.text.trim());
    parseObject.set<String>('toplulukadi', toplulukAdi);

    try {
      final response = await parseObject.save();
      if (response.success) {
        _clearDuyuruFields();
        _fetchAnnouncements(toplulukAdi);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 127, 62),
          content: Align(
            alignment: Alignment.center,
            child: Text(
              "Duyuru başarıyla kaydedildi.",
              style: TextStyle(
                  fontFamily: "Lalezar",
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 127, 62),
          content: Align(
            alignment: Alignment.center,
            child: Text(
              "Duyuru kaydedilirken bir hata oluştu: ${response.error!.message}",
              style: TextStyle(
                  fontFamily: "Lalezar",
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color.fromARGB(255, 255, 127, 62),
        content: Align(
          alignment: Alignment.center,
          child: Text(
            'Duyuru kaydedilirken bir hata oluştu: $e',
            style: TextStyle(
                fontFamily: "Lalezar",
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    toplulukAdi = widget.toplulukAdi;
    toplulukLogo = widget.toplulukLogo;
    _fetchAnnouncements(toplulukAdi);
    _fetchEvents(toplulukAdi);
    _fetchMembers(toplulukAdi);
    _fetchIstekler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 6,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 42, 98, 154),
            appBar: AppBar(
              bottom: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: const Color.fromARGB(255, 42, 98, 154),
                dividerColor: const Color.fromARGB(255, 42, 98, 154),
                unselectedLabelColor: const Color.fromARGB(255, 42, 98, 154),
                indicatorColor: const Color.fromARGB(255, 255, 218, 120),
                tabs: [
                  Tab(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.07,
                      width: MediaQuery.of(context).size.width * 0.26,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Duyuru Yap",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.07,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Etkinlik Oluştur",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.07,
                      width: MediaQuery.of(context).size.height * 0.14,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Duyurular",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.07,
                      width: MediaQuery.of(context).size.height * 0.14,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Etkinlikler",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.07,
                      width: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Üyeler",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.07,
                      width: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Text(
                        textAlign: TextAlign.center,
                        "İstekler",
                        style: TextStyle(
                            fontFamily: "Lalezar",
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                ],
              ),
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  toplulukAdi,
                  style: TextStyle(
                      overflow: TextOverflow.fade,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: "Lalezar",
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 42, 98, 154),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.04),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Duyuru Başlığı",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 218, 120),
                              fontFamily: "Lalezar",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            onChanged: (val) {
                              isEmptyDuyuru(isDuyuruButtonEnabled, duyuruBaslik,
                                  duyuruIcerik);
                            },
                            maxLength: 60,
                            controller: duyuruBaslik,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 127, 62),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontFamily: "Lalezar"),
                            cursorHeight:
                                MediaQuery.of(context).size.height * 0.02,
                            cursorColor: Color.fromARGB(255, 255, 127, 62),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Maksimum 60 karakter",
                              hintStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                              contentPadding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.01,
                                  right: MediaQuery.of(context).size.height *
                                      0.01),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.06),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.04)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.07),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.045)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          "Duyuru İçeriği",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 218, 120),
                              fontFamily: "Lalezar",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.white,
                                width:
                                    MediaQuery.of(context).size.width * 0.01),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width * 0.02)),
                          ),
                          child: TextField(
                            onChanged: (val) {
                              isEmptyDuyuru(isDuyuruButtonEnabled, duyuruBaslik,
                                  duyuruIcerik);
                            },
                            maxLength: 1000,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: duyuruIcerik,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 127, 62),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontFamily: "Lalezar"),
                            cursorHeight:
                                MediaQuery.of(context).size.height * 0.02,
                            cursorColor: Color.fromARGB(255, 255, 127, 62),
                            decoration: InputDecoration(
                              hintText: "Maksimum 1000 karakter",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.01,
                                  right: MediaQuery.of(context).size.height *
                                      0.01),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        FilledButton(
                          onPressed: duyuruBaslik.text.isEmpty ||
                                  duyuruIcerik.text.isEmpty
                              ? null
                              : () {
                                  _saveDuyuru(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                          style: FilledButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 218, 120),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.05)),
                          child: Text(
                            "Duyuru Yap",
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 98, 154),
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.04),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Etkinlik Başlığı",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 218, 120),
                              fontFamily: "Lalezar",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            onChanged: (val) {
                              isEmptyDuyuru(isEtkinlikButtonEnabled,
                                  etkinlikBaslik, etkinlikYer);
                            },
                            maxLength: 60,
                            controller: etkinlikBaslik,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 127, 62),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontFamily: "Lalezar"),
                            cursorHeight:
                                MediaQuery.of(context).size.height * 0.02,
                            cursorColor: Color.fromARGB(255, 255, 127, 62),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Maksimum 60 karakter",
                              hintStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04),
                              contentPadding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.01,
                                  right: MediaQuery.of(context).size.height *
                                      0.01),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.06),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.04)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.07),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.04)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          "Etkinlik Yeri",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 218, 120),
                              fontFamily: "Lalezar",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            onChanged: (val) {
                              isEmptyDuyuru(isEtkinlikButtonEnabled,
                                  etkinlikBaslik, etkinlikYer);
                            },
                            maxLength: 60,
                            controller: etkinlikYer,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 127, 62),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontFamily: "Lalezar"),
                            cursorHeight:
                                MediaQuery.of(context).size.height * 0.02,
                            cursorColor: Color.fromARGB(255, 255, 127, 62),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Maksimum 60 karakter",
                              hintStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04),
                              contentPadding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.01,
                                  right: MediaQuery.of(context).size.height *
                                      0.01),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.06),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.04)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.06),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.04)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        FilledButton(
                          onPressed: () async {
                            _selectDate();
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 218, 120),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.5,
                                  MediaQuery.of(context).size.height * 0.05)),
                          child: Text(
                            "Tarih Seç",
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 98, 154),
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            _selectTime();
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 218, 120),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.5,
                                  MediaQuery.of(context).size.height * 0.05)),
                          child: Text(
                            "Saat Seç",
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 98, 154),
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          "Seçilen Tarih ve Saat",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 218, 120),
                              fontFamily: "Lalezar",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: TextField(
                            readOnly: true,
                            maxLength: 60,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 127, 62),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontFamily: "Lalezar"),
                            cursorHeight:
                                MediaQuery.of(context).size.height * 0.02,
                            cursorColor: Color.fromARGB(255, 255, 127, 62),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.date_range_rounded,
                                color: Color.fromARGB(255, 255, 127, 62),
                              ),
                              counterText: "",
                              hintText: selectedDateTime != null
                                  ? selectedDateTime.toString().substring(0, 16)
                                  : 'Tarih seçilmedi',
                              hintStyle: TextStyle(
                                  height: MediaQuery.of(context).size.width *
                                      0.0065,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                              contentPadding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.004,
                                  left:
                                      MediaQuery.of(context).size.height * 0.01,
                                  right: MediaQuery.of(context).size.height *
                                      0.01),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.06),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.04)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.07),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.04)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                        ),
                        FilledButton(
                          onPressed: etkinlikBaslik.text.isEmpty ||
                                  etkinlikYer.text.isEmpty ||
                                  selectedDateTime == null
                              ? null
                              : () {
                                  _saveEvent(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                          style: FilledButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 218, 120),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.5,
                                  MediaQuery.of(context).size.height * 0.05)),
                          child: Text(
                            "Etkinlik Oluştur",
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 98, 154),
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                announcements.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        itemCount: announcements.length,
                        itemBuilder: (BuildContext context, int index) {
                          final announcement = announcements[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Duyuru(
                                      duyurubaslik: announcement.title,
                                      duyurutext: announcement.content,
                                      toplulukLogo: toplulukLogo,
                                    ),
                                  ));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 218, 120),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 255, 218, 120)),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.13)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.005),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              foregroundImage: toplulukLogo !=
                                                      "nan"
                                                  ? NetworkImage(toplulukLogo)
                                                  : const NetworkImage(
                                                      "https://unievi.firat.edu.tr/assets/front/img/firat-logo-yeni.png"),
                                              backgroundColor: Color.fromARGB(
                                                  0, 255, 255, 255),
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.025),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.62,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                      announcement.title,
                                                      style: TextStyle(
                                                          fontFamily: "Lalezar",
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 42, 98, 154),
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.06),
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.11,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromARGB(255, 42, 98, 154)),
                                      child: IconButton(
                                          onPressed: () {
                                            _deleteAnnouncement(
                                                announcement, context);
                                          },
                                          icon: const Icon(
                                            Icons.delete_rounded,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.06,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 42, 98, 154),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 42, 98, 154)),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0035),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          announcement.date.toString(),
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 218, 120),
                                              fontFamily: "Lalezar"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.02,
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: Color.fromARGB(255, 79, 93, 154),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.1),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Henüz hiç duyuru yapılmamış.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06),
                          ),
                        ),
                      ),
                events.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        itemCount: events.length,
                        itemBuilder: (BuildContext context, int index) {
                          final event = events[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.27,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 218, 120),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 255, 218, 120)),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05)),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: Text(
                                                event.title,
                                                overflow: TextOverflow.fade,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 42, 98, 154),
                                                    fontFamily: "Lalezar",
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Text(
                                              'Etkinlik Yeri',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 50, 133),
                                                  fontFamily: "Lalezar",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: Text(
                                                event.location,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Lalezar",
                                                    color: const Color.fromARGB(
                                                        255, 42, 98, 154),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Text(
                                              'Tarih',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 50, 133),
                                                  fontFamily: "Lalezar",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05),
                                            ),
                                            Text(
                                              dateFormat.format(event.date),
                                              style: TextStyle(
                                                  fontFamily: "Lalezar",
                                                  color: const Color.fromARGB(
                                                      255, 42, 98, 154),
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Text(
                                              'Saat',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 50, 133),
                                                  fontFamily: "Lalezar",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05),
                                            ),
                                            Text(
                                              timeFormat.format(
                                                  event.date.add(duration)),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Lalezar",
                                                  color: const Color.fromARGB(
                                                      255, 42, 98, 133),
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.11,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromARGB(255, 42, 98, 154)),
                                      child: IconButton(
                                          onPressed: () {
                                            _deleteEvent(event, context);
                                          },
                                          icon: const Icon(
                                            Icons.delete_rounded,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: Color.fromARGB(0, 255, 219, 120),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.1),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Henüz hiç etkinlik yok.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06),
                          ),
                        ),
                      ),
                uyeVarMi
                    ? ListView.separated(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.015),
                        itemCount: members.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 218, 120),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 255, 218, 120)),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.005),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.62,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  members[index],
                                                  style: TextStyle(
                                                      fontFamily: "Lalezar",
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 42, 98, 154),
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.11,
                                      width: MediaQuery.of(context).size.width *
                                          0.11,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromARGB(255, 42, 98, 154)),
                                      child: IconButton(
                                          onPressed: () {
                                            removeMembership(members[index],
                                                toplulukAdi, context);
                                          },
                                          icon: const Icon(
                                            Icons.delete_rounded,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: Color.fromARGB(0, 79, 93, 154),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.1),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Toplulukta üye yok.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06),
                          ),
                        ),
                      ),
                istekler.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.015),
                        itemCount: istekler.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.32,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 218, 120),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 255, 218, 120)),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.005),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.62,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  istekler[index],
                                                  style: TextStyle(
                                                      fontFamily: "Lalezar",
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 42, 98, 154),
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromARGB(
                                                  255, 42, 98, 154)),
                                          child: IconButton(
                                              onPressed: () {
                                                onaylaIstek(istekler[index]);
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .check_circle_outline_rounded,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              )),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromARGB(
                                                  255, 42, 98, 154)),
                                          child: IconButton(
                                              onPressed: () {
                                                reddetIstek(istekler[index]);
                                              },
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: Color.fromARGB(255, 79, 93, 154),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.1),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Hiç istek yok.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Lalezar",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
