import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class CsvExporter {
  final List<Map<String, dynamic>> produk;

  CsvExporter(this.produk);

  Future<void> exportCSV() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final statuses = await Permission.storage.status;
      print(statuses);
    } else {
      Fluttertoast.showToast(
          msg: "Izin tidak diberikan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    }

    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    row.add("nama_produk");
    row.add("harga");
    row.add("kode_barcode");
    row.add("stok");
    row.add("deskripsi");
    row.add("created_at");
    row.add("updated_at");
    rows.add(row);

    for (int i = 0; i < produk.length; i++) {
      List<dynamic> row = [];
      row.add(produk[i]["nama_produk"]);
      row.add(produk[i]["harga"]);
      row.add(produk[i]["kode_barcode"]);
      row.add(produk[i]["stok"]);
      row.add(produk[i]["deskripsi"]);
      row.add(produk[i]["created_at"]);
      row.add(produk[i]["updated_at"]);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";

    File f = File(file + "/produk.csv");

    f.writeAsString(csv);

    Fluttertoast.showToast(
        msg: "File CSV telah tersimpan di ${file}/produk.csv",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}