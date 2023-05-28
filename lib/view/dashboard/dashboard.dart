import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirq/view/productpage/produk.dart';
import 'package:kasirq/view/transaction/Transaction.dart';

import '../../sql_helper/sql_helper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> _produk = [];
  bool _isLoading = true;
  String dateNow =
  DateFormat().addPattern("EEEE, dd MMMM yyyy").format(DateTime.now());

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
    // print("Total data: ${_produk.length + 1}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateNow,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Beranda",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(115, 90),
                            primary: const Color(0xFFFDEBD1),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => const Transaction());
                          },
                          child: SvgPicture.asset(
                            "lib/assets/icons/ic_transaction.svg",
                            height: 60,
                            width: 60,
                            color: const Color(0xFFF7B551),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Transaksi",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(115, 90),
                            primary: const Color(0xFFFFD2CC),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {

                          },
                          child: SvgPicture.asset(
                            "lib/assets/icons/ic_history.svg",
                            height: 50,
                            width: 50,
                            color: const Color(0xFFFF5453),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Riwayat",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(115, 90),
                            primary: const Color(0xFFD7FADB),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => const Produk());
                          },
                          child: SvgPicture.asset(
                            "lib/assets/icons/ic_box.svg",
                            height: 60,
                            width: 60,
                            color: const Color(0xFF38E54D),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Produk",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Produk",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => {_refreshProduk()},
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
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
                      leading: Image.asset("lib/assets/images/tea_dummy.png"),
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
                    trailing: IconButton(
                      onPressed: () {
                        Get.to(const Produk());
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
