import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirq/view/transaction/Calculator.dart';

import '../../sql_helper/sql_helper.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key, required this.selectedProduk}) : super(key: key);
  final List<Map<String, dynamic>> selectedProduk;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
  List<int> quantities = [];
  int totalHarga = 0;

  @override
  void initState() {
    super.initState();
    initializeQuantities();
  }

  void initializeQuantities() {
    quantities = List<int>.filled(widget.selectedProduk.length, 1);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.selectedProduk.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final produk = widget.selectedProduk[index];
                final quantity = quantities[index];
                final harga = int.parse(produk['harga']);
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Image.asset("lib/assets/images/tea_dummy.png"),
                    title: Text(
                      produk['nama_produk'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Harga: ${formatCurrency.format(harga)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Stok: ${produk['stok']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                quantities[index] = quantity - 1;
                              }
                            });
                          },
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantities[index] = quantity + 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _updateStock(widget.selectedProduk, quantities);
                    Get.to(Calculator(quantity: quantities.length, totalHarga: calculateTotalHarga(),));
                  },
                  child: Text(
                    "Checkout: Rp. ${calculateTotalHarga()}",
                    style: const TextStyle(
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

  int calculateTotalHarga() {
    int totalHarga = 0;
    for (int i = 0; i < widget.selectedProduk.length; i++) {
      final produk = widget.selectedProduk[i];
      final harga = produk['harga'] ?? 0;
      final hargaToInt = int.parse(harga);
      final quantity = quantities[i];
      totalHarga += hargaToInt * quantity;
    }
    return totalHarga;
  }
}

void _updateStock(List<Map<String, dynamic>> selectedProduk, List<int> quantities) async {
  for (int i = 0; i < selectedProduk.length; i++) {
    final produk = selectedProduk[i];
    final quantity = quantities[i];
    final currentStock = int.parse(produk['stok'] ?? 0);
    final newStock = currentStock - quantity;
    final newStockStr = newStock.toString();

    // Update the stock in the database
    await SQLHelper.updateStock(produk['id'], newStockStr);
  }
}


