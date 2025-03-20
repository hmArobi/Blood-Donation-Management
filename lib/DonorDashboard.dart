import 'package:flutter/material.dart';
import 'BackgroundGradient.dart';
import 'LoginScreen.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart'; // For date formatting
//
// class DonorDashboard extends StatefulWidget {
//   const DonorDashboard({Key? key}) : super(key: key);
//
//   @override
//   _DonorDashboardState createState() => _DonorDashboardState();
// }

// class _DonorDashboardState extends State<DonorDashboard> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late User? _user;
//   Map<String, dynamic>? _donorData;
//
//   @override
//   void initState() {
//     super.initState();
//     _user = _auth.currentUser;
//     _fetchDonorData();
//   }
//
//   Future<void> _fetchDonorData() async {
//     if (_user != null) {
//       DocumentSnapshot snapshot =
//       await _firestore.collection('donors').doc(_user!.uid).get();
//       if (snapshot.exists) {
//         setState(() {
//           _donorData = snapshot.data() as Map<String, dynamic>;
//         });
//       }
//     }
//   }
//
//   Future<void> _updateLastDonationDate(DateTime newDate) async {
//     if (_user != null) {
//       await _firestore.collection('donors').doc(_user!.uid).update({
//         'lastDonationDate': newDate,
//       });
//       _fetchDonorData(); // Refresh data after update
//     }
//   }
//
//   bool _isEligible() {
//     if (_donorData == null || _donorData!['lastDonationDate'] == null) {
//       return false; // Not eligible if no donation date
//     }
//     DateTime lastDonationDate = (_donorData!['lastDonationDate'] as Timestamp).toDate();
//     DateTime fourMonthsLater = lastDonationDate.add(const Duration(days: 120));
//     return DateTime.now().isAfter(fourMonthsLater);
//   }
//
//   String _getEligibilityStatus() {
//     if (_isEligible()) {
//       return "Eligible";
//     } else {
//       DateTime lastDonationDate = (_donorData!['lastDonationDate'] as Timestamp).toDate();
//       DateTime fourMonthsLater = lastDonationDate.add(const Duration(days: 120));
//       Duration remaining = fourMonthsLater.difference(DateTime.now());
//       return "Recharging (${remaining.inDays} days)";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Donor Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.account_circle),
//             onPressed: () {
//               _showProfileOptions(context);
//             },
//           ),
//         ],
//       ),
//       body: _donorData == null
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   _donorData!['name'] ?? 'N/A',
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   _getEligibilityStatus(),
//                   style: TextStyle(
//                     color: _isEligible() ? Colors.green : Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildDetailRow('Blood Group', _donorData!['bloodGroup'] ?? 'N/A'),
//             _buildDetailRow('Phone', _donorData!['phone'] ?? 'N/A'),
//             _buildDetailRow('Address', _donorData!['address'] ?? 'N/A'),
//             _buildDetailRow(
//                 'Last Donation',
//                 _donorData!['lastDonationDate'] != null
//                     ? DateFormat('dd MMM yyyy').format(
//                     (_donorData!['lastDonationDate'] as Timestamp)
//                         .toDate())
//                     : 'N/A'),
//             const SizedBox(height: 20),
//             const Text(
//               'Previous Donations:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             // You can add a list of previous donations here, if you store them in Firebase
//             // Example:
//             // Expanded(
//             //   child: ListView.builder(
//             //     itemCount: _donorData!['previousDonations']?.length ?? 0,
//             //     itemBuilder: (context, index) {
//             //       DateTime donationDate = (_donorData!['previousDonations'][index] as Timestamp).toDate();
//             //       return ListTile(
//             //         title: Text(DateFormat('dd MMM yyyy').format(donationDate)),
//             //       );
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(value),
//         ],
//       ),
//     );
//   }
//
//   void _showProfileOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Log Out'),
//               onTap: () {
//                 _auth.signOut();
//                 Navigator.of(context).pop(); // Close the bottom sheet
//                 Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.update),
//               title: const Text('Update Last Donation Date'),
//               onTap: () {
//                 Navigator.of(context).pop(); // Close the bottom sheet
//                 _selectDate(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       _updateLastDonationDate(picked);
//     }
//   }
// }



class DonorDashboard extends StatelessWidget {
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
