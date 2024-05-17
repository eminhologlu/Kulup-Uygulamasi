import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kulup/login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Ayarlar extends StatefulWidget {
  const Ayarlar({super.key});

  @override
  State<Ayarlar> createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();
    if (response.success) {
      setState(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      });
    } else {
      print(response.error!.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 79, 93, 154),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
      ),
      backgroundColor: const Color.fromARGB(255, 79, 93, 154),
      body: Center(
        child: Column(
          children: [
            FilledButton(
              onPressed: () async {
                doUserLogout();
              },
              style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 218, 83, 83),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.05)),
              child: Text(
                "Çıkış Yap",
                style: TextStyle(
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
