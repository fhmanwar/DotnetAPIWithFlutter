import 'package:flutter/material.dart';
import 'package:projectStore/src/routes/navigate.dart';
import 'package:projectStore/src/utils/serviceApi.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final _key = new GlobalKey<FormState>();
  ServiceAPI _apiServices = new ServiceAPI();
  String name, email, pass;
  bool _secureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return "Enter Your Email";
    } else if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    setState(() {
      final form = _key.currentState;
      if (form.validate()) {
        form.save();
        print('$name, $email, $pass');
        _apiServices.regisData(name, email, pass).whenComplete(() {
          if (_apiServices.status == false) {
            Toast.show("Email Already Use ", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } else {
            Navigate().gotoLogin(context);
          }
        });
      } else {
        Toast.show("phone or password is wrong", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        print('error');
      }
      // print(_apiServices.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.5,
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text(
          "Sign Up",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        leading: new IconButton(
          color: Colors.black,
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigate().gotoLogin(context);
          },
        ),
      ),
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 75.0,
                  child: new Image.asset(
                    'assets/splash.png',
                    scale: 2.1,
                  ),
                ),
                new Form(
                  key: _key,
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: <Widget>[
                        new Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Name",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Enter Your Name";
                              }
                            },
                            onSaved: (e) => name = e,
                            controller: _nameController,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Enter Name',
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Email",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: TextFormField(
                            validator: validateEmail,
                            onSaved: (e) => email = e,
                            controller: _emailController,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Enter Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Password",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please enter password";
                              }
                            },
                            obscureText: _secureText,
                            onSaved: (e) => pass = e,
                            controller: _passwordController,
                            decoration: new InputDecoration(
                                // labelText: "Enter Password",
                                fillColor: Colors.black,
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'Enter Password',
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                )),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                        ),
                        new Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MaterialButton(
                            height: 50.0,
                            textColor: Colors.white,
                            child: new Text('Register'),
                            onPressed: () {
                              // _login();
                              check();
                            },
                            splashColor: Colors.lightBlue,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
