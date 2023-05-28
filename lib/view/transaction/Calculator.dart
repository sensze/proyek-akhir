import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirq/sql_helper/sql_helper.dart';
import 'package:kasirq/view/transaction/PaymentConfirmation.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.totalHarga, required this.quantity})
      : super(key: key);
  final int totalHarga;
  final int quantity;
  final double change = 0.0;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
  TextEditingController textEditingController = TextEditingController();
  double inputValue = 0.0;

  @override
  Widget build(BuildContext context) {
    double kembalian =
        inputValue >= widget.totalHarga ? inputValue - widget.totalHarga : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Total: ${formatCurrency.format(widget.totalHarga)}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  inputValue = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Masukkan jumlah uang',
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Kembalian : ${formatCurrency.format(kembalian)}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    importDataTransaksi(
                        widget.quantity.toString(),
                        widget.totalHarga.toString(),
                        inputValue.toString(),
                        kembalian.toString());
                    Get.to(PaymentConfirmation(
                      totalHarga: widget.totalHarga,
                      uang: inputValue,
                      kembalian: kembalian,
                    ));
                  },
                  child: const Text(
                    "Bayar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> importDataTransaksi(String total_item, String total_harga,
    String bayar, String diterima) async {
  final db =
      await SQLHelper.createPenjualan(total_item, total_harga, bayar, diterima);
  final data = await SQLHelper.getTransaksi();
  print(data);
  if (db != 0) {
    Get.snackbar(
      'Sukses',
      'Data berhasil disimpan',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } else {
    Get.snackbar(
      'Gagal',
      'Data gagal disimpan',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
