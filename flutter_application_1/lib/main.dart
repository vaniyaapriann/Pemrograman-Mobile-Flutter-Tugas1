import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/screens/bunga.dart/ListSettingBunga.dart';
import 'package:flutter_application_1/screens/bunga.dart/settingbunga.dart';
import 'package:flutter_application_1/screens/tabungan.dart/addTabungan.dart';
import 'package:flutter_application_1/screens/tabungan.dart/detailTabungan.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/regis.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';

import 'package:flutter_application_1/screens/User.dart/detailUser.dart';
import 'package:flutter_application_1/screens/User.dart/addUser.dart';
import 'package:flutter_application_1/screens/User.dart/listUser.dart';
import 'package:flutter_application_1/screens/User.dart/editUser.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => Regiscreen(),
        '/home': (context) => Homepage(),
        '/profile': (context) => profile(),
        '/add': (context) => addUser(),
        '/listuser': (context) => listUser(),
        '/editUser': (context) => editUserPage(),
        '/userDetail': (context) => detailUser(),

        '/addTabungan':(context) => AddTabunganPage(),
        '/detailTabungan':(context) => ListDetailTabunganPage(),

        '/listbunga':(context) => ListSettingBungaPage(),
        '/addbunga':(context) => AddSettingBungaPage(),
        
      },
      initialRoute: '/',
    );
  }
}
