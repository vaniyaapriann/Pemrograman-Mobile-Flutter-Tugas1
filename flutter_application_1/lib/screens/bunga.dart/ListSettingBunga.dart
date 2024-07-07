import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ListSettingBungaPage extends StatefulWidget {
  const ListSettingBungaPage({Key? key}) : super(key: key);

  @override
  _ListSettingBungaPageState createState() => _ListSettingBungaPageState();
}

class _ListSettingBungaPageState extends State<ListSettingBungaPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<dynamic> _settings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  void _fetchSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data['settingbungas'] != null && data['settingbungas'] is List) {
          setState(() {
            _settings = List<Map<String, dynamic>>.from(data['settingbungas']);
          });
        } else {
          print('Invalid data format');
        }
      } else {
        print('Failed to load settings bunga');
      }
    } catch (error) {
      print('Error: $error');
      _showErrorDialog('Gagal memuat data setting bunga');
    }

    // Setelah mengambil data setting bunga, matikan semua yang aktif kecuali yang terbaru
    await _disableAllActiveSettings();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _disableAllActiveSettings() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data['settingbungas'] != null && data['settingbungas'] is List) {
          final List<dynamic> settings = data['settingbungas'];
          // Cari setting bunga yang aktif dan matikan
          for (var setting in settings) {
            if (setting['isaktif'] == 1) {
              await _dio.put(
                '$_apiUrl/updateSettingBunga/${setting['id']}',
                data: {'isaktif': 0},
                options: Options(
                  headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
                ),
              );
            }
          }
        } else {
          print('Invalid data format');
        }
      } else {
        print('Failed to load settings bunga');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showErrorDialog(String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Setting Bunga',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _settings.isEmpty
              ? Center(child: Text('Tidak ada data setting bunga'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSettingCategory(true), // Bunga Aktif
                      _buildSettingCategory(false), // Bunga Tidak Aktif
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromARGB(255, 28, 95, 30),
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Ubah ini sesuai dengan index halaman ini
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/listuser');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/listbunga');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Member',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Bunga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addbunga');
        },
        tooltip: 'Tambah Setting Bunga',
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 28, 95, 30),
      ),
    );
  }

  Widget _buildSettingCategory(bool isActive) {
    final categorySettings = _settings.where((setting) => setting['isaktif'] == (isActive ? 1 : 0)).toList();
    return categorySettings.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  isActive ? 'Bunga Aktif' : 'Bunga Tidak Aktif',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categorySettings.length,
                itemBuilder: (context, index) {
                  final setting = categorySettings[index];
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                      tileColor: Color.fromARGB(255, 28, 95, 30),
                      title: Text(
                        'Persen: ${setting['persen']}%',
                        style: TextStyle(color: Colors.white),),
                      subtitle: Text(
                        'Status: ${setting['isaktif'] == 1 ? 'Aktif' : 'Tidak Aktif'}',
                        style: TextStyle(color: Colors.white),),
                  ),);
                },
              ),
            ],
          )
        : SizedBox.shrink(); // Kosongkan widget jika tidak ada data
  }
}