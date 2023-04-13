import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sqlitecase/produk.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                padding: EdgeInsets.only(top: 60),
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: Container(
                  color: Color(0xffF0F0F0),
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
                borderRadius: BorderRadius.only(
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
                    padding: EdgeInsets.only(top: 400),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: inputFile(
                        label: "Email",
                        obscureText: false,
                        controllerVar: TextEditingController(),
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
                        label: "Nama",
                        obscureText: false,
                        controllerVar: TextEditingController(),
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
                      controllerVar: TextEditingController(),
                    ),
                  )),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 710),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 12,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarySwatches,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () => Get.off(Produk()),
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

Widget inputFile({label, obscureText = false, controllerVar}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Material(
        //drop shadow
        elevation: 0.5,
        // shadowColor: Color(0xff6DC657),
        child: TextField(
          controller: controllerVar,
          //obscuretext untuk menyembunyikan password
          obscureText: obscureText,
          decoration: InputDecoration(
              hintText: label,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff6DC657)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              )),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
