import 'package:fb_3/BackgroundGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DonorDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation

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

  // logic for firebase


  // Function to store data in Firebase Realtime Database
  void _storeDataInFirebase() async{
    // Get a reference to the Firestore collection
    CollectionReference donors = FirebaseFirestore.instance.collection('donors');

    // Generate a unique key for each donor
    // String donorId = ref.push().key!;

    // Store data in Firebase
    await donors.add({
      "name": nameController.text,
      "contact": contactController.text,
      "bloodGroup": selectedBloodGroup,
      "gender": selectedGender,
      "dob": dobController.text,
      "district": areaController.text,
      "password": passwordController.text, // Note: Storing passwords in plain text is not secure. Use Firebase Authentication for secure password handling.
    }).then((_) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful')),
      );

      // Navigate to the DonorDashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DonorDashboard()),
      );
    }).catchError((error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $error')),
      );
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donor Registration",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        centerTitle: true, // Centers the title
      ),
      body: BackgroundGradient(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form key for validation
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name'; // Validation message
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),


                // Contact Number field
                TextFormField(
                  controller: contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,  //keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),


                // Blood Group dropdown
                DropdownButtonFormField<String>(
                  value: selectedBloodGroup,
                  decoration: InputDecoration(
                    labelText: 'Blood Group',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: bloodGroups.map((String bloodGroup) {
                    return DropdownMenuItem<String>(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedBloodGroup = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your blood group';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),


                // Gender dropdown
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),


                // Date of Birth field
                TextFormField(
                  controller: dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
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
                      dobController.text = pickedDate.toString().split(" ")[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),


                //Area Field
                TextFormField(
                  controller: areaController,
                  decoration: InputDecoration(
                    labelText: 'District',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your District'; // Validation message
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),


                // Password field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Submit button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _storeDataInFirebase(); // Call the function to store data in Firebase
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}