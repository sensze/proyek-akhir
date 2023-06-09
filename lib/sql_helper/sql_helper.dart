import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS produk (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    nama_produk TEXT, 
    harga TEXT, 
    kode_barcode TEXT, 
    stok TEXT, 
    deskripsi TEXT,
    created_at TEXT,
    updated_at TEXT
    )
    """);
    await database.execute("""CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    username TEXT,
    email TEXT,
    password TEXT,
    created_at TEXT,
    updated_at TEXT
    )
    """);
    await database.execute("""CREATE TABLE IF NOT EXISTS penjualan (
    id_penjualan INTEGER PRIMARY KEY AUTOINCREMENT, 
    total_item TEXT,
    total_harga TEXT,
    bayar TEXT,
    diterima TEXT,
    created_at TEXT,
    updated_at TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'kasirq.db',
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
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
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
      'updated_at': DateTime.now().toString(),
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

  static Future<int> updateStock(int id, String stok) async {
    final db = await SQLHelper.db();
    final data = {
      'stok': stok,
    };
    final result =
    await db.update('produk', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

//Method menambahkan user
  static Future<int> createUser(String username, String email,
      String password) async {
    final db = await SQLHelper.db();
    final data = {
      'username': username,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    };
    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    return id;
  }

// Method penjualan
  static Future<int> createPenjualan(String total_item, String total_harga,
      String bayar, String diterima) async {
    final db = await SQLHelper.db();
    final data = {
      'total_item': total_item,
      'total_harga': total_harga,
      'bayar': bayar,
      'diterima': diterima,
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    };
    final id = await db.insert('penjualan', data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    return id;
  }
  static Future<List<Map<String, dynamic>>> getTransaksi() async {
    final db = await SQLHelper.db();
    return db.query('penjualan', orderBy: 'id_penjualan');
  }
}

