import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Topluluklar extends StatefulWidget {
  const Topluluklar({super.key});

  @override
  State<Topluluklar> createState() => _TopluluklarState();
}

class _TopluluklarState extends State<Topluluklar> {
  final TextEditingController searchController = TextEditingController();
  final List<String> itemList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
              flexibleSpace: Container(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 25, 139, 28)),
              ),
              title: TextField(
                cursorHeight: MediaQuery.of(context).size.height * 0.02,
                controller: searchController,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Lalezar",
                    fontSize: MediaQuery.of(context).size.width * 0.042),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  prefixIcon: GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.search_rounded, color: Colors.white)),
                  hintText: 'Topluluk ara...',
                  hintStyle: TextStyle(
                      color: Color.fromARGB(137, 255, 255, 255),
                      height:
                          MediaQuery.of(context).size.height * 0.00000000001),
                  border: InputBorder.none,
                ),
                onChanged: (value) {},
              ),
            ),
            backgroundColor: Color.fromARGB(255, 25, 139, 28),
            body: ListView.separated(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.05)
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: Color.fromARGB(255, 25, 139, 28),radius: MediaQuery.of(context).size.width*0.1,),
                        Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03),
                          child: Text('Entry LKASDLKŞ\nASJDKgghghŞL KAJDL ${itemList[index]}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            )),
      ),
    );
  }
}
