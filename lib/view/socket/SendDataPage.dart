import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasirq/utility/ClientSocket.dart';

import '../../sql_helper/sql_helper.dart';

class SendDataPage extends StatefulWidget {
  const SendDataPage({Key? key}) : super(key: key);

  @override
  State<SendDataPage> createState() => _SendDataPageState();
}

class _SendDataPageState extends State<SendDataPage> {
  final TextEditingController _ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Kirim Data',
            style: TextStyle(color: Colors.white),
          ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: TextFormField(
              controller: _ipController,
              decoration: const InputDecoration(
                hintText: "IP Address",
              ),
            ),
          ),
          const SizedBox(
            height: 10
          ),
          ElevatedButton(
              onPressed: () => {
                getData().then((value) => {
                  sendData(_ipController.text, value)
                })
              },
              child: const Text(
                "Send Data",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
