import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kulup/register.dart';

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
        backgroundColor: Color.fromARGB(255, 25, 139, 28),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Hoş geldin!",
                      style: TextStyle(
                        height: MediaQuery.of(context).size.width * 0.0001,
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.12,
                        color: Colors.white,
                      ),
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
                          color: Colors.white,
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
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                            fontFamily: "Lalezar"),
                        cursorHeight: MediaQuery.of(context).size.height * 0.02,
                        cursorColor: Colors.black,
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
                          color: Colors.white,
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
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                            fontFamily: "Lalezar"),
                        cursorHeight: MediaQuery.of(context).size.height * 0.02,
                        cursorColor: Colors.black,
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
                                  color: Colors.grey[200]),
                            ))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    FilledButton(
                        onPressed: () {},
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(
                              fontFamily: "Lalezar",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.7,
                                MediaQuery.of(context).size.height * 0.05)))
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
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.04),
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
                        color: Colors.grey[200],
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
