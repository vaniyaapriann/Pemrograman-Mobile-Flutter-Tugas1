import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class Regiscreen extends StatelessWidget {
  Regiscreen({super.key});

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';


  //text editing controllers
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();


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
                  //Tulisan Register
                  Text('Register',
                  style: GoogleFonts.urbanist(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),),
                  Text('Enter your personal informations!',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.black,
                  ),),

                  //Kolom Fullname
                  SizedBox( 
                    height: 30,),
                  Row(
                    children: [
                      Text('Fullname',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),),
                    ],
                  ),
                  Container(
                    width: 2000,
                    height: 40,
                    child: MyTextFields(
                      controller: fullnameController, 
                      hintText: 'Fullname', 
                      obscureText: false,
                  ),
                ),

                //Kolom Username
                SizedBox(
                  height: 20,),
                Row(
                  children: [
                    Text('Username',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.black,
                    ),),
                  ],
                ),
                Container(
                  width: 2000,
                  height: 40,
                  child: MyTextFields(
                    controller: usernameController, 
                    hintText: 'Username', 
                    obscureText: false,
                  ),
                ),

                //Kolom Email
                SizedBox(
                  height: 20,),
                Row(
                  children: [
                    Text('Email',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.black,
                    ),),
                  ],
                ),
                Container(
                  width: 2000,
                  height: 40,
                  child: MyTextFields(
                    controller: emailController, 
                    hintText: 'Email', 
                    obscureText: false,
                  ),
                ),

                //Kolom Phone
                SizedBox(
                  height: 20,),
                Row(
                  children: [
                    Text('Phone',
                    style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.black,
                    ),),
                  ],
                ),
                Container(
                  width: 2000,
                  height: 40,
                  child:  MyTextFields(
                    controller: phoneController, 
                    hintText: 'Phone', 
                    obscureText: false,
                  ),
                ),

                //Kolom Password
                SizedBox(
                  height: 20,),
                Row(
                  children: [
                    Text('Password',
                    style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.black,
                    ),),
                  ],
                ),
                Container(
                  width: 2000,
                  height: 40,
                  child: MyTextFields(
                    controller: passwordController, 
                    hintText: 'Password', 
                    obscureText: true
                  ),
                ),

                //Kolom Confirm Password
                SizedBox(
                  height: 20,),
                Row(
                  children: [
                    Text('Confirm Password',
                    style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.black,
                    ),),
                  ],
                ),
                Container(
                  width: 2000,
                  height: 40,
                  child: 
                  MyTextFields(
                    controller: confirmpasswordController, 
                    hintText: 'Confirm Password', 
                    obscureText: true
                  ),
                ),

                //tombol sign up
                SizedBox(
                  height: 50,),
                Container(
                  width: 350,
                  height: 50,
                  child: 
                  ElevatedButton(
                    onPressed: () {
                      goRegister(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 28, 95, 30)),
                        borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(255, 28, 95, 30),
                    ), 
                    child: 
                    Text('Sign Up',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                      ),
                    )
                  ),
                ),

                //tombol login
                SizedBox(
                  height: 10,),
                Center(
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.black,
                      )),
                      SizedBox(
                        width: 3,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login' );
                        },
                        child: 
                        Text('Login',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 28, 95, 30),
                        )),
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
  
void goRegister(BuildContext context) async {
  try {
    final _response = await _dio.post(
      '${_apiUrl}/register',
      data: {
        'name': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }
    );
    print(_response.data);
    _storage.write('token', _response.data ['data']['token']);
    Navigator.pushNamed(context, '/login');
    } on DioError catch (e) {
      print ('${e.response} - ${e.response?.statusCode}');
    }
  } 
}

