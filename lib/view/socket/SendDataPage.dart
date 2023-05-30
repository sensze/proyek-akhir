import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasirq/utility/ClientSocket.dart';

import '../../sql_helper/sql_helper.dart';

class SendDataPage extends StatefulWidget {
  SendDataPage({Key? key, required this.source}) : super(key: key);
  String source;

  @override
  State<SendDataPage> createState() => _SendDataPageState();
}

class _SendDataPageState extends State<SendDataPage> {
  final TextEditingController _ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var sourcePage = widget.source == 'produk' ? 'produk' : 'transaksi';
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Masukkan IP address server",
              ),
            ),
          ),
          const SizedBox(
            height: 10
          ),
          ElevatedButton(
              onPressed: () => {
                getData(sourcePage).then((value) => {
                  sendData(_ipController.text, value),
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
