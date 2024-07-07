import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';


class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  int _selectedIndex = 3;

  String _name= '';
  String _email='';

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    goDetail(context);
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Bagian Profile
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                    backgroundColor: Colors.white,
                  ) ,
                ),
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade100,
                      ),
                      child: Text(
                        _name,
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade100,
                      ),
                      child: Text(
                        _email,
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                //tombol logout
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: 350,
                  height: 50,
                  child: 
                  ElevatedButton(
                    onPressed: () {
                      goLogout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 28, 95, 30)),
                        borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(255, 28, 95, 30),
                    ), 
                    child: 
                    Text('Log Out',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    )
                  ),
                ), 
              ],
            ),
          ),
        ),
      ),

      //tombol Navbar
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromARGB(255, 28, 95, 30),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/listuser');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/listbunga');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: _selectedIndex == 1 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Member',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist, color: _selectedIndex == 2 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Bunga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _selectedIndex == 3 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  void goDetail(BuildContext context) async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (_response.statusCode == 200) {
        Map<String, dynamic> responseData = _response.data;
        Map<String, dynamic> userData = responseData['data']['user'];

      // Tanggapan berhasil, lanjutkan dengan pemrosesan data
        String name = userData['name'];
        String email = userData['email'];

        setState(() {
          _name = name;
          _email = email;
        }
      );
      } else {
        // Tanggapan tidak berhasil, tampilkan pesan kesalahan atau tindakan yang sesuai
        print('Error: API request failed: ${_response.statusCode}');
      }
    } on DioException catch (e) {
    print('${e.response} - ${e.response?.statusCode}');
    }
  }

  void goLogout(BuildContext context) async {
    try{
      final _response = await _dio.get(
        '${_apiUrl}/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(_response.data);
      Navigator.pushNamed(context, '/');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}