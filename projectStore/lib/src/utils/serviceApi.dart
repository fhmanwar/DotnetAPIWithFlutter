import 'dart:convert';

import 'package:projectStore/src/models/cartModel.dart';
import 'package:projectStore/src/models/jwtModel.dart';
import 'package:projectStore/src/models/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceAPI {
  static const String url = "http://drgreen123-001-site1.btempurl.com/api";
  var status, msg;

  static Future<List<Product>> getList(String token) async {
    try {
      final response = await http.get(
        '$url/products',
        headers: <String, String>{
          'Content-type': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<Product> list = parseData(response.body);
        // print(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Product> parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  static Future<List<CartModel>> getListCart(String token) async {
    try {
      final response = await http.get(
        '$url/carts',
        headers: <String, String>{
          'Content-type': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode == 200) {
        if (response.body == null) {
          return null;
        } else {
          // print(response.body);
          List<CartModel> list = parseDataCart(response.body);
          return list;
        }
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<CartModel> parseDataCart(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<CartModel>((json) => CartModel.fromJson(json)).toList();
  }

  addToCart(String userId, String productName, int qty) async {
    final res = await http.post(
      "$url/carts",
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "UserId": "$userId",
        "ProductName": "$productName",
        "Quantity": "$qty"
      }),
    );
    print(res.statusCode);
    var data = json.decode(res.body);
    msg = data['msg'];
    status = data['status'];
    print('data : ${data["status"]} - ${data["msg"]} ');
  }

  savePref(String token, String id, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('userId', id);
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.commit();
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.commit();
  }

  getPref() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token') ?? 0;
    print('read : $token');
  }

  loginData(String email, String pass) async {
    final res = await http.post(
      "$url/auths/login",
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body:
          jsonEncode(<String, String>{"Email": '$email', "Password": '$pass'}),
    );

    status = res.statusCode;
    msg = res.body;
    // print(status);
    // print(msg);
    JWTModel jwtModel = getJsonFromJWT(msg);
    // print(jwtModel);
    print('data : $status - $msg');
    // saveToken(msg);
    savePref(msg, jwtModel.userId, jwtModel.name, jwtModel.email);
  }

  regisData(String name, String email, String pass) async {
    final res = await http.post(
      "$url/auths/register",
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "Name": "$name",
        "Email": '$email',
        "Password": '$pass'
      }),
    );
    print(res.statusCode);
    print('data : ${res.statusCode} - ${res.body}');
  }

  getJsonFromJWT(String splittedToken) {
    // print(splittedToken);
    // Map<String, dynamic> test = _apiServices.parseJwt(splittedToken);
    // print(test);
    final parts = splittedToken.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    var normalizedSource = utf8.decode(base64Url.decode(parts[1]));
    // print(normalizedSource);
    JWTModel jwtModel = JWTModel.fromJson(json.decode(normalizedSource));
    // print(jwtModel.email);
    return jwtModel;
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    print(parts[1]);
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
