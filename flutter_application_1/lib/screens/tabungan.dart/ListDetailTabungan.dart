import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

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
          tabunganList = tempList;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tabunganList.isEmpty
              ? Center(child: Text('Tabungan tidak ditemukan'))
              : ListView.builder(
                  itemCount: tabunganList.length,
                  itemBuilder: (context, index) {
                    final tabungan = tabunganList[index];
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tileColor: Color.fromARGB(255, 28, 95, 30),
                        title: Text('ID Transaksi: ${tabungan.trxId}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),),
                        subtitle: Text('Nominal: ${tabungan.trxNominal}',
                        style: TextStyle(
                          color: Colors.white
                        ),),
                    ),
                    );
                  },
                ),
    );
  }
}

class Tabungan {
  int? trxId;
  int? trxNominal;

  Tabungan({
    this.trxId, 
    this.trxNominal
  });

  Tabungan.fromJson(Map<String, dynamic> json)
     : trxId = json['trx_id'],
      trxNominal = json['trx_nominal'];

  Map<String, dynamic> toJson() {
    return {
      'trx_id': trxId,
      'trx_nominal': trxNominal,
    };
  }
}