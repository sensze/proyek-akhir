import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirq/view/dashboard/dashboard.dart';
import 'package:lottie/lottie.dart';

class PaymentConfirmation extends StatefulWidget {
  const PaymentConfirmation(
      {Key? key,
      required this.kembalian,
      required this.uang,
      required this.totalHarga})
      : super(key: key);
  final int totalHarga;
  final double uang;
  final double kembalian;

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("lib/assets/anim/payment-success.json",
                    repeat: false, width: 375, height: 375),
                Text(
                  'Total Harga: ${formatCurrency.format(widget.totalHarga)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jumlah Uang: ${formatCurrency.format(widget.uang)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kembalian: -${formatCurrency.format(widget.kembalian)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(const Dashboard());
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: const Text(
                    'Kembali ke Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
