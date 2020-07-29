//This page is the main content page of the Application. This lets the user to choose them as Merchant or Customer

import 'package:flutter/material.dart';
import 'customer_login.dart';
import 'merchant_login.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (_, index) {
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 75,
                  ),
                  Image(
                    image: AssetImage('images/AppLogo.jpeg'),
                    height: 350,
                    width: 350,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.deepOrange)),
                    child: Text(
                      'Customer',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.deepOrange,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.deepOrange)),
                    child: Text(
                      'Merchant',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.deepOrange,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantLogin()));
                    },
                  ),
                ],
              ),
            );
          },
        )
    );
  }
}
