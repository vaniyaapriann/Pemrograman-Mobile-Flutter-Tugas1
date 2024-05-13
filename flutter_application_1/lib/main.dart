import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/addUser.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/screens/listUser.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/regis.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:get_storage/get_storage.dart';



Future<void> main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login':(context) => LoginPage(),
        '/register' :(context) => Regiscreen(),
        '/home' :(context) => homepage(),
        '/profile' :(context) => profile(),
        '/add' :(context) => addUser(),
        '/listuser': (context) => listUser(),
      },
      initialRoute: '/',
    );
  }
}
