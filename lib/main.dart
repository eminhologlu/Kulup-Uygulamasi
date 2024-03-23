import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kulup/loading.dart';
import 'package:kulup/login.dart';
import 'package:kulup/uyelikler.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> main() async {
  initializeDateFormatting('tr_TR', null);
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = dotenv.env['KEY_APP_ID'].toString();
  final keyClientKey = dotenv.env['KEY_CLIENT'].toString();
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shequ',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 0)), // 5 saniye bekle
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen(); // Bekleme ekranını göster
          } else {
            return LoginPage(); // Bekleme süresi dolduktan sonra giriş sayfasını göster
          }
        },
      ),
    );
  }
}
