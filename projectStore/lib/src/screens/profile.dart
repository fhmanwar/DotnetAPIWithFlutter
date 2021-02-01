import 'package:flutter/material.dart';
import 'package:projectStore/src/routes/navigate.dart';
import 'package:projectStore/src/utils/serviceApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ServiceAPI _apiServices = new ServiceAPI();
  String name, email;

  profilePref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
      email = pref.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();
    profilePref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.5,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _apiServices.savePref(null, null, null, null);
              Navigate().gotoLogin(context);
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                        Icons.person,
                        size: 80,
                        color: Colors.redAccent,
                      ),
                    ),
                    Text(
                      "$name",
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      "$email",
                      style: TextStyle(fontSize: 18),
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
