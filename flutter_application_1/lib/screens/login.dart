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

class _LoginScreenState extends State<LoginPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';
  bool _obscurePassword = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Image.asset(
                'assets/images/logofix.png',
                height: 200,
                width: 500,
              ),
              SizedBox(height: 20),
              Text(
                'Login',
                style: GoogleFonts.urbanist(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 20),
              _buildTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email,
                obscureText: false,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  goLogin(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.urbanist(
                    color: Color.fromARGB(255, 28, 95, 30),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Register',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 28, 95, 30),
                      ),
                    ),
                  ),
                ],
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
      },
    );
    print(_response.data);
    _storage.write('token', _response.data['data']['token']);

    // Ambil username dari response
    final username = _response.data['data']['user']['username'];

    // Navigasi ke halaman beranda setelah login berhasil dengan username
    Navigator.pushNamed(context, '/home', arguments: {'username': username});
  } on DioError catch (e) {
    if (e.response != null) {
      print('${e.response} - ${e.response!.statusCode}');
      {
        _showErrorDialog(context, 'Invalid email or password. Please try again.');
      };
    } else {
      print(e.message);
      _showErrorDialog(context, 'An error occurred. Please try again later.');
      };
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
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

}

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
