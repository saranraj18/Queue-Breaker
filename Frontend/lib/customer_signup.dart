//Customer SignUp Page with basic details of Customer

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'customer_main_page.dart';
import 'global.dart' as global;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer SignUp',
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (_,index){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SignupForm(),
            ],
          );
        }
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  @override

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _pincodeController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Image(
              image: AssetImage('images/Signup_Img.jpeg'),
              height: 150,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    icon: Icon(Icons.account_circle, size: 30,color: Colors.deepOrange),
                    labelStyle: TextStyle(fontSize: 17),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty){
                      return 'Your field is empty';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock_outline,size: 30,color: Colors.deepOrange),
                    labelStyle: TextStyle(fontSize: 17),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty){
                      return 'Your field is empty';
                    }else if(value.length <= 8){
                      return 'Password should contain atleast 8 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    icon: Icon(Icons.phone, size: 30,color: Colors.deepOrange,),
                    labelStyle: TextStyle(fontSize: 17),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty){
                      return 'Your field is empty';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Email Id',
                      labelStyle: TextStyle(fontSize: 17),
                      icon: Icon(Icons.email,color: Colors.deepOrange,),
                      border: OutlineInputBorder()),
                  validator: validateEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    icon: Icon(Icons.location_on, size: 30,color: Colors.deepOrange),
                    labelStyle: TextStyle(fontSize: 17),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty){
                      return 'Your field is empty';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text('Sign Up',
              style: TextStyle(color: Colors.white,fontSize: 20),),
                color: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.deepOrange)
              ),
              onPressed: (){
                if(_formKey.currentState.validate()){
                  String _URL = '$HTTP/cus_signup';
                  Map<String, String> headers = {"Content-type": "application/json"};
                  String json = '{"username":"'+_usernameController.text+'","password":"'+_passwordController
                      .text+'","phone":"'+_phoneController.text+'","email":"'+_emailController.text+'","pincode":"'+_pincodeController.text+'"}';
                  var signupresponse = http.post(_URL, headers: headers, body: json.toString()).then((value){
                    if(value.body=="success"){
                      global.cus_username = _usernameController.text;
                      global.cus_phone = _phoneController.text;
                      global.cus_pin = _pincodeController.text;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListApp()));
                    }if(value.body=="failure"){
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Center(child: Text('Invalid')),
                            content: Text('Phone no already exists'),
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
                  },);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

String validateEmail(String value){
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}