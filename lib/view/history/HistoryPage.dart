import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../sql_helper/sql_helper.dart';
import '../../utility/CsvExporter.dart';
import '../../utility/CsvImporter.dart';
import '../socket/ReceiveDataPage.dart';
import '../socket/SendDataPage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _transaksi = [];
  bool _isLoading = true;
  String? _filePath;

  void _refreshTransaksi() async {
    final data = await SQLHelper.getTransaksi();
    setState(() {
      _transaksi = data;
      _isLoading = false;
      // print(_transaksi);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTransaksi();
    // print("Total data: ${_produk.length + 1}");
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaksi',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.upload,
              color: Colors.white,
            ),
            onPressed: () => {Get.to(() => SendDataPage(source: 'transaksi'))},
          ),
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: () => {
              Get.to(() => ReceiveDataPage(
                    source: 'transaksi',
                  ))
            },
          ),
          IconButton(
              onPressed: _refreshTransaksi,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          CsvImporter importer = CsvImporter();
                          await importer.importCSV('transaksi');
                          _refreshTransaksi();
                        },
                        child: const Text(
                          "Import CSV",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          CsvExporter exporter = CsvExporter(_transaksi);
                          await exporter.exportCSV('transaksi');
                        },
                        child: const Text(
                          "Export CSV",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _transaksi.length,
                  itemBuilder: (context, index) {
                    var totalHarga =
                        int.parse(_transaksi[index]['total_harga']);
                    var jumlahBayar = double.parse(_transaksi[index]['bayar']);
                    var kembalian = double.parse(_transaksi[index]['diterima']);
                    var tanggal =
                        DateTime.parse(_transaksi[index]['created_at']);
                    String tanggalParsed = DateFormat()
                        .addPattern("EEEE, dd MMMM yyyy")
                        .format(tanggal);

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading:
                              Image.asset("lib/assets/images/tea_dummy.png"),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ID Transaksi: ${_transaksi[index]['id_penjualan'].toString()}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(
                                height: 10,
                                thickness: 2,
                              ),
                              Text(
                                "Total Harga: ${formatCurrency.format(totalHarga)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jumlah Uang: ${formatCurrency.format(jumlahBayar)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Kembalian: ${formatCurrency.format(kembalian)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "Tanggal: ${tanggalParsed}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
