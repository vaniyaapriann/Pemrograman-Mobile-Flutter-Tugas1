import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTabunganPage extends StatefulWidget {
  const AddTabunganPage({Key? key}) : super(key: key);

  @override
  _AddTabunganPageState createState() => _AddTabunganPageState();
}

class _AddTabunganPageState extends State<AddTabunganPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  late int anggotaId;
  late User user;
  late String nama;

  TextEditingController nominalController = TextEditingController();
  TextEditingController idTransaksiController = TextEditingController();
  TextEditingController dateTransaksiController = TextEditingController();

  List<Map<int, String>> _jenisTransaksi = [
    {1: 'Saldo Awal'},
    {2: 'Simpanan'},
    {3: 'Penarikan'},
    {4: 'Bunga Simpanan'},
    {5: 'Koreksi Penambahan'},
    {6: 'Koreksi Pengurangan'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (args != null) {
      anggotaId = args['id'] as int;
      nama = args['nama'] as String;
    }
  }

  Future<void> insertTransaksiTabungan() async {
    final trxNominal = nominalController.text.replaceAll('.', '');
    final trxId = idTransaksiController.text;
    final int trxIdInt = int.parse(trxId);
    final String sign = [1, 2, 5].contains(trxIdInt) ? '+' : '-';

    try {
      final response = await _dio.post(
        '$_apiUrl/tabungan',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'anggota_id': anggotaId,
          'trx_id': trxId,
          'trx_nominal': '$sign$trxNominal',
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Transaksi has been successfully added."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.popUntil(context, ModalRoute.withName('/userDetail')); // Navigate back to previous page
                  },
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog("Failed to add transaction. Please try again.");
      }
    } on DioError catch (e) {
      String errorMessage = 'Failed to add transaction. Please try again later.';
      if (e.response?.statusCode == 409) {
        errorMessage = 'Transaction already exists.';
      }
      showErrorDialog(errorMessage);
    }
  }

  void showErrorDialog(String message) {
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

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal);
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to perform this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                insertTransaksiTabungan();
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
          'Add Transaction',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 40,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$nama',
                style: GoogleFonts.urbanist(fontSize: 16),
              ),
            ),
            Text(
              'Transaksi',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                items: _jenisTransaksi
                    .map((map) => DropdownMenuItem<int>(
                          value: map.keys.first,
                          child: Text('${map.keys.first} - ${map.values.first}'),
                        ))
                    .toList(),
                onChanged: (value) {
                  idTransaksiController.text = value.toString();
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nominal',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 40,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: nominalController,
                decoration: InputDecoration(
                  hintText: 'Nominal',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.urbanist(fontSize: 16),
                onChanged: (value) {
                  String newValue = value.replaceAll('.', '');
                  if (newValue.isNotEmpty) {
                    int parsedValue = int.parse(newValue);
                    nominalController.value = TextEditingValue(
                      text: formatNominal(parsedValue),
                      selection: TextSelection.collapsed(
                        offset: formatNominal(parsedValue).length,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color.fromARGB(255, 28, 95, 30)),
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Color.fromARGB(255, 28, 95, 30),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.urbanist(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final int id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tanggalLahir;
  final String telepon;
  final int statusAktif;

  User({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
    required this.statusAktif,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nomorInduk: json['nomor_induk'].toString(),
      nama: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tgl_lahir'],
      telepon: json['telepon'],
      statusAktif: json['status_aktif'],
    );
  }
}
