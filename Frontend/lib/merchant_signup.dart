//Sign Up Page for Merchant with basic details for entry

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'merch_main.dart';
import 'global.dart' as global;

class MerchantSignUp extends StatefulWidget {
  @override
  _MerchantSignUpState createState() => _MerchantSignUpState();
}

class _MerchantSignUpState extends State<MerchantSignUp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant SignUp', style: TextStyle(fontSize: 25),),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (_,index){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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

  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _shopnameController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _cityController = new TextEditingController();
  final TextEditingController _stateController = new TextEditingController();
  final TextEditingController _countryController = new TextEditingController();
  final TextEditingController _pincodeController = new TextEditingController();
  final TextEditingController _allowancesController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          Image(
            image: AssetImage('images/Signup_Img.jpeg'),
            height: 150,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Username',
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
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }else if(value.length <= 8){
                    return 'Password should contain atleast 8 characters';
                  }
                  return null;
                },
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Phone number',
                    labelStyle: TextStyle(fontSize: 20.0,),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(fontSize: 17),
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
                decoration: const InputDecoration(
                    labelText: 'Shop Name',
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _shopnameController,
                  keyboardType: TextInputType.text
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'No. of Allowances',
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _allowancesController,
                  keyboardType: TextInputType.number
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _addressController,
                  keyboardType: TextInputType.text
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'City',
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _cityController,
                  keyboardType: TextInputType.text
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'State',
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _stateController,
                  keyboardType: TextInputType.text
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Country',
                    labelStyle: TextStyle(fontSize: 20.0,),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Your field is empty';
                  }
                  return null;
                },
                controller: _countryController,
                  keyboardType: TextInputType.text
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Pincode',
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
                  child: Text('Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 20),),
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.deepOrange)
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()){
                      String url = '$HTTP/mer_signup';
                      Map<String, String> headers = {"Content-type": "application/json"};
                      String json = '{"username":"'+_usernameController.text+'","password":"'+_passwordController
                          .text+'","phone":"'+_phoneController.text+'","email":"'+_emailController.text+'","shopname":"'+_shopnameController.text+'","allowance":"'+_allowancesController.text+'","open_closed":"CLOSED" ,"address":"'+_addressController.text+'","city":"'+_cityController.text+'","state":"'+_stateController.text+'","country":"'+_countryController.text+'","pincode":"'+_pincodeController.text+'"}';
                      var response = http.post(url, headers: headers, body: json.toString()).then((value)  {
                        if(value.body=="success"){
                          global.merch_number = _phoneController.text;
                          global.merch_name = _usernameController.text;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Merch_Main()));
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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