import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ToplulukHub extends StatefulWidget {
  const ToplulukHub({
    required this.toplulukAdi,
  });
  final String toplulukAdi;

  @override
  State<ToplulukHub> createState() => _ToplulukHubState();
}

class _ToplulukHubState extends State<ToplulukHub> {
  late String toplulukAdi;
  @override
  void initState() {
    super.initState();
    toplulukAdi = widget.toplulukAdi;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 25, 139, 28),
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Color.fromARGB(255, 25, 139, 28),
              dividerColor: const Color.fromARGB(255, 25, 139, 28),
              unselectedLabelColor: Color.fromARGB(255, 0, 0, 0),
              indicatorColor: Color.fromARGB(255, 25, 139, 29),
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
                    fontSize: MediaQuery.of(context).size.width * 0.06),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 25, 139, 28),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ListView.separated(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 244, 236, 165),
                              border: Border.all(
                                  color: Color.fromARGB(255, 244, 236, 165)),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.05)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.005),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  radius:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          'Yönetim Hk. Yönetim Hk. Yönetim Hk. Yönetim Hk. Yönetim Hk. Yönetim Hk. Yönetim Hk.',
                                          style: TextStyle(
                                              fontFamily: "Lalezar",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
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
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "24.01.2024",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "Lalezar"),
                              ),
                            ),
                            height: MediaQuery.of(context).size.width * 0.06,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                  color: Color.fromARGB(255, 244, 236, 165)),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.02),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: Color.fromARGB(255, 25, 139, 28),
                ),
              ),
              ListView.separated(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 244, 236, 165),
                              border: Border.all(
                                  color: Color.fromARGB(255, 244, 236, 165)),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.05)),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    'Etkinlik Başlığı Başlığı Başlığı Başlığı',
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 25, 139, 28),
                                        fontFamily: "Lalezar",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                Text(
                                  'Yer',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 25, 139, 28),
                                      fontFamily: "Lalezar",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    'Atatürk Kültür Merkezi',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Lalezar",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                  ),
                                ),
                                Text(
                                  'Tarih',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 25, 139, 28),
                                      fontFamily: "Lalezar",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                Text(
                                  '24.04.2024 Cumartesi',
                                  style: TextStyle(
                                      fontFamily: "Lalezar",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                Text(
                                  'Saat',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 25, 139, 28),
                                      fontFamily: "Lalezar",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                Text(
                                  '19.00',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Lalezar",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Text(
                                      'Detaylar için tıkla.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 25, 139, 28),
                                          decoration: TextDecoration.underline,
                                          fontFamily: "Lalezar",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: Color.fromARGB(255, 25, 139, 28),
                ),
              ),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
