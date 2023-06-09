import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../sql_helper/sql_helper.dart';

class CsvImporter {
  Future<void> importCSV(String source) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    //File kosong
    if (result == null) return;

    final filePath = result.files.single.path;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);
    if(source == 'produk'){
      final db = await SQLHelper.db();
      for (var i = 1; i < fields.length; i++) {
        var data = {
          'nama_produk': fields[i][0],
          'harga': fields[i][1],
          'kode_barcode': fields[i][2],
          'stok': fields[i][3],
          'deskripsi': fields[i][4],
          'created_at': fields[i][5],
          'updated_at': fields[i][6],
        };
        await db.insert('produk', data,
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    } else if(source == 'transaksi'){
      final db = await SQLHelper.db();
      for (var i = 1; i < fields.length; i++) {
        var data = {
          'total_item': fields[i][0],
          'total_harga': fields[i][1],
          'bayar': fields[i][2],
          'diterima': fields[i][3],
          'created_at': fields[i][4],
          'updated_at': fields[i][5],
        };
        await db.insert('penjualan', data,
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
  }
}
