//Forgot Password Page where password is sent to the registered mail-id

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'global.dart' as global;

class Forgot_Pass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Retrieval',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Vollkoran'),
      home: pass_retrieve(),
    );
  }
}

class pass_retrieve extends StatefulWidget {
  @override
  _pass_retrieveState createState() => _pass_retrieveState();
}

class _pass_retrieveState extends State<pass_retrieve> {

  final _formKey = GlobalKey<FormState>();

  @override

  final TextEditingController _usernameController = new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Retrieval'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (_, index){
          return Column(
            children: <Widget>[
              SizedBox(height: 270,),
              Text('Enter your Username',style: TextStyle(fontSize: 20),),
              SizedBox(height: 50,),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Username',
                            icon: Icon(Icons.person,color: Colors.deepOrange,),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.isEmpty){
                            return 'Your field is empty';
                          }
                          return null;
                        },
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.deepOrange)
                ),
                child: Text('Submit',
                    style: TextStyle(color: Colors.white,fontSize: 20)),
                onPressed: () {
                  if (_formKey.currentState.validate()){
                    if (global.cus_merch=="cus"){
                      String _url = '$HTTP/cus_reset';
                      Map<String, String> headers = {"Content-type": "application/json"};
                      String _json = '{"name":"'+_usernameController.text+'"}';
                      var response = http.post(_url, headers: headers, body: _json.toString()).then((value)  {
                        showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text('Check your password in the registered email-id.'),
                            );
                          }
                        );
                      });
                    }else{
                      String _url = '$HTTP/mer_reset';
                      Map<String, String> headers = {"Content-type": "application/json"};
                      String _json = '{"name":"'+_usernameController.text+'"}';
                      var response = http.post(_url, headers: headers, body: _json.toString()).then((value)  {
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                content: Text('Retrieve your password in the registered email-id.'),
                              );
                            }
                        );
                      });
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}