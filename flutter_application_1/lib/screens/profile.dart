import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String _name = '';
  String _email = '';

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
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.urbanist(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Assuming a light app bar background
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        backgroundColor: Colors.blueGrey[800], // Example color change
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile section (highly customizable)
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Ubah menjadi MainAxisAlignment.start
                children: [
                  CircleAvatar(
                    radius: 50.0, // Sesuaikan ukuran avatar
                    backgroundColor: Colors.grey[200],
                    backgroundImage: AssetImage(
                      'assets/images/avatar.jpg',
                    ),
                  ),

                  SizedBox(
                      width:
                          20.0), // Tambahkan widget SizedBox untuk mengatur jarak antara gambar dan teks
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: GoogleFonts.urbanist(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _email,
                        style: GoogleFonts.urbanist(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.0), // Adjust spacing
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Indeks item yang terpilih secara default
        onTap: (int index) {
          // Aksi ketika item bottom navigation di-tap
          if (index == 0) {
            // Jika item dengan indeks 0 (home) di-tap
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            // Jika item dengan indeks 1 (transaksi) di-tap
            // Lakukan apa yang diperlukan untuk transaksi
            print('Transaksi button tapped');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Transaksi',
          ),
        ],
      ),
    );
  }

  void goDetail(BuildContext context) async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/user',
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
        });
      } else {
        // Tanggapan tidak berhasil, tampilkan pesan kesalahan atau tindakan yang sesuai
        print('Error: API request failed: ${_response.statusCode}');
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
