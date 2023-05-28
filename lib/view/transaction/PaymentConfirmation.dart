import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                Lottie.asset("lib/assets/anim/payment-success.json", width: 375, height: 375),
                Text('Total Harga: ${widget.totalHarga}'),
                Text('Uang: ${widget.uang}'),
                Text('Kembalian: ${widget.kembalian}'),
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
