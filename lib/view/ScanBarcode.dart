import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanBarcode extends StatelessWidget {
  const ScanBarcode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode Dummy Page'),
      ),
      body: const Center(
        child: Text('Scan Barcode'),
      ),
    );
  }
}
