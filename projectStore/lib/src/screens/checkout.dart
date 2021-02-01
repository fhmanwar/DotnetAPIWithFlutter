import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:projectStore/src/models/cartModel.dart';
import 'package:projectStore/src/routes/navigate.dart';
import 'package:projectStore/src/utils/serviceApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
  // final CartModel cart;
  // final int total;
  // Checkout({@required this.cart, this.total});
}

class _CheckoutState extends State<Checkout> {
  ServiceAPI _apiServices = new ServiceAPI();
  String getbayar;
  int _bayar = 0;
  int _kembalian = 0;
  String qty, harga;
  int idUsers;
  final _key = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pink[200],
      appBar: AppBar(
        elevation: 3.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text(
          "CheckOut",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        leading: new IconButton(
          color: Colors.black,
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigate().gotoHome(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.only(top: 5.0),
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(
                        top: 5.0,
                        left: 5.0,
                        bottom: 5.0,
                      ),
                      height: 70,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.delivery_dining,
                        size: 80,
                        color: Colors.redAccent,
                      ),
                    ),
                    Text(
                      "Your Order is being Processed",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Thank you for shopping at this store",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
