import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirq/sql_helper/sql_helper.dart';
import 'package:kasirq/view/transaction/Checkout.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<Map<String, dynamic>> _produk = [];
  Set<int> selectedIndexes = Set<int>();
  bool _isLoading = true;

  void _refreshProduk() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _produk = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _refreshProduk();
                },
                icon: const Icon(Icons.refresh))
          ],
          title: const Text(
            "Transaksi",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _produk.length > 5 ? 5 : _produk.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                          leading:
                              Image.asset("lib/assets/images/tea_dummy.png"),
                          title: Text(
                            _produk[index]['nama_produk'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Harga: ${_produk[index]['harga']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Stok: ${_produk[index]['stok']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Checkbox(
                            value: selectedIndexes.contains(index),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedIndexes.add(index);
                                } else {
                                  selectedIndexes.remove(index);
                                }
                              });
                            },
                          )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            List<Map<String, dynamic>> selectedProduk = [];
            for (int index in selectedIndexes) {
              selectedProduk.add(_produk[index]);
            }
            Get.to(() => Checkout(selectedProduk: selectedProduk));
          },
          child: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ));
  }
}
