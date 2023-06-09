import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirq/sql_helper/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

ServerSocket? serverSocket;

Future<String?> getIp() async {
  List<NetworkInterface> interfaces = await NetworkInterface.list();

  // Memfilter interface yang terhubung dengan jaringan (non-loopback)
  NetworkInterface? networkInterface;
  try {
    networkInterface = interfaces.firstWhere(
      (interface) => interface.addresses.any((addr) => !addr.isLoopback),
    );
  } catch (e) {
    // Penanganan jika tidak ada interface yang ditemukan
    print('Tidak dapat menemukan network interface.');
  }

  // Mendapatkan IP address dari interface yang ditemukan
  /*String? ipAddress;*/
  if (networkInterface != null) {
    return networkInterface.addresses.first.address;
  }
  return "";
}

/*Future <void> getIpAndStartServer() async {
  // Mendapatkan list network interface
  // Menyimpan IP address ke dalam variabel
  String myIpAddress = ipAddress ?? 'Tidak dapat menemukan IP address';
  print('IP address device: $myIpAddress');

  if(ipAddress != null){
    startServer(ipAddress);
  }
}*/
Future<void> startServer(String? ipAddress, String source) async {
  String? alamatIp = ipAddress;
  int portServer = 8888;

  serverSocket = await ServerSocket.bind(alamatIp.toString(), portServer);
  print(
      'Server berjalan di alamat: ${serverSocket!.address}, port: ${serverSocket!.port}');

  serverSocket!.listen((socket) {
    print(
        'Koneksi diterima dari: ${socket.remoteAddress.address}:${socket.remotePort}');

    socket.listen((List<int> data) async {
      /*String receivedData = utf8.decode(data);
      print('Data diterima dari client: $receivedData');

      List<dynamic> jsonData = json.decode(receivedData);
      print("Ini data json nya ${jsonData}");*/

      String receivedData = utf8.decode(data);
      print('Data diterima dari client: $receivedData');

      List<dynamic> jsonData = json.decode(receivedData);
      print("Ini data json nya ${jsonData}");

      if (source == 'produk') {
        final db = await SQLHelper.db();
        for (var dataItem in jsonData) {
          Map<String, dynamic> dataMap = Map<String, dynamic>.from(dataItem);
          await db.insert('produk', dataMap,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        Get.snackbar(
          'Sukses',
          'Data transaksi berhasil diterima',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }else{
        final db = await SQLHelper.db();
        for (var dataItem in jsonData) {
          Map<String, dynamic> dataMap = Map<String, dynamic>.from(dataItem);
          await db.insert('penjualan', dataMap,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        Get.snackbar(
          'Sukses',
          'Data transaksi berhasil diterima',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      /*// *Parse CSV
        List<List<dynamic>> csvData = CsvToListConverter().convert(receivedData);
        print("Ini data csv nya ${csvData}");

        // Get the download directory path
        Directory? downloadDir = await getExternalStorageDirectory();
        if (downloadDir == null) {
          print('Unable to access the download directory.');
          return;
        }

        // Define the file path where you want to save the CSV file
        String downloadPath = '${downloadDir.path}/Download';
        String filePath = '$downloadPath/file.csv';


        // Create the Download folder if it doesn't exist
        Directory downloadsDir = Directory(downloadPath);
        if (!downloadsDir.existsSync()) {
          downloadsDir.createSync(recursive: true);
        }

        // Create a File object
        File file = File(filePath);

        // Write the CSV data to the file
        String csvString = const ListToCsvConverter().convert(csvData);
        await file.writeAsString(csvString, flush: true);
        print('CSV file saved successfully at: $filePath');*/

      // Mengirim respons ke client
      String response = 'Respons dari server';
      socket.write(response);
    });
  }).onError((error) {
    Get.snackbar(
      'Gagal',
      'Tidak dapat terhubung ke client:  ${error.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  });
}

void stopServer() {
  serverSocket?.close();
  serverSocket = null;
  print("Server ditutup");
}
