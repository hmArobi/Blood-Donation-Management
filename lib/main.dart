import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'BackgroundGradient.dart';
import 'SelectionScreen.dart';


void main()async
{
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase based on the platform
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyATWCOkuZ6IqUurXeurm7oQ5a13BabSkw8',
          appId: '1:710867091708:android:c18305bb86d21153d0d779',
          messagingSenderId: '710867091708',
          projectId: 'project-fb3-3e679',
          ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Run the application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.red,
        appBarTheme: AppBarTheme(backgroundColor: Colors.red, foregroundColor: Colors.white),

      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.red[900],
        appBarTheme: AppBarTheme(backgroundColor: Colors.red[900], foregroundColor: Colors.white),

      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically navigate to SelectionScreen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bloodWithHands.png',
              width: 550,
              height: 200,
            ),
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20), // Add margin to the card
              elevation: 5, // Add elevation for a shadow effect
              child: Padding(
                padding: EdgeInsets.all(16), // Add padding inside the card
                child: Center(
                  child: Text(
                    "Welcome to Blood Donation App!",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

