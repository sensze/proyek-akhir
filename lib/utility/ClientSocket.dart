import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sql_helper/sql_helper.dart';

Future<String> getData(String source) async {
  List<Map<String, dynamic>> dataFromSqflite = [];
  String jsonString = '';

  if (source == 'produk') {
    final data = await SQLHelper.getItems();

    // Exclude the "id" field from each data item
    for (var dataItem in data) {
      Map<String, dynamic> newDataItem = Map<String, dynamic>.from(dataItem);
      newDataItem.remove('id');
      dataFromSqflite.add(newDataItem);
    }

    jsonString = jsonEncode(dataFromSqflite);
    print(jsonString);

  } else if (source == 'transaksi') {
    final data = await SQLHelper.getTransaksi();

    // Exclude the "id" field from each data item
    for (var dataItem in data) {
      Map<String, dynamic> newDataItem = Map<String, dynamic>.from(dataItem);
      newDataItem.remove('id_penjualan');
      dataFromSqflite.add(newDataItem);
    }

    jsonString = jsonEncode(dataFromSqflite);
    // print(jsonString);
  }
  return jsonString;
}

Future<void> sendData(String ipAddress, String data) async {
  String alamatIp = ipAddress;
  int portServer = 8888;
  String? filePath;

  /*FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );
  if (result != null) {
    PlatformFile file = result.files.first;
    filePath = file.path;
    // Lanjutkan dengan pengiriman file melalui socket
  } else {
    // Penanganan jika tidak ada file yang dipilih
  }*/

  // Baca konten file CSV
  /*File csvFile = File(filePath!);
  List<String> lines = await csvFile.readAsLines();*/

  // Membuat socket TCP/IP untuk koneksi ke server
  Socket.connect(alamatIp, portServer).then((socket) {
    print(
        'Terhubung ke server: ${socket.remoteAddress.address}:${socket.remotePort}');

    // Mengirim data ke server
    // Mengirim setiap baris CSV secara terpisah
    /*for (String line in lines) {
      List<String> columns = line.split(';');
      String formattedLine = columns.join('\t');
      socket.write(formattedLine);
      socket.write('\n');
    }*/
    socket.write(data);
    // *Bila sukses
    Get.snackbar(
      'Sukses',
      'Data berhasil dikirim ke server',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Menerima respons dari server
    socket.listen((List<int> data) {
      String receivedData = String.fromCharCodes(data);
      print('Respons diterima dari server: $receivedData');

      // Menutup koneksi setelah selesai
      // socket.close();
    });
  }).catchError((error) {
    Get.snackbar(
      'Gagal',
      'Tidak dapat terhubung ke server:  ${error.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  });
}
