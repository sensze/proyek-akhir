import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:kasirq/sql_helper/sql_helper.dart';
import 'package:kasirq/view/dashboard/dashboard.dart';
import 'package:kasirq/view/productpage/produk.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const primarySwatches = Color(0xff6DC657);
    double sBoxValue = 24;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset('lib/assets/images/substract.png'),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Image.asset(
                  'lib/assets/images/art_1.png',
                  height: 220,
                  width: 220,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 300),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: Container(
                  color: const Color(0xffF0F0F0),
                  height: 500,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 320),
                child: Text.rich(TextSpan(
                    text: "Buat Akun Baru",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.5)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 380),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: Container(
                  color: Colors.white,
                  height: 500,
                ),
              ),
            ),
            Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 400),
                    child: Text.rich(
                      TextSpan(
                        text: "Gunakan email anda",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ))),
            Padding(
              padding: const EdgeInsets.only(top: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: inputFile(
                            label: "Email",
                            obscureText: false,
                            controllerVar: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                errorAlert("Email tidak boleh kosong");
                              } else if (!_isValidEmail(value)) {
                                errorAlert("Email tidak valid");
                              }
                              return null;
                            }),
                      ),
                    ),
                    SizedBox(
                      height: sBoxValue,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: inputFile(
                          label: "Nama",
                          obscureText: false,
                          controllerVar: _namaController,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sBoxValue,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: inputFile(
                        label: "Password",
                        obscureText: true,
                        controllerVar: _passwordController,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 760),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 12,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarySwatches,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Validasi berhasil, pindah ke halaman berikutnya
                              final database = await SQLHelper.createUser(
                                  _namaController.text,
                                  _emailController.text,
                                  _passwordController.text);
                              if (database != null) {
                                successAlert("Berhasil membuat akun");
                                Get.off(() => const Dashboard());
                              } else {
                                Get.snackbar("Error", "Gagal membuat akun",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }
                            }
                          },
                          child: const Text(
                            "Buat Akun",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

Widget inputFile({
  label,
  obscureText = false,
  controllerVar,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Material(
        //drop shadow
        elevation: 0.5,
        // shadowColor: Color(0xff6DC657),
        child: TextFormField(
          controller: controllerVar,
          validator: validator,
          //obscuretext untuk menyembunyikan password
          obscureText: obscureText,
          decoration: InputDecoration(
              hintText: label,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff6DC657)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              )),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}

// *Email validation
bool _isValidEmail(String value) {
  // Regex pattern untuk memeriksa format email
  const pattern =
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
  final regex = RegExp(pattern);
  return regex.hasMatch(value);
}

Widget errorAlert(String errorMsg) {
  const primarySwatches = Color(0xff6DC657);
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xFF9BA4B5),
          ),
          child: Lottie.asset(
            "lib/assets/anim/error.json",
            height: 150,
            width: 150,
          ),
        ),
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Gagal!",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
                ),
                const SizedBox(height: 10),
                Text(errorMsg,
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF9BA4B5))),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySwatches,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("OK", style: TextStyle(color: Colors.white),))
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget successAlert(String errorMsg) {
  const primarySwatches = Color(0xff6DC657);
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xFF9BA4B5),
          ),
          child: Lottie.asset(
            "lib/assets/anim/success.json",
          ),
        ),
        Container(
          height: 170,
          width: 270,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Sukses!",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
                ),
                const SizedBox(height: 10),
                Text(errorMsg,
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF9BA4B5))),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySwatches,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("OK", style: TextStyle(color: Colors.white),))
              ],
            ),
          ),
        ),
      ],
    ),
  );
}