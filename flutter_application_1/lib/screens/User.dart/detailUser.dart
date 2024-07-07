import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class detailUser extends StatefulWidget {
  const detailUser({Key? key}) : super(key: key);

  @override
  _detailUserState createState() => _detailUserState();
}

class _detailUserState extends State<detailUser> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  User? user;
  bool isLoading = false;
  int saldo = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController noIndukController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      int id = args as int;
      fetchUserDetails(id);
      fetchSaldo(id);
    }
  }

  Future<void> fetchUserDetails(int id) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final userData = responseData['data']['anggota'];
        setState(() {
          user = User.fromJson(userData);
          if (user != null) {
            idController.text = user!.id.toString();
            noIndukController.text = user!.nomorInduk;
            namaController.text = user!.nama;
            alamatController.text = user!.alamat;
            teleponController.text = user!.telepon;
            tglLahirController.text = user!.tanggalLahir;
            statusController.text = user!.statusAktif == 1
                ? 'Aktif'
                : 'Non Aktif';
          }
        });
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your token is expired. Login Please.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSaldo(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          saldo = responseData['data']['saldo'];
        });
      } else {
        print('Gagal memuat saldo: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      String errorMessage = 'Terjadi kesalahan saat mengambil saldo.';
      if (e.response?.statusCode == 404) {
        errorMessage = 'Data saldo tidak ditemukan.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      print('Error: $error');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool readOnly = true,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Detail User',
            style: GoogleFonts.urbanist(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () async {
              final updatedUser = await Navigator.pushNamed(context, '/editUser', arguments: user?.id);
              if (updatedUser != null && updatedUser is User) {
                setState(() {
                  user = updatedUser;
                  idController.text = user!.id.toString();
                  noIndukController.text = user!.nomorInduk;
                  namaController.text = user!.nama;
                  alamatController.text = user!.alamat;
                  teleponController.text = user!.telepon;
                  tglLahirController.text = user!.tanggalLahir;
                  statusController.text = user!.statusAktif == 1
                      ? 'Aktif'
                      : 'Non Aktif';
                });
                Navigator.pop(context, updatedUser);
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user == null
              ? Center(child: Text('Member not found'))
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _buildTextField(
                            controller: noIndukController,
                            hintText: 'No Induk',
                            icon: Icons.person),
                        SizedBox(height: 20),
                        _buildTextField(
                            controller: namaController,
                            hintText: 'Nama Lengkap',
                            icon: Icons.person),
                        SizedBox(height: 20),
                        _buildTextField(
                            controller: alamatController,
                            hintText: 'Alamat',
                            icon: Icons.home),
                        SizedBox(height: 20),
                        _buildTextField(
                            controller: tglLahirController,
                            hintText: 'Tanggal Lahir',
                            icon: Icons.calendar_today),
                        SizedBox(height: 20),
                        _buildTextField(
                            controller: teleponController,
                            hintText: 'Telepon',
                            icon: Icons.phone),
                        SizedBox(height: 20),
                        _buildStatusItem(
                            user!.statusAktif),
                        SizedBox(height: 20),
                        _buildSaldoItem(saldo),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              minWidth: 150,
                              height: 60,
                              onPressed: () {
                                Navigator.pushNamed(context, '/detailTabungan',
                                    arguments: user?.id);
                              },
                              color: Color.fromARGB(255, 28, 95, 30),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "History Transaksi",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              minWidth: 150,
                              height: 60,
                              onPressed: () {
                                if (user!.statusAktif == 1) {
                                  Navigator.pushNamed(
                                    context,
                                    '/addTabungan',
                                    arguments: {
                                      'id': user?.id,
                                      'nomor_induk': user?.nomorInduk,
                                      'nama': user?.nama,
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('User is inctive!'),
                                        content: Text(
                                            "Can't add any transaction."),
                                        actions: <Widget>[
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
                              },
                              color: Color.fromARGB(255, 28, 95, 30),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Add Transaksi",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatusItem(int statusAktif) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            statusAktif == 1 ? 'Aktif' : 'Non Aktif',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaldoItem(int saldo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saldo',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Color.fromARGB(255, 28, 95, 30),
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Rp ${NumberFormat('#,###', 'id_ID').format(saldo)}',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
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
