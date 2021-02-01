import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectStore/src/models/productModel.dart';
import 'package:projectStore/src/routes/navigate.dart';
import 'package:projectStore/src/utils/serviceApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Detail extends StatefulWidget {
  final Product product;
  Detail({Key key, @required this.product}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final formatCurrency = new NumberFormat.currency(name: 'Rp');
  // Product product;
  ServiceAPI _apiServices = new ServiceAPI();
  var token, id;

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
    setState(() {
      print('$id, ${widget.product.name}, 1');
      _apiServices
          .addToCart('$id', '${widget.product.name}', 1)
          .whenComplete(() {
        // print(_apiServices.status);
        if (_apiServices.status == false) {
          Toast.show(_apiServices.msg, context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        } else {
          Toast.show(_apiServices.msg, context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.5,
        backgroundColor: Colors.white,
        leading: new IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigate().gotoHome(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: new EdgeInsets.only(top: 25.0),
                    ),
                    Text(
                      '${formatCurrency.format(widget.product.price)}',
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: new EdgeInsets.only(bottom: 15.0),
                    ),
                    Text(
                      widget.product.name,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Informasi Produk',
                      style: TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: new EdgeInsets.only(bottom: 15.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kondisi',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          'Baru',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Padding(
                      padding: new EdgeInsets.only(bottom: 10.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          widget.product.categoryName,
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Padding(
                      padding: new EdgeInsets.only(bottom: 10.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stok',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '${widget.product.stock} ${widget.product.unit}',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.shopping_cart_rounded,
          color: Colors.redAccent,
          size: 26.0,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          check();
        },
      ),
    );
  }
}
