import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'BackgroundGradient.dart';

class DonorDashboard extends StatefulWidget {
  @override
  _DonorDashboardState createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  Map<String, dynamic>? _donorData;
  List<DateTime> _donationHistory = [];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchDonorData();
  }

  Future<void> _fetchDonorData() async {
    if (_user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('donors').doc(_user!.uid).get();
      if (snapshot.exists) {
        setState(() {
          _donorData = snapshot.data() as Map<String, dynamic>;
          _donationHistory = (_donorData!['donationHistory'] as List<dynamic>)
              .map((date) => (date as Timestamp).toDate())
              .toList();
        });
      }
    }
  }

  // Fix: Corrected method name to _updateLastDonationDate
  Future<void> _updateLastDonationDate(DateTime newDate) async {
    if (_user != null) {
      await _firestore.collection('donors').doc(_user!.uid).update({
        'lastDonationDate': newDate,
        'donationHistory': FieldValue.arrayUnion([newDate]),
      });
      _fetchDonorData(); // Refresh data
    }
  }

  bool _isEligible() {
    if (_donorData == null || _donorData!['lastDonationDate'] == null) return true;
    DateTime lastDonationDate = (_donorData!['lastDonationDate'] as Timestamp).toDate();
    return DateTime.now().difference(lastDonationDate).inDays >= 120;
  }

  // New method to calculate remaining days until available
  int _calculateRemainingDays() {
    if (_donorData == null || _donorData!['lastDonationDate'] == null) return 0;
    DateTime lastDonationDate = (_donorData!['lastDonationDate'] as Timestamp).toDate();
    int daysSinceLastDonation = DateTime.now().difference(lastDonationDate).inDays;
    return 120 - daysSinceLastDonation;
  }

  Future<void> _changePassword() async {
    final TextEditingController _newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'New Password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_newPasswordController.text.isNotEmpty) {
                  try {
                    await _user!.updatePassword(_newPasswordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password updated successfully')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a new password')),
                  );
                }
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Delete from Firestore
                  await _firestore.collection('donors').doc(_user!.uid).delete();
                  // Delete from Firebase Authentication
                  await _user!.delete();
                  Navigator.pop(context);
                  Navigator.pop(context); // Go back to the previous screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectLastDonationDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _updateLastDonationDate(pickedDate);
    }
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _changePassword();
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Update Last Donation Date'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _selectLastDonationDate(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Account'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Donor Dashboard",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
        ),
      ),
      body: BackgroundGradient(
        child: _donorData == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _donorData!['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        _isEligible() ? "AVAILABLE" : "RECHARGING",
                        style: TextStyle(
                          color: _isEligible() ? Colors.green[800] : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      // Add countdown if the donor is recharging
                      if (!_isEligible())
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "(${_calculateRemainingDays()} days left)",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Blood Group: ${_donorData!['bloodGroup']}"),
                  Text("Contact: ${_donorData!['contact']}"),
                  Text("District: ${_donorData!['district']}"),
                  Row(
                    children: [
                      Text("Last Donation Date: "),
                      Text(
                        _donorData!['lastDonationDate'] != null
                            ? DateFormat('dd MMM yyyy').format((_donorData!['lastDonationDate'] as Timestamp).toDate())
                            : 'N/A',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Donation History:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _donationHistory.length,
                      itemBuilder: (context, index) {
                        return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0), // Added card margin
                        elevation: 4, // Card shadow effect
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),

                         child:  ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blueGrey), // Added icon
                          title: Text(DateFormat('dd MMM yyyy').format(_donationHistory[index]),
                        style:TextStyle(fontWeight:FontWeight.bold),
                          ),
                        ), // Fix: Added missing closing parenthesis
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: PopupMenuButton<String>(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                      Icons.person, size: 30, color: Colors.black87),
                ),
                onSelected: (String value) {
                  if (value == 'update_last_donation_date') {
                    _selectLastDonationDate(context);
                  } else if (value == 'change_password') {
                    _changePassword();
                  } else if (value == 'delete_account') {
                    _deleteAccount();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'update_last_donation_date',
                      child: ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Update Last Donation Date'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'change_password',
                      child: ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Password'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete_account',
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete Account'),
                      ),
                    ),
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}