class JenisTransaksi {
  final int id;
  final String namaTransaksi;
  final String multiplyTransaksi;

  JenisTransaksi({
    required this.id,
    required this.namaTransaksi,
    required this.multiplyTransaksi,
  });

  factory JenisTransaksi.fromJson(Map<String, dynamic> json) {
    return JenisTransaksi(
      id: json['id'],
      namaTransaksi: json['trx_name'],
      multiplyTransaksi: json['trx_multiply'].toString(),
    );
  }
}

class JenisTransaksis {
  final List<JenisTransaksi> jenisTransaksis;

  JenisTransaksis({required this.jenisTransaksis});

  factory JenisTransaksis.fromJson(Map<String, dynamic> json) {
    final jenisTransaksi = json['jenistransaksi'] as List<dynamic>;
    return JenisTransaksis(
      jenisTransaksis: jenisTransaksi
          .map((dataJenis) =>
              JenisTransaksi.fromJson(dataJenis as Map<String, dynamic>))
          .toList(),
    );
  }
}
