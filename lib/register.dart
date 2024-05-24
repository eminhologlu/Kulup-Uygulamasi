import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulup/services/user_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
          backgroundColor: const Color.fromARGB(255, 42, 98, 154),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 42, 98, 154),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Platforma",
                  style: TextStyle(
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.12,
                    color: Color.fromARGB(255, 255, 218, 120),
                  ),
                ),
                Text(
                  "Kaydol!",
                  style: TextStyle(
                    height: MediaQuery.of(context).size.width * 0.0001,
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                  buildTextField(usernameController, 20, false),
                  buildSizedBox(),
                  Text(
                    "Eposta",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 218, 120),
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                  buildTextField(emailController, 30, false),
                  buildSizedBox(),
                  Text(
                    "Öğrenci No",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 218, 120),
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                  buildTextField(studentidController, 30, false),
                  buildSizedBox(),
                  Text(
                    "Şifre",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 218, 120),
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                  buildTextField(passwordController, 20, true),
                  buildSizedBox(),
                  Text(
                    "Şifre Tekrarı",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 218, 120),
                        fontFamily: "Lalezar",
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                  buildTextField(repasswordController, 20, true),
                  buildSizedBox(),
                  FilledButton(
                    onPressed: () async {
                      if (usernameController.text.isEmpty |
                          emailController.text.isEmpty |
                          studentidController.text.isEmpty |
                          passwordController.text.isEmpty |
                          repasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 127, 62),
                          content: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Bütün bilgileri eksiksiz doldurmalısın.",
                              style: TextStyle(
                                  fontFamily: "Lalezar",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                            ),
                          ),
                        ));
                      } else if (passwordController.text !=
                          repasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 127, 62),
                          content: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Şifreler uyuşmuyor.",
                              style: TextStyle(
                                  fontFamily: "Lalezar",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                            ),
                          ),
                        ));
                      } else if (await Auth().doUserRegistration(
                          context,
                          usernameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text.trim())) {
                        Auth().showSuccess(context);
                        Navigator.pop(context);
                      }
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 218, 120),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                            MediaQuery.of(context).size.height * 0.05)),
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                          color: Color.fromARGB(255, 42, 98, 154),
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearControllers() {
    usernameController.clear();
    emailController.clear();
    studentidController.clear();
    passwordController.clear();
    repasswordController.clear();
  }

  Widget buildSizedBox() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
    );
  }

  Widget buildTextField(
      TextEditingController controller, int uzunluk, bool sifremi) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.049,
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextField(
        obscureText: sifremi,
        controller: controller,
        inputFormatters: [LengthLimitingTextInputFormatter(uzunluk)],
        style: TextStyle(
            color: Color.fromARGB(255, 255, 127, 62),
            fontSize: MediaQuery.of(context).size.height * 0.026,
            fontFamily: "Lalezar"),
        cursorHeight: MediaQuery.of(context).size.height * 0.02,
        cursorColor: Color.fromARGB(255, 255, 127, 62),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.01),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.06),
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.04)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.06),
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.04)),
        ),
      ),
    );
  }
}
