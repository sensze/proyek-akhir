import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirq/const/colors.dart';
import 'package:kasirq/sql_helper/sql_helper.dart';
import 'package:external_path/external_path.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class Dummy extends StatefulWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              toJson();
            },
            child: const Text("Show Dialog")
        )
      )
    );
  }
}
void toJson() async {
  List<Map<String, dynamic>> dataFromSqflite = [];
  final data = await SQLHelper.getItems();
  dataFromSqflite = data;
  String jsonString = jsonEncode(dataFromSqflite);
  print(jsonString);
  /*saveJsonToFile(jsonString, "data");*/
}

/*void saveJsonToFile(String jsonString, String fileName) async {
  String dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  String file = "$dir/$fileName.json";
  File jsonFile = File(file);
  await jsonFile.writeAsString(jsonString);
  print("File saved at $file");
}*/

Widget errorAlert(String errorMsg) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xFF9BA4B5),
          ),
          child: Lottie.asset(
            "lib/assets/anim/error.json",
            height: 150,
            width: 150,
          ),
        ),
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Gagal!",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(errorMsg,
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF9BA4B5))),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => {Get.back()},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySwatch,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("OK", style: TextStyle(color: Colors.white),))
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget successAlert(String errorMsg) {
  const primarySwatches = Color(0xff6DC657);
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xFF9BA4B5),
          ),
          child: Lottie.asset(
            "lib/assets/anim/success.json",
          ),
        ),
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Sukses!",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(errorMsg,
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF9BA4B5))),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => {Get.back()},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySwatches,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("OK", style: TextStyle(color: Colors.white),))
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
