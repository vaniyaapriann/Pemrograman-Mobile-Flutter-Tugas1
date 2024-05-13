import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
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
                  Text('Add more User',
                  style: GoogleFonts.urbanist(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),),
                  Text('Enter your personal informations!',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.black,
                  ),),

                  //Kolom No Induk
                  SizedBox( 
                    height: 30,),
                  Row(
                    children: [
                      Text('No Induk',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),),
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
                    height: 30,),
                  Row(
                    children: [
                      Text('Fullname',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),),
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
                    height: 30,),
                  Row(
                    children: [
                      Text('Address',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),),
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
                  height: 20,),
                Row(
                  children: [
                    Text('Date of Birth',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.black,
                    ),),
                  ],
                ),
                Container(
                  width: 2000,
                  height: 40,
                  child: MyTextFields(
                    controller: tanggalLahirController, 
                    hintText: 'Date of Birth', 
                    obscureText: false,
                  ),
                ),

                //Kolom Phone
                SizedBox(
                  height: 20,),
                Row(
                  children: [
                    Text('Phone',
                    style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.black,
                    ),),
                  ],
                ),
                Container(
                  width: 2000,
                  height: 40,
                  child:  MyTextFields(
                    controller: phoneController, 
                    hintText: 'Phone', 
                    obscureText: false,
                  ),
                ),

                //tombol add
                SizedBox(
                  height: 50,),
                Container(
                  width: 350,
                  height: 50,
                  child: 
                  ElevatedButton(
                    onPressed: () {
                      goAddUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 28, 95, 30)),
                        borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(255, 28, 95, 30),
                    ), 
                    child: 
                    Text('Add User',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                      ),
                    )
                  ),
                ),
              ],
            ), 
          ),
        ),
        backgroundColor: Colors.white,   
     );
    }

void goAddUser(BuildContext context) async {
  try {
    final _response = await _dio.post(
      '${_apiUrl}/anggota',
      options: Options(
        headers: {'Authorization': 'Bearer ${_storage.read('token')}'}
      ),
      data: {
        'nomor_induk': noIndukController.text,
        'nama': namaController.text,
        'alamat': alamatController.text,
        'tgl_lahir': tanggalLahirController.text,
        'telepon': phoneController.text,
        'status_aktif': 1,
      }
    );      
    _storage.write('data', _response.data['data']);
     if (_response.statusCode == 200) {
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
                    Navigator.pushNamed(context, '/home'); // Navigasi ke halaman beranda
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to add. Please try again later."),
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
    } on DioError catch (e) {
      // Handle jika terjadi kesalahan
      print('${e.response} - ${e.response?.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to add member. Please try again later."),
            actions: <Widget>[
              MaterialButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}