import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSettingBungaPage extends StatefulWidget {
  const AddSettingBungaPage({Key? key}) : super(key: key);

  @override
  _AddSettingBungaPageState createState() => _AddSettingBungaPageState();
}

class _AddSettingBungaPageState extends State<AddSettingBungaPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  TextEditingController _persenController = TextEditingController();
  String _selectedStatus = '1'; // Default value, aktif
  bool _isLoading = false;

  Future<void> _addSettingBunga(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final persen = double.parse(_persenController.text);

      // Tambahkan setting bunga baru
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        data: {
          'persen': persen,
          'isaktif': int.parse(_selectedStatus), // Mengatur isaktif sesuai dropdown
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        print('Setting bunga berhasil ditambahkan');
        _showSuccessDialog(context);
      } else {
        print('Gagal menambahkan setting bunga');
        _showErrorDialog('Gagal menambahkan setting bunga');
      }
    } catch (error) {
      print('Error: $error');
      _showErrorDialog('Terjadi kesalahan. Silakan coba lagi.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Setting bunga berhasil ditambahkan."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.popUntil(context, ModalRoute.withName('/listbunga'));
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Tambah Setting Bunga',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Persen',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _persenController,
                  keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Persen'
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Status Bunga',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: '1',
                      child: Text('Aktif'),
                    ),
                    DropdownMenuItem(
                      value: '0',
                      child: Text('Tidak Aktif'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _addSettingBunga(context);
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Color.fromARGB(255, 28, 95, 30)),
                ),
                backgroundColor: Color.fromARGB(255, 28, 95, 30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}