import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Auth {
  static bool isLoggedIn = false;

  Future<bool> doUserRegistration(
      context, String username, String email, String password) async {
    final user = ParseUser(username, password, email);
    var response = await user.signUp();

    if (response.success) {
      return true;
    } else {
      showError(context, response.error!.message);
      return false;
    }
  }

  void doUserLogin(context, String username, String password) async {
    final user = ParseUser(username, password, null);
    var response = await user.login();
    if (response.success) {
      showSuccess("Başarıyla giriş yapıldı!");
      isLoggedIn = true;
    } else {
      showError(context, response.error!.message);
    }
  }

  void doUserLogout(context) async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();
    if (response.success) {
      showSuccess("Başarıyla çıkış yapıldı!");
    } else {
      showError(context, response.error!.message);
    }
  }

  void showError(context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color.fromARGB(255, 79, 93, 154),
      content: Align(
        alignment: Alignment.center,
        child: Text(
          errorMessage,
          style: TextStyle(
              fontFamily: "Lalezar",
              fontSize: MediaQuery.of(context).size.width * 0.05),
        ),
      ),
    ));
  }

  void showSuccess(context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color.fromARGB(255, 79, 93, 154),
      content: Align(
        alignment: Alignment.center,
        child: Text(
          "Kayıt başarılı.",
          style: TextStyle(
              fontFamily: "Lalezar",
              fontSize: MediaQuery.of(context).size.width * 0.05),
        ),
      ),
    ));
  }

  void showSuccessL(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.width * 0.4,
          child: AlertDialog(
            title: const Text("Tebrikler!"),
            content: const Text("Giriş başarılı!"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.offline_pin_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
