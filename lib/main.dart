import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirq/const/colors.dart';
import 'package:kasirq/const/colors.dart';
import 'package:kasirq/dummy.dart';
import 'package:kasirq/service/ClientSocket.dart';
import 'package:kasirq/service/ServerSocket.dart';
import 'package:kasirq/view/authentication/registerpage.dart';
import 'package:kasirq/view/dashboard/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kasirq',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      home: const Dashboard(),
    );
  }
}

