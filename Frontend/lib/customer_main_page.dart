//Customer Page with list of Shops shown here

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'dart:convert';
import 'main.dart';
import 'global.dart' as global;
import 'customer_login.dart';
import 'package:loading/loading.dart';
import 'customer_position.dart';

void main() => runApp(new ListApp());

class ListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'List Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
          fontFamily: 'Vollkoran'
      ),
      home: new HomePage(title: 'Users',),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = global.cus_username;
  Future<List<User>> _getShop() async{
    String pinc = '{"pin":'+global.cus_pin+',"name":"'+global.cus_username+'"}';
    String _URL = '$HTTP/customer';
    Map<String, String> headers = {"Content-type": "application/json"};
    var data = await http.post(_URL, headers: headers, body: pinc.toString());
    var jsonData = json.decode(data.body);
    global.cus_ID = jsonData["ID"];
    print(jsonData["data"]);
    print(jsonData["ID"]);
    print(global.cus_ID);
    List<User> users = [];
    for(var u in jsonData["data"]){
      print(u);
      User user = User(u["name"], u["address"], u["num"], u["o_c"], u["mdata"]);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          }
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: Text(widget.title, style: TextStyle(fontSize: 25),),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder(
            future: _getShop(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Loading(indicator: BallPulseIndicator(), size: 50.0, color: Colors.black,)
                  ),
                );
              }else if(snapshot.data.length == 0){
                return Container(
                  child: Center(
                    child: Image(image: AssetImage('images/NoResults.jpeg'),),
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
                            SizedBox(height: 10,),
                            ListTile(
                              title: Text(snapshot.data[index].name, style: TextStyle(fontSize: 20),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data[index].address, style: TextStyle(fontWeight: FontWeight.w600),),
                                  Text(snapshot.data[index].phone, style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Amiri'),),
                                ],
                              ),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('images/Shop.jpeg'),
                                radius: 30,
                              ),
                              trailing: snapshot.data[index].o_c=="OPEN"? Column(
                                children: <Widget>[
                                  Text(snapshot.data[index].o_c, style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),),
                                  Text(snapshot.data[index].mdata, style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Amiri', fontSize: 18),)
                                ],
                              ) : Text(snapshot.data[index].o_c, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),),
                            ),
                            ButtonBar(
                              children: <Widget>[
                                snapshot.data[index].o_c=="OPEN"? FloatingActionButton(
                                  child: Icon(Icons.shopping_cart),
                                  heroTag: "$index",
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Center(child: Text('Want to join the queue?')),
                                          content: Image(
                                              image: AssetImage('images/Alert.jpeg'),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('No', style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w700),),
                                              onPressed: () {
                                               Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Yes', style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w700),),
                                              onPressed: () {
                                                String queue = '{"ID":"'+global.cus_ID.toString()+'","user":"'+global.cus_username+'","shopname":"'+snapshot.data[index].name+'","merch_phone":"'+snapshot.data[index].phone.toString()+'","status":"ACTIVE"}';
                                                String qurl = '$HTTP/queue';
                                                Map<String, String> headers = {"Content-type": "application/json"};
                                                var open = http.post(qurl, headers: headers, body: queue.toString());
                                                global.shop_name = snapshot.data[index].name;
                                                global.queue = true;
                                                Navigator.push(context, MaterialPageRoute (builder: (context) => Cus_Pos()));
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ):null,
                              ],
                            )
                          ],
                        ),
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
                      "Hello $name!",
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
              FlatButton(
                child: Text('Logout',style: TextStyle(
                  fontSize: 20
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class User{
  final String name;
  final String address;
  final String phone;
  final String o_c;
  final String mdata;

  User(this.name, this.address, this.phone, this.o_c, this.mdata);
}