import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class CsvExporter {
  final List<Map<String, dynamic>> data;

  CsvExporter(this.data);

  Future<void> exportCSV(String source) async {
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

    if (source == 'produk') {
      row.add("nama_produk");
      row.add("harga");
      row.add("kode_barcode");
      row.add("stok");
      row.add("deskripsi");
      row.add("created_at");
      row.add("updated_at");
      rows.add(row);

      for (int i = 0; i < data.length; i++) {
        List<dynamic> row = [];
        row.add(data[i]["nama_produk"]);
        row.add(data[i]["harga"]);
        row.add(data[i]["kode_barcode"]);
        row.add(data[i]["stok"]);
        row.add(data[i]["deskripsi"]);
        row.add(data[i]["created_at"]);
        row.add(data[i]["updated_at"]);
        rows.add(row);
      }
      String csv = const ListToCsvConverter().convert(rows);

      String dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      print("dir $dir");
      String file = "$dir";

      File f = File("$file/produk.csv");

      f.writeAsString(csv);

      f.writeAsString(csv);
      Fluttertoast.showToast(
          msg: "File CSV telah tersimpan di $file/penjualan.csv",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);

    } else if (source == 'transaksi') {
      row.add("total_item");
      row.add("total_harga");
      row.add("bayar");
      row.add("diterima");
      row.add("created_at");
      row.add("updated_at");
      rows.add(row);

      for (int i = 0; i < data.length; i++) {
        List<dynamic> row = [];
        row.add(data[i]["total_item"]);
        row.add(data[i]["total_harga"]);
        row.add(data[i]["bayar"]);
        row.add(data[i]["diterima"]);
        row.add(data[i]["created_at"]);
        row.add(data[i]["updated_at"]);
        rows.add(row);
      }

      String csv = const ListToCsvConverter().convert(rows);

      String dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      print("dir $dir");
      String file = "$dir";

      File f = File("$file/penjualan.csv");

      f.writeAsString(csv);
      Fluttertoast.showToast(
          msg: "File CSV telah tersimpan di $file/penjualan.csv",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }
}
