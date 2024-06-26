import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulup/duyuru.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ToplulukHub extends StatefulWidget {
  const ToplulukHub({required this.toplulukAdi, required this.toplulukLogo});
  final String toplulukAdi;
  final String toplulukLogo;

  @override
  State<ToplulukHub> createState() => _ToplulukHubState();
}

class Announcement {
  final String title;
  final String content;
  final DateTime date;
  final String objectId;

  Announcement(
      {required this.title,
      required this.content,
      required this.date,
      required this.objectId});

  factory Announcement.fromParseObject(ParseObject object) {
    return Announcement(
      objectId: object.get("objectId"),
      title: object.get('duyurubaslik') ?? '',
      content: object.get('duyurutext') ?? '',
      date: object.get<DateTime>('duyurutarih') ?? DateTime.now(),
    );
  }
}

class Event {
  final String title;
  final String content;
  final DateTime date;
  final String location;
  final String objectId;

  Event(
      {required this.title,
      required this.content,
      required this.date,
      required this.location,
      required this.objectId});

  factory Event.fromParseObject(ParseObject object) {
    return Event(
      objectId: object.get('objectId'),
      title: object.get('etkinlikbasligi') ?? '',
      content: object.get('etkinlikaciklama') ?? '',
      date: object.get<DateTime>('etkinliktarih') ?? DateTime.now(),
      location: object.get('etkinlikyeri') ?? '',
    );
  }
}

class _ToplulukHubState extends State<ToplulukHub> {
  Duration duration = Duration(hours: 3);
  DateFormat dateFormat = DateFormat("d MMMM yyyy EEEE", "tr_TR");
  DateFormat timeFormat = DateFormat("HH:mm");
  List<Announcement> announcements = [];
  List<Event> events = [];

  Future<void> _fetchAnnouncements(String communityName) async {
    final queryBuilder = QueryBuilder(ParseObject('Duyurular'))
      ..whereEqualTo('toplulukadi', communityName);

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
      ..whereEqualTo('toplulukadi', communityName);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      setState(() {
        events = response.results!
            .map((result) => Event.fromParseObject(result))
            .toList();
      });
    }
  }

  late String toplulukAdi;
  late String toplulukLogo;
  @override
  void initState() {
    super.initState();
    toplulukAdi = widget.toplulukAdi;
    toplulukLogo = widget.toplulukLogo;
    _fetchAnnouncements(toplulukAdi);
    _fetchEvents(toplulukAdi);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 42, 98, 154),
          appBar: AppBar(
            bottom: TabBar(
              labelColor: const Color.fromARGB(255, 42, 98, 154),
              dividerColor: const Color.fromARGB(255, 42, 98, 154),
              unselectedLabelColor: const Color.fromARGB(255, 42, 98, 154),
              indicatorColor: const Color.fromARGB(255, 255, 218, 120),
              tabs: [
                Tab(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.07,
                    width: MediaQuery.of(context).size.height * 0.15,
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
                    width: MediaQuery.of(context).size.height * 0.15,
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
                    width: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.03),
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Forum",
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
                    color: Colors.white,
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
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 218, 120),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 255, 218, 120)),
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.13)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.005),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        foregroundImage: toplulukLogo != "nan"
                                            ? NetworkImage(toplulukLogo)
                                            : const NetworkImage(
                                                "https://unievi.firat.edu.tr/assets/front/img/firat-logo-yeni.png"),
                                        backgroundColor: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.09,
                                      ),
                                      Padding(
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
                                              0.7,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              child: Text(
                                                announcement.title,
                                                style: TextStyle(
                                                    fontFamily: "Lalezar",
                                                    color: const Color.fromARGB(
                                                        255, 42, 98, 154),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06),
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 42, 98, 154),
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
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 218, 120),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 255, 218, 120)),
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.05)),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.015,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          event.title,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 42, 98, 154),
                                              fontFamily: "Lalezar",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        'Etkinlik Yeri',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 50, 133),
                                            fontFamily: "Lalezar",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          event.location,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Lalezar",
                                              color: const Color.fromARGB(
                                                  255, 42, 98, 154),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        'Tarih',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 50, 133),
                                            fontFamily: "Lalezar",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                      Text(
                                        dateFormat.format(event.date),
                                        style: TextStyle(
                                            fontFamily: "Lalezar",
                                            color: const Color.fromARGB(
                                                255, 42, 98, 133),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        'Saat',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 50, 133),
                                            fontFamily: "Lalezar",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                      Text(
                                        timeFormat
                                            .format(event.date.add(duration)),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Lalezar",
                                            color: const Color.fromARGB(
                                                255, 42, 98, 154),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        color: Color.fromARGB(255, 25, 139, 28),
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
              Center(
                  child: Text(
                "ÇOK YAKINDA!",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.1),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
