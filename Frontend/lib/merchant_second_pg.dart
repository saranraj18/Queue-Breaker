import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'main.dart';
import 'global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading/loading.dart';

class Mer_CusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Vollkoran'
        ),
        home: new CusList(title: 'Queue List',),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CusList extends StatefulWidget {

  CusList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CusListState createState() => _CusListState();
}

class _CusListState extends State<CusList> {

  Future<List<_QueueList>> _CustList() async{

    var refresh = '{"merch_phone":"'+global.merch_number+'"}';
    String refur = '$HTTP/details';
    Map<String, String> headers = {"Content-type": "application/json"};
    var refsend = await http.post(refur, headers: headers, body: refresh.toString());

    var jsonData = json.decode(refsend.body);
    print(jsonData["data"]);
    List<_QueueList> _users = [];
    for(var u in jsonData["data"]){
      print(u);
      _QueueList user = _QueueList( u["cname"],u["sts"]);
      print(_users);
      _users.add(user);
    }
    return _users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.title, style: TextStyle(fontSize: 25),),centerTitle: true,),
      body: Container(
        child: FutureBuilder(
          future: _CustList(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                      child: Loading(indicator: BallPulseIndicator(), size: 50.0, color: Colors.black,)
                  ),
                );
              }else if(snapshot.data.length==0){
                return Container(
                  child: Center(
                    child: Image(image: AssetImage('images/Nothing.jpg'),),
                  ),
                );
              }
              else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            Card(
                              child: ListTile(
                                title: Text(snapshot.data[index].cname, style: TextStyle(fontSize: 25)),
                                subtitle: Text(snapshot.data[index].sts, style: TextStyle(fontSize: 15)),
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage('images/Q.jpeg'),radius: 33,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                );
              }
            }
        ),
      ),
    );
  }
}

class _QueueList{
  final String cname;
  final String sts;


  _QueueList(this.cname, this.sts);
}
