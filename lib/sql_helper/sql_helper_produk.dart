import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS produk (
    id INTEGER PRIMARY KEY, 
    nama_produk TEXT, 
    harga TEXT, 
    kode_barcode TEXT, 
    stok TEXT, 
    deskripsi TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'produk.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        // print("Create DB...");
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String nama_produk, String harga,
      String kode_barcode, String stok, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {
      'nama_produk': nama_produk,
      'harga': harga,
      'kode_barcode': kode_barcode,
      'stok': stok,
      'deskripsi': deskripsi,
    };
    final id = await db.insert('produk', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('produk', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('produk', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String nama_produk, String harga,
      String kode_barcode, String stok, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {
      'nama_produk': nama_produk,
      'harga': harga,
      'kode_barcode': kode_barcode,
      'stok': stok,
      'deskripsi': deskripsi,
      'created_at': DateTime.now().toString(),
    };
    final result =
        await db.update('produk', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('produk', where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      debugPrint("Something error when deleting your product: $error");
    }
  }
}
