//Customer Login Page

import 'package:flutter/material.dart';
import 'package:login/forgot_password.dart';
import 'customer_signup.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'customer_main_page.dart';
import 'global.dart' as global;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Login'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (_,index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 150,horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 75.0,
                  backgroundImage: AssetImage('images/Icon.jpeg'),
                ),
                Customform(),
              ],
            ),
          );
        }
      ),
    );
  }
}

class Customform extends StatefulWidget {
  @override
  _CustomformState createState() => _CustomformState();
}

class _CustomformState extends State<Customform> {
  final _formKey = GlobalKey<FormState>();

  @override

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _pincodeController = new TextEditingController();

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter Username',
                    icon: Icon(Icons.person,color: Colors.deepOrange,),
                    labelStyle: TextStyle(fontSize: 20.0,),
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
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    icon: Icon(Icons.vpn_key,color: Colors.deepOrange,),
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }else if(value.length < 8){
                    return 'Password should contain atleast 8 characters';
                  }
                  return null;
                },
                controller: _passwordController,
                obscureText: true,
                  keyboardType: TextInputType.text
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Pincode',
                    hintText: 'Enter Current Pincode',
                    icon: Icon(Icons.location_on,color: Colors.deepOrange,),
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _pincodeController,
                  keyboardType: TextInputType.number
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.deepOrange)
                  ),
                  child: Text('Login',
                    style: TextStyle(color: Colors.white,fontSize: 20)),
                  onPressed: () {
                    if (_formKey.currentState.validate()){
                      String _url = '$HTTP/cus_login';
                      Map<String, String> headers = {"Content-type": "application/json"};
                      String json = '{"username":"'+_usernameController.text+'","password":"'+_passwordController.text+'"}';
                      var response = http.post(_url, headers: headers, body: json.toString()).then((value)  {
                        if(value.body=="success"){
                          global.cus_username = _usernameController.text;
                          global.cus_pin = _pincodeController.text;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ListApp()));
                        }if(value.body=="failure"){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Center(child: Text('Invalid')),
                                  content: Text('Username and Password doesn\'nt match!!!'),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text('TRY AGAIN'),
                                        onPressed: () => Navigator.pop(context)
                                    )
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }
                          );
                        }
                      });
                    }
                  },
                ),
                SizedBox(height: 10,),
                InkWell(
                  child: Text('Forgot Password?',
                    style: TextStyle(color: Colors.deepOrange,fontSize: 15),),
                  onTap: (){
                    global.cus_merch = "cus";
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Forgot_Pass()),);
                  },
                ),
                SizedBox(height: 10,),
                InkWell(
                  child: Text('Sign Up?',
                    style: TextStyle(color: Colors.deepOrange,fontSize: 20)),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}