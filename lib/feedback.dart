import 'package:flutter/material.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: Text("Geri dönüş bırak"),
      ),
      body: Column(
        children: [
          TextField(),
          TextField(),
          FilledButton(onPressed: () {}, child: Text("Gönder")),
        ],
      ),
    );
  }
}
