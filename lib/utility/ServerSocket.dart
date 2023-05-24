import 'dart:convert';
import 'dart:io';

ServerSocket? serverSocket;

Future<String?> getIp() async {
  List<NetworkInterface> interfaces = await NetworkInterface.list();

  // Memfilter interface yang terhubung dengan jaringan (non-loopback)
  NetworkInterface? networkInterface;
  try {
    networkInterface = interfaces.firstWhere(
      (interface) => interface.addresses.any((addr) => !addr.isLoopback),
    );
  } catch (e) {
    // Penanganan jika tidak ada interface yang ditemukan
    print('Tidak dapat menemukan network interface.');
  }

  // Mendapatkan IP address dari interface yang ditemukan
  /*String? ipAddress;*/
  if (networkInterface != null) {
    return networkInterface.addresses.first.address;
  }
  return "";
}

/*Future <void> getIpAndStartServer() async {
  // Mendapatkan list network interface
  // Menyimpan IP address ke dalam variabel
  String myIpAddress = ipAddress ?? 'Tidak dapat menemukan IP address';
  print('IP address device: $myIpAddress');

  if(ipAddress != null){
    startServer(ipAddress);
  }
}*/
Future<void> startServer(String? ipAddress) async {
  String? alamatIp = ipAddress;
  int portServer = 8888;

  serverSocket = await ServerSocket.bind(alamatIp.toString(), portServer);
  print(
      'Server berjalan di alamat: ${serverSocket!.address}, port: ${serverSocket!.port}');

  serverSocket!.listen((socket) {
    print(
        'Koneksi diterima dari: ${socket.remoteAddress.address}:${socket.remotePort}');

    socket.listen((List<int> data) async {
      String receivedData = utf8.decode(data);
      print('Data diterima dari client: $receivedData');

        /*// *Parse CSV
        List<List<dynamic>> csvData = CsvToListConverter().convert(receivedData);
        print("Ini data csv nya ${csvData}");

        // Get the download directory path
        Directory? downloadDir = await getExternalStorageDirectory();
        if (downloadDir == null) {
          print('Unable to access the download directory.');
          return;
        }

        // Define the file path where you want to save the CSV file
        String downloadPath = '${downloadDir.path}/Download';
        String filePath = '$downloadPath/file.csv';


        // Create the Download folder if it doesn't exist
        Directory downloadsDir = Directory(downloadPath);
        if (!downloadsDir.existsSync()) {
          downloadsDir.createSync(recursive: true);
        }

        // Create a File object
        File file = File(filePath);

        // Write the CSV data to the file
        String csvString = const ListToCsvConverter().convert(csvData);
        await file.writeAsString(csvString, flush: true);
        print('CSV file saved successfully at: $filePath');*/

      // Mengirim respons ke client
      String response = 'Respons dari server';
      socket.write(response);
    });
  }).onError((e) {
    print('Koneksi gagal: $e');
  });
}

void stopServer(){
  serverSocket?.close();
  serverSocket = null;
  print("Server ditutup");
}
