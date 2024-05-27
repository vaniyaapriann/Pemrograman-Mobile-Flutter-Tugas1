import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class ListTabunganPage extends StatefulWidget {
  @override
  _ListTabunganPageState createState() => _ListTabunganPageState();
}

class _ListTabunganPageState extends State<ListTabunganPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  
  List<Volunteer> volunteerList = [];
  bool isLoading = false;
  int _selectedIndex = 2; // Index of selected item in bottom navigation bar

  @override
  void initState() {
    super.initState();
    getVolunteerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            Text('List Transaksi'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.receipt_long),
              onPressed: () {
                Navigator.pushNamed(context, '/jenistransaksi');
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: volunteerList.length,
              itemBuilder: (context, index) {
                final volunteer = volunteerList[index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Color.fromARGB(255, 28, 95, 30),
                    title: Text(
                      volunteer.nama ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/detailtabungan', arguments: volunteer?.id);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pushNamed(context, '/addtabungan', arguments: volunteer?.id);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_money),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pushNamed(context, '/saldotabungan', arguments: volunteer?.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 28, 95, 30),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/addtabungan');
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

  void getVolunteerList() async {
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
            volunteerList = userData
                .map((volunteerJson) => Volunteer.fromJson({
                  "id": volunteerJson["id"],
                  "nama": volunteerJson["nama"],
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

  void deleteVolunteer(int id) async {
    try {
      final response = await _dio.delete(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        // Refresh volunteer list after deletion
        getVolunteerList();
        print('Volunteer with ID $id deleted successfully.');
      } else {
        print('Error deleting volunteer: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }
}

class Volunteer {
  final int id;
  final String nama;

  Volunteer({
    required this.id,
    required this.nama,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
    );
  }
}
