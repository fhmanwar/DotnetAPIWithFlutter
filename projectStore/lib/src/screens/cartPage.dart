import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectStore/src/components/basketList.dart';
import 'package:projectStore/src/models/cartModel.dart';
import 'package:projectStore/src/models/jwtModel.dart';
import 'package:projectStore/src/models/transactionItemModel.dart';
import 'package:projectStore/src/routes/navigate.dart';
import 'package:projectStore/src/utils/serviceApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const String url = "http://drgreen123-001-site1.btempurl.com/api";
  StreamController<int> streamController = new StreamController<int>();
  ServiceAPI _apiServices = new ServiceAPI();
  CartModel cart;
  JWTModel jwtModel;
  int total = 0;
  var token, id;
  List<TransactionItemModel> dataItemJson;

  tokenPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
      id = pref.getString('userId');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenPref();
  }

  check() async {
    print('$id, $total');
    // var item = getAllCart(token);
    var response = await http.get("$url/carts");
    dataItemJson = (json.decode(response.body) as List)
        .map((i) => TransactionItemModel.fromJson(i))
        .toList();

    Map<String, dynamic> args = {
      "UserId": id,
      "Total": total,
      "transactionItems": jsonEncode(dataItemJson)
    };
    // print(args);

    try {
      var res = await http.post(
        "$url/transactions",
        headers: <String, String>{
          'Content-type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "UserId": id,
          "Total": total,
          "transactionItems": dataItemJson
        }),
      );
      print(res.statusCode);
      var status = res.statusCode;
      var msg = res.body;
      if (res.body != 'Successfully Created') {
        Toast.show('error', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        // Toast.show(res.body, context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigate().gotoCheckout(context);
      }
      print('data : $status - $msg');
    } catch (e) {
      throw Exception(e.toString());
    }

    // List<dynamic> comments = [
    //   {
    //     "TransactionItemId": "1",
    //     "ProductId": 1,
    //     "CategoryName": "Drink",
    //     "Quantity": 3,
    //     "SubTotal": 30000
    //   }
    // ];
    // Map<String, dynamic> args = {
    //   "UserId": 3,
    //   "Total": 230000,
    //   "transactionItems": comments
    // };
    // print(args);
  }

  gridview(AsyncSnapshot<List<CartModel>> list) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: list.data.map(
          (i) {
            return GridTile(
              child: BasketCard(i),
            );
          },
        ).toList(),
      ),
    );
  }

  circularProgress() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.5,
        backgroundColor: Colors.white,
        title: new Text(
          "Cart",
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: FutureBuilder<List<CartModel>>(
              future: ServiceAPI.getListCart(token),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  streamController.sink.add(snapshot.data.length);
                  return gridview(snapshot);
                }
                return circularProgress();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Container(
        height: 60.0,
        color: Colors.white,
        child: new Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Total : ',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FutureBuilder<List<CartModel>>(
                      future: ServiceAPI.getListCart(token),
                      builder: (context, snapshot) {
                        if (snapshot.data.isNotEmpty) {
                          total = snapshot.data
                              .map((value) => value.subtotal)
                              .reduce((a, b) => a + b);
                          // print(total);
                          return Text(
                            '${NumberFormat.currency(name: 'Rp ').format(total)}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          );
                        }
                        return Text(
                          "null",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              RaisedButton(
                child: Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
                onPressed: () {
                  if (total == 0) {
                    Toast.show('Cart is Empty', context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    print(total);
                  } else {
                    check();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    streamController.close();
    super.dispose();
  }
}
