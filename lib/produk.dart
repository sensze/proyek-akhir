import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sqlitecase/sql_helper/sql_helper_produk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class Produk extends StatefulWidget {
  const Produk({Key? key}) : super(key: key);

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  List<Map<String, dynamic>> _produk = [];
  bool _isLoading = true;
  String? _filePath;

  void _refreshProduk() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _produk = data;
      _isLoading = false;
      print(_produk);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshProduk();
    print("Total data: ${_produk.length + 1}");
  }

  final TextEditingController _namaProdukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kodeBarcodeController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  void importCSV() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    //File kosong
    if (result == null) return;
    print(result.files.first.name);

    _filePath = result.files.single.path;

    final input = File(_filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);
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
      };
      await db.insert('produk', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    _refreshProduk();
  }

  void exportCSV() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    print(statuses);

    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    row.add("id");
    row.add("nama_produk");
    row.add("harga");
    row.add("kode_barcode");
    row.add("stok");
    row.add("deskripsi");
    row.add("created_at");
    rows.add(row);

    for (int i = 0; i < _produk.length; i++) {
      List<dynamic> row = [];
      row.add(_produk[i]["id"] - 1);
      row.add(_produk[i]["nama_produk"]);
      row.add(_produk[i]["harga"]);
      row.add(_produk[i]["kode_barcode"]);
      row.add(_produk[i]["stok"]);
      row.add(_produk[i]["deskripsi"]);
      row.add(_produk[i]["created_at"]);
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
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _namaProdukController.text,
        _hargaController.text,
        _kodeBarcodeController.text,
        _stokController.text,
        _deskripsiController.text);
    _refreshProduk();
    print("Jumlah Produk: ${_produk.length + 1}");
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id,
        _namaProdukController.text,
        _hargaController.text,
        _kodeBarcodeController.text,
        _stokController.text,
        _deskripsiController.text);
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingProduct =
          _produk.firstWhere((element) => element['id'] == id);
      _namaProdukController.text = existingProduct['nama_produk'];
      _hargaController.text = existingProduct['harga'];
      _kodeBarcodeController.text = existingProduct['kode_barcode'];
      _stokController.text = existingProduct['stok'];
      _deskripsiController.text = existingProduct['deskripsi'];
      _refreshProduk();
    }
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 120),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _namaProdukController,
                    decoration: const InputDecoration(
                      hintText: 'Nama Produk',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _hargaController,
                    decoration: const InputDecoration(
                      hintText: 'Harga',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _kodeBarcodeController,
                    decoration: const InputDecoration(
                      hintText: 'Kode Barcode',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _stokController,
                    decoration: const InputDecoration(
                      hintText: 'Stok',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(
                      hintText: 'Deskripsi',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }
                      if (id != null) {
                        await _updateItem(id);
                      }
                      //Clear Form
                      _namaProdukController.text = '';
                      _hargaController.text = '';
                      _kodeBarcodeController.text = '';
                      _stokController.text = '';
                      _deskripsiController.text = '';

                      //Bottomsheet Close
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Tambah' : 'Update'),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studi Kasus SQLITE'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.upload,
              color: Colors.white,
            ),
            onPressed: () {
              exportCSV();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: () {
              importCSV();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            // physics: NeverScrollableScrollPhysics(),
            itemCount: _produk.length,
            itemBuilder: (context, index) {
              final item = _produk[index];
              return Container(
                height: 500,
                child: Card(
                  elevation: 3,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.blue),
                      ),
                      Text(item['nama_produk']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              _showForm(item['id']);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              await SQLHelper.deleteItem(item['id']);
                              _refreshProduk();
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
