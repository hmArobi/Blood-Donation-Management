import 'package:fb_3/BackgroundGradient.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DonorDashboard.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for text fields
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final areaController = TextEditingController();

  // Variables for dropdown selections
  String? selectedBloodGroup;
  String? selectedGender;

  // Lists for dropdown options
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    contactController.dispose();
    dobController.dispose();
    passwordController.dispose();
    areaController.dispose();
    super.dispose();
  }

  Future<void> _registerDonor() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: '${nameController.text}@blooddonation.com', // Use name as email (for simplicity)
          password: passwordController.text,
        );

        // Store donor data in Firestore
        await _firestore.collection('donors').doc(userCredential.user!.uid).set({
          "name": nameController.text,
          "contact": contactController.text,
          "bloodGroup": selectedBloodGroup,
          "gender": selectedGender,
          "dob": dobController.text,
          "district": areaController.text,
          "lastDonationDate": null, // Initialize to null
          "donationHistory": [], // Initialize empty donation history
        });

        // Navigate to DonorDashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DonorDashboard()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donor Registration", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BackgroundGradient(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // Name Field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                  ),
                  SizedBox(height: 10),


                  //Contact Number Field
                  TextFormField(
                    controller: contactController,
                    decoration: InputDecoration(labelText: 'Contact Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter your contact number' : null,
                  ),
                  SizedBox(height: 10),


                  //Blood Group Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedBloodGroup,
                    decoration: InputDecoration(labelText: 'Blood Group',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: bloodGroups.map((group) => DropdownMenuItem(value: group, child: Text(group))).toList(),
                    onChanged: (value) => setState(() => selectedBloodGroup = value),
                    validator: (value) => value == null ? 'Select your blood group' : null,
                  ),
                  SizedBox(height: 10),


                  //Gender Select
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: genders.map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                    onChanged: (value) => setState(() => selectedGender = value),
                    validator: (value) => value == null ? 'Select your gender' : null,
                  ),
                  SizedBox(height: 10),


                  //Date of Birth Select
                  TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        dobController.text = pickedDate.toIso8601String().split('T')[0];
                      }
                    },
                    validator: (value) => value!.isEmpty ? 'Select your date of birth' : null,
                  ),
                  SizedBox(height: 10),


                  //Area selection
                  TextFormField(
                    controller: areaController,
                    decoration: InputDecoration(labelText: 'District',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter your district' : null,
                  ),
                  SizedBox(height: 10),


                  //Password  Field
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Enter a password' : null,
                  ),
                  SizedBox(height: 20),


                  //Button
                  ElevatedButton(
                    onPressed: _registerDonor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                    ),
                    child: Text("Submit",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}