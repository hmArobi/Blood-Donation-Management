import 'package:flutter/material.dart';

import 'BackgroundGradient.dart';
import 'LoginScreen.dart';
import 'main.dart';


class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Select Role",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),))),
      body:BackgroundGradient(
        child: Center(
          child: Column(  // Column directly inside Center
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/bloodpump.png',
                width: 500,  // Reduced width
                height: 270,  // Reduced height
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Donor Registration Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                child: Text("Using as a Donor", style: TextStyle(color: Colors.white ,fontSize: 18,fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Blood Seeker Page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SeekerDashboardScreen()),
                  // );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                child: Text("Find a Blood Donor", style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
