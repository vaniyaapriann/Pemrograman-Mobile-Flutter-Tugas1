import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class LihatSaldoPage extends StatefulWidget {
  const LihatSaldoPage({Key? key}) : super(key: key);

  @override
  _LihatSaldoPageState createState() => _LihatSaldoPageState();
}

class _LihatSaldoPageState extends State<LihatSaldoPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late int saldo = 0;
  late int anggotaId = 0;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      anggotaId = args as int;
      getSaldo();
    }
  }

  Future<void> getSaldo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/${anggotaId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        saldo = responseData['data']['saldo'];
      } else {
        print('Gagal memuat saldo: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      String errorMessage = 'Terjadi kesalahan saat mengambil saldo.';
      if (e.response?.statusCode == 404) {
        errorMessage = 'Data saldo tidak ditemukan.';
      }
      // Tampilkan pesan kesalahan dengan dialog atau snackbar
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Saldo'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 28, 95, 30),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Saldo Anda:',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rp $saldo',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}