import 'package:flutter/material.dart';
import 'front_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Vollkoran'),
      home: FrontPage()
    );
  }
}

String HTTP = 'http://aa9ac5afe4ab.ngrok.io'; //http request sent to the Flask Web