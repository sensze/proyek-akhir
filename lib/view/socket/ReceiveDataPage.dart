import 'package:flutter/material.dart';
import 'package:kasirq/utility/ServerSocket.dart';

class ReceiveDataPage extends StatefulWidget {
  const ReceiveDataPage({Key? key}) : super(key: key);

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
                                  startServer(_ipAddress);
                                  _buttonLabel = "Close Connection";
                                  isServerRunning = true;
                                  _textLabel = "Server berjalan pada: $_ipAddress";
                                }
                              }))
                        },
                    child: Text(_buttonLabel,
                        style: const TextStyle(color: Colors.white)))
              ]),
        ],
      ),
    );
  }
}
