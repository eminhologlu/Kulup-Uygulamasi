import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulup/anasayfa.dart';
import 'package:kulup/register.dart';
import 'package:kulup/services/user_auth.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 42, 98, 154),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.3),
                    child: Text(
                      "Merhaba,",
                      style: TextStyle(
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.12,
                        color: Color.fromARGB(255, 255, 218, 120),
                      ),
                    ),
                  ),
                  Text(
                    "Hoş geldin!",
                    style: TextStyle(
                      height: MediaQuery.of(context).size.width * 0.0001,
                      fontFamily: "Lalezar",
                      fontSize: MediaQuery.of(context).size.width * 0.12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Kullanıcı Adı",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 218, 120),
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.049,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: usernameController,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 127, 62),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.026,
                            fontFamily: "Lalezar"),
                        cursorHeight: MediaQuery.of(context).size.height * 0.02,
                        cursorColor: Color.fromARGB(255, 255, 127, 62),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.01),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.04)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.04)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Text(
                      "Şifre",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 218, 120),
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.049,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 127, 62),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.026,
                            fontFamily: "Lalezar"),
                        cursorHeight: MediaQuery.of(context).size.height * 0.02,
                        cursorColor: Color.fromARGB(255, 255, 127, 62),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.01),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.04)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.04)),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.43),
                        child: InkWell(
                            onTap: () {},
                            child: Text(
                              "Şifremi unuttum",
                              style: TextStyle(
                                  fontFamily: "Lalezar",
                                  color: Color.fromARGB(255, 255, 218, 120)),
                            ))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    FilledButton(
                      onPressed: () async {
                        if (usernameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 127, 62),
                            content: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Kullanıcı adı ve şifreni girmeyi unuttun.",
                                style: TextStyle(
                                    fontFamily: "Lalezar",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ),
                          ));
                        } else if (await doUserLogin()) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Anasayfa()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 218, 120),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.7,
                              MediaQuery.of(context).size.height * 0.05)),
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(
                            color: Color.fromARGB(255, 42, 98, 154),
                            fontFamily: "Lalezar",
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.002,
                decoration: BoxDecoration(color: Colors.grey[200]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "Henüz hesabın yok mu?",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 218, 120),
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: Text(
                    "Kayıt Ol",
                    style: TextStyle(
                        fontFamily: "Lalezar",
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> doUserLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final user = ParseUser(username, password, null);
    var response = await user.login();
    if (response.success) {
      Auth().showSuccessL(context);
      return true;
    } else {
      Auth().showError(context, response.error!.message);
      return false;
    }
  }
}
