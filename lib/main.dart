import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlitecase/const/colors.dart';
import 'package:sqlitecase/view/loginpage/registerpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sqlite Case',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      home: RegisterPage(),
    );
  }
}

