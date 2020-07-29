import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'global.dart' as global;
import 'package:loading/loading.dart';
import 'merchant_second_pg.dart';
import 'merchant_login.dart';

class Merch_Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'List Demo',
      theme: new ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Vollkoran'
      ),
      home: new NextPage(title: 'Merchant',),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NextPage extends StatefulWidget {

  NextPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {

  String mer_name = global.merch_name;
  bool isSwitched ;
  Future<List<_User>> _getCust() async{
    String ph = '{"number":'+global.merch_number+'}';
    String _URL = '$HTTP/data';
    Map<String, String> headers = {"Content-type": "application/json"};
    var data = await http.post(_URL, headers: headers, body: ph.toString());
    var jsonData = json.decode(data.body);
    isSwitched = jsonData["data"][0]['o_c'];
    List<_User> _users = [];
    for(var u in jsonData["data"]){
      _User user = _User( u["name"],u["loc"], u["pin"], u["ph"]);
      _users.add(user);
    }
    return _users;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title, style: TextStyle(fontSize: 27),),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder(
              future: _getCust(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  return Container(
                    child: Center(
                      child: Loading(indicator: BallPulseIndicator(), size: 50, color: Colors.black,)
                    ),
                  );
                }
                else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext, int index) {
                        return Column(
                         children: <Widget>[
                           SizedBox(height: 60,),
                           Image(image: AssetImage('images/Merch.jpg'),),
                           SizedBox(height: 30,),
                           ListTile(
                             title: Center(child: Text(snapshot.data[index].name, style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, fontFamily: 'Vollkoran'),)),
                             subtitle: Center(child: Text(snapshot.data[index].address, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Vollkoran'),)),
                             isThreeLine: true,
                           ),
                           ButtonBar(
                             children: <Widget>[
                               Switch(
                                 value: isSwitched,
                                 onChanged: (value){
                                   setState(() {
                                     isSwitched=value;
                                     global.opcl = value;
                                     var opCl = '{"number":'+global.merch_number+',"value":'+value.toString()+'}';
                                     String _url = '$HTTP/on_off';
                                     Map<String, String> headers = {"Content-type": "application/json"};
                                     var open = http.post(_url, headers: headers, body: opCl.toString());
                                   });
                                 },
                                 activeTrackColor: Colors.deepOrange[200],
                                 activeColor: Colors.deepOrange,
                               ),
                               RaisedButton(
                                 child: Text('Q List', style: TextStyle(fontSize: 20),),
                                 color: Colors.deepOrange,
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(50),
                                     side: BorderSide(color: Colors.deepOrange),
                                 ),
                                 onPressed: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => Mer_CusList()));
                                 },
                               )
                             ],
                           )
                         ],
                        );
                      }
                  );
                }
              }
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Hello $mer_name!",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.deepOrange
                ),
              ),
              FlatButton(
                child: Text('Edit',style: TextStyle(
                    fontSize: 20
                ),),
                onPressed: () {},
              ),
              FlatButton(onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantLogin())),
                child: Text('Logout',style: TextStyle(
                    fontSize: 20
                ),),
              )
            ],
          ),
        ),
      ),
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () =>Navigator.pop(context, true),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () =>Navigator.pop(context, false),
            ),
          ],
        )
      ),
    );
  }
}

class _User{
  final String name;
  final String address;
  final String pin;
  final String ph;


  _User(this.name, this.address, this.pin, this.ph);
}