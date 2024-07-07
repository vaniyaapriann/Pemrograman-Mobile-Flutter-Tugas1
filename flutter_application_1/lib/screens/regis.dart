import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class Regiscreen extends StatefulWidget {
  Regiscreen({super.key});

  @override
  _RegiscreenState createState() => _RegiscreenState();
}

class _RegiscreenState extends State<Regiscreen> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  // Text editing controllers
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                'Register',
                style: GoogleFonts.urbanist(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter your personal information!',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(
                controller: fullnameController,
                hintText: 'Fullname',
                icon: Icons.person,
                obscureText: false,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: usernameController,
                hintText: 'Username',
                icon: Icons.person_outline,
                obscureText: false,
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
                controller: phoneController,
                hintText: 'Phone',
                icon: Icons.phone,
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
              SizedBox(height: 20),
              _buildTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  goRegister(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Sign Up',
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
                    'Already have an account?',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Login',
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

  void goRegister(BuildContext context) async {
    try {
      final _response = await _dio.post(
        '$_apiUrl/register',
        data: {
          'name': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print(_response.data);
      _storage.write('token', _response.data['data']['token']);
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
