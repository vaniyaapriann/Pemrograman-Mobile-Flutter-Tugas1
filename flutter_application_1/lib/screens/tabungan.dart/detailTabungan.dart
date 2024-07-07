import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart'; // Import untuk NumberFormat

class ListDetailTabunganPage extends StatefulWidget {
  const ListDetailTabunganPage({Key? key}) : super(key: key);

  @override
  _ListDetailTabunganPageState createState() => _ListDetailTabunganPageState();
}

class _ListDetailTabunganPageState extends State<ListDetailTabunganPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late int anggotaId = 0;

  List<Tabungan> tabunganList = [];
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      anggotaId = args as int;
      getTabungan();
    }
  }

  Future<void> getTabungan() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/tabungan/$anggotaId',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final tabunganData = responseData['data']['tabungan'];
        List<Tabungan> tempList = [];
        for (var tabungan in tabunganData) {
          tempList.add(Tabungan.fromJson(tabungan));
        }

        setState(() {
          tabunganList = tempList.reversed.toList();
        });
      } else {
        print('Gagal memuat tabungan: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan saat mengambil data tabungan.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return; // Menghentikan eksekusi lebih lanjut setelah menampilkan Snackbar
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getJenisTransaksi(int? trxId) {
    switch (trxId) {
      case 1:
        return 'Saldo Awal';
      case 2:
        return 'Simpanan';
      case 3:
        return 'Penarikan';
      case 4:
        return 'Bunga Simpanan';
      case 5:
        return 'Koreksi Penambahan';
      case 6:
        return 'Koreksi Pengurangan';
      default:
        return 'Jenis tidak diketahui';
    }
  }

  String formatNominal(int? nominal, int? trxId) {
    final formatter = NumberFormat('#,###', 'id_ID');
    if (nominal != null) {
      String sign = (trxId == 1 || trxId == 2 || trxId == 5) ? '+' : '-';
      return '$sign${formatter.format(nominal)}';
    }
    return 'Nominal tidak tersedia';
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  String formatTime(DateTime? date) {
    if (date == null) return 'Waktu tidak tersedia';
    final formatter = DateFormat('hh:mm a');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Transaksi ',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tabunganList.isEmpty
              ? Center(child: Text('Tabungan tidak ditemukan'))
              : ListView.builder(
                  itemCount: tabunganList.length,
                  itemBuilder: (context, index) {
                    final tabungan = tabunganList[index];
                    final isNegative = (tabungan.trxNominal ?? 0) < 0;
                    final transactionColor = isNegative ? Colors.red : Colors.green;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                Icons.balance, 
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getJenisTransaksi(tabungan.trxId),
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'ID Transaksi: ${tabungan.id}',
                                    style: GoogleFonts.urbanist(fontSize: 14),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Tanggal: ${formatDate(tabungan.trxTanggal)} ${formatTime(tabungan.trxTanggal)}',
                                    style: GoogleFonts.urbanist(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatNominal(tabungan.trxNominal, tabungan.trxId),
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: transactionColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class Tabungan {
  int? id;
  int? trxId;
  int? trxNominal;
  DateTime? trxTanggal;

  Tabungan({
    this.id,
    this.trxId,
    this.trxNominal,
    this.trxTanggal,
  });

  Tabungan.fromJson(Map<String, dynamic> json)
      : id = json['id'] ,
      trxId = json['trx_id'],
        trxNominal = json['trx_nominal'],
        trxTanggal = DateTime.parse(json['trx_tanggal']);

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'trx_id': trxId,
      'trx_nominal': trxNominal,
      'trx_tanggal': trxTanggal?.toIso8601String(),
    };
  }
}