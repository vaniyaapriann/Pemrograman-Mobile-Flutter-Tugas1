class User {
  final int id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tanggalLahir;
  final String telepon;
  final int status;

  User({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nomorInduk: json['nomor_induk'],
      nama: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tanggal_lahir'],
      telepon: json['telepon'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_induk': nomorInduk,
      'nama': nama,
      'alamat': alamat,
      'tanggal_lahir': tanggalLahir,
      'telepon': telepon,
      'status': status,
    };
  }
}
