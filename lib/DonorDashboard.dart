import 'package:fb_3/BackgroundGradient.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Donor Dashboard",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                _updateLastDonationDate(pickedDate);
              }
            },
          ),
        ],
      ),
      body: BackgroundGradient(
        child: _donorData == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _donorData!['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _isEligible() ? "AVAILABLE" : "RECHARGING",
                style: TextStyle(
                  color: _isEligible() ? Colors.green[800] : Colors.red,
                  fontWeight: FontWeight.bold,fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Text("Blood Group: ${_donorData!['bloodGroup']}"),
              Text("Contact: ${_donorData!['contact']}"),
              Text("District: ${_donorData!['district']}"),
              Text("Last Donation Date: ${_donorData!['lastDonationDate'] != null ? DateFormat('dd MMM yyyy').format((_donorData!['lastDonationDate'] as Timestamp).toDate()) : 'N/A'}"),
              SizedBox(height: 20),
              Text(
                "Donation History:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _donationHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(DateFormat('dd MMM yyyy').format(_donationHistory[index])),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}