import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:flutter_application_1/screens/User.dart/listUser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class addUser extends StatefulWidget {
  addUser({super.key});

  @override
  State<addUser> createState() => _addUserState();
}

class _addUserState extends State<addUser> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  //text editing controllers
  final noIndukController = TextEditingController();
  final namaController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final alamatController = TextEditingController();
  final phoneController = TextEditingController();
  final statusController = TextEditingController();

  // Metode untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        tanggalLahirController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              //Tulisan Register
              Text(
                'Add more User',
                style: GoogleFonts.urbanist(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Enter your personal informations!',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),

              //Kolom No Induk
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    'No Induk',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width: 2000,
                height: 40,
                child: MyTextFields(
                  controller: noIndukController,
                  hintText: 'No Induk',
                  obscureText: false,
                ),
              ),

              //Kolom Fullname
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    'Fullname',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width: 2000,
                height: 40,
                child: MyTextFields(
                  controller: namaController,
                  hintText: 'Fullname',
                  obscureText: false,
                ),
              ),

              //Kolom Alamat
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    'Address',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width: 2000,
                height: 40,
                child: MyTextFields(
                  controller: alamatController,
                  hintText: 'Address',
                  obscureText: false,
                ),
              ),

              //Kolom Date of Birth
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Date of Birth',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: Container(
                    width: 2000,
                    height: 40,
                    child: MyTextFields(
                      controller: tanggalLahirController,
                      hintText: 'Date of Birth',
                      obscureText: false,
                    ),
                  ),
                ),
              ),

              //Kolom Phone
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Phone',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width: 2000,
                height: 40,
                child: MyTextFields(
                  controller: phoneController,
                  hintText: 'Phone',
                  obscureText: false,
                ),
              ),

              //tombol add
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  showConfirmationDialog();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 28, 95, 30)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Color.fromARGB(255, 28, 95, 30),
                ),
                child: Text(
                  'Submit',
                  style:
                      GoogleFonts.urbanist(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content:
              Text('Are you sure you want to add user ${namaController.text}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
               // Navigator.of(context).pop();
                goAddUser(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void goAddUser(BuildContext context) async {
    try {
      final _response = await _dio.post(
        '${_apiUrl}/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'nomor_induk': noIndukController.text,
          'nama': namaController.text,
          'alamat': alamatController.text,
          'tgl_lahir': tanggalLahirController.text,
          'telepon': phoneController.text,
          'status_aktif': 0,
        },
      );

      print('Response data: ${_response.data}'); // Log response data

      if (_response.statusCode == 200) {
        print(
            'Success: User has been successfully added.'); // Pesan di debug console
        showSuccessDialog(context);
      } else {
        print(
            'Error: Failed to add user - Status Code: ${_response.statusCode}'); // Log error message
        showErrorDialog(context);
      }
    } on DioError catch (e) {
      print(
          'DioError: ${e.response?.data} - Status Code: ${e.response?.statusCode}'); // Log error message
      showErrorDialog(context);
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("User has been successfully added."),
          actions: <Widget>[
            MaterialButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => listUser()),
                  );
                }),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Failed to add user. Please try again later."),
          actions: <Widget>[
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}
