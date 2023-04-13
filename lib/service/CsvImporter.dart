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
  Future<void> importCSV() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    //File kosong
    if (result == null) return;

    final filePath = result.files.single.path;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    final db = await SQLHelper.db();
    for (var i = 1; i < fields.length; i++) {
      var data = {
        'id': fields[i][0],
        'nama_produk': fields[i][1],
        'harga': fields[i][2],
        'kode_barcode': fields[i][3],
        'stok': fields[i][4],
        'deskripsi': fields[i][5],
        'created_at': fields[i][6],
        'updated_at': fields[i][7],
      };
      await db.insert('produk', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
