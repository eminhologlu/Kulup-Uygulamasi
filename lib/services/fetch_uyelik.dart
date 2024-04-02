import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UyelikCek {
  Future<List<String>> fetchTopluluklarIsim() async {
    final ParseUser user = await ParseUser.currentUser() as ParseUser;
    final ParseObject memberships = ParseObject('Uyelikler');
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(memberships);
    query.whereEqualTo('username', user.username);
    final ParseResponse response = await query.query();
    if (response.success && response.results != null) {
      List<dynamic> rawUyelikler =
          response.results!.first.get<List>('uyelikler') ?? [];
      // String listesi oluşturmak için dönüşüm yapın
      List<String> uyelikler =
          rawUyelikler.map((item) => item.toString()).toList();
      return uyelikler;
    }
    return [];
  }

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
}
