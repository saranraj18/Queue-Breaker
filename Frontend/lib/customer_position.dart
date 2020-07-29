//Customer Position Page where position in Queue is shown

import 'dart:convert';
import 'package:flutter/material.dart';
import 'global.dart' as global;
import 'main.dart';
import 'package:http/http.dart' as http;
import 'customer_main_page.dart';
import 'dart:async';

class Position extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Cus_Pos(),
    );
  }
}

class Cus_Pos extends StatefulWidget {

  @override
  _Cus_PosState createState() => _Cus_PosState();
}

class _Cus_PosState extends State<Cus_Pos> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(title: Text('Your Position', style: TextStyle(fontSize: 25),),centerTitle: true,backgroundColor: Colors.deepOrange, automaticallyImplyLeading: false,),
        body: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image(
                  image: AssetImage('images/Pos.jpeg'),
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.black)
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Text('Queue Position', style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
                  onPressed: () {
                    String pos = '{"ID":"'+global.cus_ID.toString()+'","shop_name":"'+global.shop_name+'"}';
                    String posurl = '$HTTP/qID';
                    Map<String, String> headers = {"Content-type": "application/json"};
                    var open = http.post(posurl, headers: headers, body: pos.toString()).then((value) {
                      var jData = json.decode(value.body);
                      jData["key"]=="YES" ? showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Center(child: Text('Yay! You can go to the shop now and your position is')),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 100),
                                child: Text(jData["pos"],style: TextStyle(fontSize: 100),),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            );
                          }
                      ) : showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Center(child: Text('Please wait! Your Position is')),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 100),
                                child: Text(jData["pos"],style: TextStyle(fontSize: 100),),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            );
                          }
                      );
                    });
                  },
                ),
                RaisedButton(
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.deepOrange)
                  ),
                  child: Text('Exit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  onPressed: () {
                    String exit = '{"ID":"'+global.cus_ID.toString()+'"}';
                    String exiturl = '$HTTP/update';
                    Map<String, String> headers = {"Content-type": "application/json"};
                    var open = http.post(exiturl, headers: headers, body: exit.toString());
                    global.queue = false;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListApp()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}