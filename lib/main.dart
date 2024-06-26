import 'package:flutter/material.dart';
import 'package:smarthome/smartapp.dart';
import 'package:smarthome/bindings.dart';

void main() {
  MyBinding();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: smarthome_app(),
    );
  }
}
