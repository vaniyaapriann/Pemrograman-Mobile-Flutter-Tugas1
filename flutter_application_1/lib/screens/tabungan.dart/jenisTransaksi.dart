import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class JenisTransaksi {
  final int id;
  final String trx_name;

  JenisTransaksi({
    required this.id,
    required this.trx_name,
  });

  factory JenisTransaksi.fromJson(Map<String, dynamic> json) {
    return JenisTransaksi(
      id: json['id'] ?? 0,
      trx_name: json['trx_name'] ?? '',
    );
  }
}

class TransaksiView extends StatefulWidget {
  const TransaksiView({Key? key}) : super(key: key);

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Future<List<JenisTransaksi>> getMasterTransaksi() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final jenisTransaksiData = responseData['data']['jenistransaksi'];
        if (jenisTransaksiData is List) {
          return jenisTransaksiData
              .map((jenisTransaksiJson) => JenisTransaksi.fromJson({
                    "id": jenisTransaksiJson["id"],
                    "trx_name": jenisTransaksiJson["trx_name"],
                  }))
              .toList();
        } else {
          throw Exception('Jenis Transaksi Tidak Ditemukan');
        }
      } else {
        throw Exception(
            'Error: API request failed with status: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Terjadi kesalahan: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jenis Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<JenisTransaksi>>(
          future: getMasterTransaksi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final jenisTransaksiList = snapshot.data!;
              return ListView.builder(
                itemCount: jenisTransaksiList.length,
                itemBuilder: (context, index) {
                  final jenisTransaksi = jenisTransaksiList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: const Color.fromARGB(255, 28, 95, 30),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${jenisTransaksi.id}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            jenisTransaksi.trx_name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Tidak ada data'));
            }
          },
        ),
      ),
    );
  }
}