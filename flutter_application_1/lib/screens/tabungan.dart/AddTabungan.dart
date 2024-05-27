import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class AddTabunganPage extends StatefulWidget {
  @override
  _AddTabunganPage createState() => _AddTabunganPage();
}

class _AddTabunganPage extends State<AddTabunganPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  String? selectedAnggotaId; // Selected anggota ID

  // Text editing controllers
  final TextEditingController anggotaIdController = TextEditingController();
  final TextEditingController trxIdController = TextEditingController();
  final TextEditingController trxNominalController = TextEditingController();

  List<String> anggotaIdList = []; // List to store anggota IDs
  bool isLoading = false; // Loading status

  int _selectedIndex = 1; // Index of selected item in bottom navigation bar

  @override
  void initState() {
    super.initState();
    getAnggotaList(); // Fetch anggota list when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove elevation
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        title: Text('Insert Transaksi Tabungan', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Anggota ID:',
              style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              selectedAnggotaId ?? 'No ID selected',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              'Transaksi ID',
              style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MyTextFields(
              controller: trxIdController,
              hintText: 'Enter Transaksi ID',
              obscureText: false,
            ),
            SizedBox(height: 20),

            Text(
              'Transaksi Nominal',
              style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MyTextFields(
              controller: trxNominalController,
              hintText: 'Enter Transaksi Nominal',
              obscureText: false,
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => insertTransaksiTabungan(context),
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // background color
                foregroundColor: Colors.white, // foreground color
              ),
            ),

            SizedBox(height: 20),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue), // Change the color
                  strokeWidth: 3, // Adjust the stroke width
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromARGB(255, 28, 95, 30),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/tabungan');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/transaksi');
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Tabungan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transaksi',
          ),
        ],
      ),
    );
  }

  void getAnggotaList() async {
    try {
      setState(() {
        isLoading = true; // Set loading status to true
      });

      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final anggotaData = responseData['data']['anggotas'];
        if (anggotaData is List) {
          setState(() {
            anggotaIdList =
                anggotaData.map((anggota) => anggota['id'].toString()).toList();
            if (anggotaIdList.isNotEmpty) {
              selectedAnggotaId = anggotaIdList
                  .first; // Set the first anggota ID as selected by default
            }
          });
        }
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    } finally {
      setState(() {
        isLoading =
            false; // Set loading status to false after API call is finished
      });
    }
  }

  void insertTransaksiTabungan(BuildContext context) async {
    final String anggotaId = selectedAnggotaId ?? '';
    final int trxId = int.tryParse(trxIdController.text.trim()) ?? 0;
    final double trxNominal =
        double.tryParse(trxNominalController.text.trim()) ?? 0.0;

    try {
      final response = await _dio.post(
        '$_apiUrl/tabungan',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'anggota_id': anggotaId,
          'trx_id': trxId,
          'trx_nominal': trxNominal,
        },
      );

      if (response.statusCode == 200) {
        print('Success: Transaction added successfully'); // Pesan di debug console
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success", style: TextStyle(color: Colors.green)),
              content: Text("Transaksi has been successfully added."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacementNamed(context, '/transaksi'); // Navigate to /transaksi
                  },
                  child: Text("OK"),
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
              title: Text("Error", style: TextStyle(color: Colors.red)),
              content: Text("Failed to add transaction. Please try again."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      String errorMessage =
          'Failed to add transaction. Please try again later.';
      if (e.response?.statusCode == 409) {
        errorMessage = 'Transaction already exists.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: Colors.red)),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
