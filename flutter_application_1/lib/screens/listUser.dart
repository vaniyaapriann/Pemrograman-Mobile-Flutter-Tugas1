import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/typo.dart';

class listUser extends StatefulWidget {
  @override
  _listUserState createState() => _listUserState();
}

class _listUserState extends State<listUser> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  List<User> UserList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: UserList.length,
              itemBuilder: (context, index) {
                final User = UserList[index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Color.fromARGB(255, 28, 95, 30),
                    title: Text(
                      User.nama ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      User.alamat ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      goUserDetail(User.id);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            editUserDetail(User.id);
                          },
                          icon: Image.asset('assets/images/edit.png',
                              width: 24, height: 24),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () {
                            deleteUser(User.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void getUserList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final userData = responseData['data']['anggotas'];
        if (userData is List) {
          setState(() {
            UserList = userData
                .map((UserJson) => User.fromJson({
                      "id": UserJson["id"],
                      "nomor_induk": UserJson["nomor_induk"],
                      "nama": UserJson["nama"],
                      "alamat": UserJson["alamat"],
                      "tgl_lahir": UserJson["tgl_lahir"],
                      "telepon": UserJson["telepon"],
                      "status": UserJson["status"],
                    }))
                .toList();
          });
        }
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void goUserDetail(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final UserData = responseData['data']['anggota'];
        User? selectedUser = User.fromJson(UserData);

        if (selectedUser != null) {
          String statusText =
              selectedUser.status == 1 ? 'Active' : 'Non Active';

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Detail User"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("ID: ${selectedUser.id ?? 'Not Found'}"),
                    Text("Nama: ${selectedUser.nama ?? 'Not Found'}"),
                    Text("Alamat: ${selectedUser.alamat ?? 'Not Found'}"),
                    Text(
                        "Tanggal Lahir: ${selectedUser.tanggalLahir ?? 'Not Found'}"),
                    Text("Telepon: ${selectedUser.telepon ?? 'Not Found'}"),
                    Text("Status: $statusText"),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Tutup"),
                  ),
                ],
              );
            },
          );
        } else {
          print("Data User tidak ditemukan.");
        }
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }

  void editUserDetail(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final UserData = response.data['data']['anggota'];
        User? selectedUser = User.fromJson(UserData);

        // Menampilkan AlertDialog untuk mengedit data anggota
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String nomorInduk = UserData['nomor_induk'].toString();
            String nama = UserData['nama'].toString();
            String alamat = UserData['alamat'].toString();
            String tanggalLahir = UserData['tgl_lahir'].toString();
            String telepon = UserData['telepon'].toString();

            return AlertDialog(
              title: Text(
                'Edit Anggota',
                style: headerOne,
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: nomorInduk,
                      onChanged: (value) {
                        nomorInduk = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Nomor Induk',
                          hintStyle: penjelasanSearch),
                    ),
                    TextFormField(
                      initialValue: nama,
                      onChanged: (value) {
                        nama = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Nama', hintStyle: penjelasanSearch),
                    ),
                    TextFormField(
                      initialValue: alamat,
                      onChanged: (value) {
                        alamat = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Alamat', hintStyle: penjelasanSearch),
                    ),
                    TextFormField(
                      initialValue: tanggalLahir,
                      onChanged: (value) {
                        tanggalLahir = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Tanggal Lahir',
                          hintStyle: penjelasanSearch),
                    ),
                    TextFormField(
                      initialValue: telepon,
                      onChanged: (value) {
                        telepon = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Telepon', hintStyle: penjelasanSearch),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal', style: batal),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      Response putResponse = await Dio().put(
                        '$_apiUrl/anggota/$id', // Perbaikan URL
                        data: {
                          'nomor_induk': nomorInduk,
                          'nama': nama,
                          'alamat': alamat,
                          'tgl_lahir': tanggalLahir,
                          'telepon': telepon,
                        },
                        options: Options(
                          headers: {
                            'Authorization': 'Bearer ${_storage.read('token')}'
                          },
                        ),
                      );

                      if (putResponse.statusCode == 200) {
                        print('Data anggota berhasil diupdate');
                        // Refresh daftar pengguna setelah penyimpanan berhasil
                        getUserList();
                      } else {
                        print('Gagal mengupdate data anggota');
                      }
                    } catch (error) {
                      print('Error: $error');
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Simpan',
                    style: simpan,
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void deleteUser(int id) async {
    try {
      final response = await _dio.delete(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        // Refresh User list after deletion
        getUserList();
        print('User with ID $id deleted successfully.');
      } else {
        print('Error deleting User: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }
}

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
      id: json['id'] ?? 0,
      nomorInduk: json['nomor_induk'].toString(),
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      tanggalLahir: json['tgl_lahir'] ?? '',
      telepon: json['telepon'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
