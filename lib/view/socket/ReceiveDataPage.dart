import 'package:flutter/material.dart';
import 'package:kasirq/utility/ServerSocket.dart';

class ReceiveDataPage extends StatefulWidget {
  ReceiveDataPage({Key? key, required this.source}) : super(key: key);
  String source;

  @override
  State<ReceiveDataPage> createState() => _ReceiveDataPageState();
}

class _ReceiveDataPageState extends State<ReceiveDataPage> {
  String? _ipAddress = "";
  String _buttonLabel = "Receive Data";
  String _textLabel = "";
  bool isServerRunning = false;

  @override
  void initState() {
    super.initState();
    // Mendapatkan data awal, jika diperlukan
    getInitialData();
  }

  void getInitialData() async {
    _ipAddress = await getIp();
    setState(() {
      isServerRunning = true;
      _textLabel = "Server berjalan pada: $_ipAddress";
      _buttonLabel = "Close Connection";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terima Data',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_textLabel),
                ElevatedButton(
                    onPressed: () => {
                          getIp().then((value) => setState(() {
                                if (isServerRunning) {
                                  stopServer();
                                  _buttonLabel = "Receive Data";
                                  isServerRunning = false;
                                  _textLabel = "";
                                } else {
                                  _ipAddress = value;
                                  _buttonLabel = "Close Connection";
                                  isServerRunning = true;
                                  _textLabel =
                                      "Server berjalan pada: $_ipAddress";
                                  if (widget.source == 'produk') {
                                    startServer(_ipAddress, 'produk');
                                  } /*else if (widget.source == 'transaksi') {
                                    startServer(_ipAddress, 'transaksi');
                                  }*/
                                  else {
                                    startServer(_ipAddress, 'transaksi');
                                  }
                                }
                              }))
                        },
                    child: Text(_buttonLabel,
                        style: const TextStyle(color: Colors.white))),
                const SizedBox(height: 10),
                const Text("*NB: Tekan kembali tombol apabila terjadi error", style: TextStyle(color: Colors.grey)),
              ]),
        ],
      ),
    );
  }
}
