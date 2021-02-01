import 'package:flutter/material.dart';
import 'package:projectStore/src/models/cartModel.dart';
import 'package:projectStore/src/models/productModel.dart';
import 'package:projectStore/src/screens/cartPage.dart';
import 'package:projectStore/src/screens/checkout.dart';
import 'package:projectStore/src/screens/detail.dart';
import 'package:projectStore/src/screens/home.dart';
import 'package:projectStore/src/screens/login.dart';
import 'package:projectStore/src/screens/profile.dart';
import 'package:projectStore/src/screens/register.dart';

var route = <String, WidgetBuilder>{
  "/login": (BuildContext context) => new Login(),
  "/regis": (BuildContext context) => new Register(),
  "/home": (BuildContext context) => new Home(),
};

class Navigate {
  void gotoLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void gotoRegis(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/regis');
  }

  void gotoBottomNav(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/bottomNav');
  }

  void gotoHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void gotoCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    );
  }

  void gotoDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // fullscreenDialog: true,
        builder: (BuildContext context) => Detail(
          product: product,
        ),
      ),
    );
  }

  void gotoCheckout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Checkout(),
      ),
    );
  }

  void gotoProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(),
      ),
    );
  }
}
