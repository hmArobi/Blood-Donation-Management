
import 'package:fb_3/BackgroundGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SignUpScreen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold))),
      ),
      body: BackgroundGradient(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     // Add login logic here
                //     final contact = _contactController.text;
                //     final password = _passwordController.text;
                //     print('Contact: $contact, Password: $password');
                //   },
                //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                //   child: Text("gyu"),
                // ),
                // SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DonorProfileScreen()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                  child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),

                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('Don’t have an account?',style: TextStyle(fontWeight: FontWeight.bold),)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(' Sign Up',style: TextStyle(color: Colors.red[700],fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


