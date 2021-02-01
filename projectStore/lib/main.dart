import 'package:flutter/material.dart';
import 'package:projectStore/src/app.dart';
import 'package:projectStore/src/routes/navigate.dart';

void main() {
  runApp(
    new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      home: new App(),
      routes: route,
    ),
  );
}

