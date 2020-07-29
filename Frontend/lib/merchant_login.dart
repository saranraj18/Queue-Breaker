//Login page of Merchant
//Contains Basic details for the authentication

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'forgot_password.dart';
import 'main.dart';
import 'merchant_signup.dart';
import 'merch_main.dart';
import 'global.dart' as global;

class MerchantLogin extends StatefulWidget {
  @override
  _MerchantLoginState createState() => _MerchantLoginState();
}

class _MerchantLoginState extends State<MerchantLogin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant Login', style: TextStyle(fontSize: 23),),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (_,index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 8),
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
  final TextEditingController _phoneController = new TextEditingController();

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
                    icon: Icon(Icons.person,color: Colors.deepOrange),
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _usernameController,
                  keyboardType: TextInputType.text
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
                    icon: Icon(Icons.vpn_key,color: Colors.deepOrange),
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Your field is empty';
                  }else if(value.length <= 8){
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
                  labelText: 'Phone',
                    hintText: 'Enter Phone',
                    icon: Icon(Icons.phone,color: Colors.deepOrange),
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _phoneController,
                  keyboardType: TextInputType.phone
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  child: Text('Login',style: TextStyle(color: Colors.white, fontSize: 20),),
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.deepOrange)
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      String _url = '$HTTP/mer_login';
                      Map<String, String> headers = {
                        "Content-type": "application/json"
                      };
                      String json = '{"username":"' + _usernameController.text + '","password":"' + _passwordController.text + '"}';
                      var response = http.post(
                          _url, headers: headers, body: json.toString()).then((
                          value) {
                        if (value.body == "success") {
                          global.merch_number = _phoneController.text;
                          global.merch_name = _usernameController.text;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Merch_Main()));
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
                    };
                  }),
                SizedBox(height: 10,),
                InkWell(
                  child: Text('Forgot Password?',
                    style: TextStyle(color: Colors.deepOrange,fontSize: 15),),
                  onTap: (){
                    global.cus_merch = "merch";
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Forgot_Pass()),);
                  },
                ),
                SizedBox(height: 15,),
                InkWell(
                  child: Text('Sign Up?',
                    style: TextStyle(color: Colors.deepOrange,fontSize: 20),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantSignUp()));
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