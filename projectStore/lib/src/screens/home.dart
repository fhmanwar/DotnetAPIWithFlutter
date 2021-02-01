import 'dart:async';

import 'package:flutter/material.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:projectStore/src/components/productList.dart';
import 'package:projectStore/src/models/productModel.dart';
import 'package:projectStore/src/routes/navigate.dart';
import 'package:projectStore/src/utils/constants.dart';
import 'package:projectStore/src/utils/serviceApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamController<int> streamController = new StreamController<int>();
  ServiceAPI _apiServices = new ServiceAPI();
  String token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenPref();
  }

  tokenPref() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
  }

  gridview(AsyncSnapshot<List<Product>> list) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: MasonryGrid(
        staggered: false,
        column: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: list.data.map(
          (i) {
            return GestureDetector(
              child: GridTile(
                child: ProductCard(i),
              ),
              onTap: () => Navigate().gotoDetail(context, i),
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
          "Beranda",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        actions: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5.0),
                child: new IconButton(
                  color: Colors.black,
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigate().gotoCart(context);
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            margin: EdgeInsets.only(right: 10.0),
            child: new IconButton(
              color: Colors.black,
              icon: Icon(
                Icons.more_vert,
                size: 30,
              ),
              onPressed: () {
                _onBottomPressed();
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: FutureBuilder<List<Product>>(
              future: ServiceAPI.getList(token),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // print(token);
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
    );
  }

  void dispose() {
    streamController.close();
    super.dispose();
  }

  void _onBottomPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black54,
          height: 300,
          child: Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () => Navigate().gotoProfile(context),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                  onTap: () {
                    _apiServices.savePref(null, null, null, null);
                    Navigate().gotoLogin(context);
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(30),
                topLeft: const Radius.circular(30),
              ),
            ),
          ),
        );
      },
    );
  }
}
