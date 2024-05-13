import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State
{
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                'Login',
                style: GoogleFonts.urbanist(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 2000,
                height: 40,
                child: MyTextFields(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 2000,
                height: 40,
                child: MyTextFields(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
              ),
              SizedBox(height: 10),
              if(errorMessage.isNotEmpty) Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 40),
              Container(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    goLogin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Color.fromARGB(255, 28, 95, 30),
                  ), 
                  child: Text(
                    'Login',
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                    ),
                  )
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.black,
                      )
                    ),
                    SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Register',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 28, 95, 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,   
    );
  }
  
  void goLogin(BuildContext context) async {
    try {
      final _response = await _dio.post(
        '$_apiUrl/login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        }
      );
      print(_response.data);
      _storage.write('token', _response.data['data']['token']);
      
      // Navigasi ke halaman beranda setelah login berhasil
      Navigator.pushNamed(context, '/home');
      
    } on DioError catch (e) {
      if (e.response != null) {
        print('${e.response} - ${e.response!.statusCode}');
        setState(() {
          errorMessage = 'Invalid email or password. Please try again.';
        });
      } else {
        print(e.message);
        setState(() {
          errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }
}
