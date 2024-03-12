import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*0.05),
        child: AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: Color.fromARGB(255, 25, 139, 28),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 25, 139, 28),
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
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Kaydol!",
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
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
                    buildTextField(usernameController,20,false),
                    buildSizedBox(),
                    Text(
                      "Eposta",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    buildTextField(emailController, 30,false),
                    buildSizedBox(),
                    Text(
                      "Şifre",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    buildTextField(passwordController, 20,true),
                    buildSizedBox(),
                    Text(
                      "Şifre Tekrarı",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lalezar",
                          fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    buildTextField(repasswordController, 20, true),
                    buildSizedBox(),
                    FilledButton(
                        onPressed: () {},
                        child: Text(
                          "Kayıt Ol",
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
             
            ],
          ),
        ),

    );
  }

Widget buildSizedBox(){
  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    );
}

Widget buildTextField(TextEditingController controller,int uzunluk,bool sifremi){
    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.049,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        obscureText: sifremi,
                        controller: controller,
                        inputFormatters: [LengthLimitingTextInputFormatter(uzunluk)],
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
                    );
  }
}