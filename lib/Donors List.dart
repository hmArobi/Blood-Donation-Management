import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BackgroundGradient.dart';

class SeekerDashboard extends StatefulWidget {
  @override
  _SeekerDashboardState createState() => _SeekerDashboardState();
}

class _SeekerDashboardState extends State<SeekerDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _donors = [];
  List<Map<String, dynamic>> _filteredDonors = [];
  String _selectedStatus = 'All';
  String _selectedBloodGroup = 'All';
  String _districtQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDonors();
  }

  Future<void> _fetchDonors() async {
    QuerySnapshot snapshot = await _firestore.collection('donors').get();
    setState(() {
      _donors = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      _filteredDonors = _donors;
    });
  }

  void _filterDonors() {
    setState(() {
      _filteredDonors = _donors.where((donor) {

        bool bloodGroupMatch = _selectedBloodGroup == 'All' ||
            donor['bloodGroup'] == _selectedBloodGroup;

        bool districtMatch = _districtQuery.isEmpty ||
            donor['district'].toLowerCase().contains(_districtQuery.toLowerCase());

        bool statusMatch = _selectedStatus == 'All' ||
            (_selectedStatus == 'AVAILABLE' && _isDonorAvailable(donor)) ||
            (_selectedStatus == 'RECHARGING' && !_isDonorAvailable(donor));

        return statusMatch && bloodGroupMatch && districtMatch;
      }).toList();
    });
  }

  bool _isDonorAvailable(Map<String, dynamic> donor) {
    if (donor['lastDonationDate'] == null) return true;
    DateTime lastDonationDate = (donor['lastDonationDate'] as Timestamp).toDate();
    return DateTime.now().difference(lastDonationDate).inDays >= 120;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Find Donors", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
      ),
      body: BackgroundGradient(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  // Blood Group Filter
                  Container(
                    child: DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      decoration: InputDecoration(
                        labelText: 'Filter by Blood Group',
                        prefixIcon: Icon(Icons.bloodtype, color: Colors.red[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      dropdownColor: Colors.white,
                      items: ['All', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((group) {
                        return DropdownMenuItem(
                          value: group,
                          child: Text(group,style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodGroup = value!;
                          _filterDonors();
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 10),

                  // District Filter (Text Input)
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by District',
                      prefixIcon: Icon(Icons.location_on, color: Colors.red[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                      style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        _districtQuery = value;
                        _filterDonors();
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Status Filter
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Filter by Status',
                      prefixIcon: Icon(Icons.filter_list, color: Colors.red[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                    ),
                    ),
                    style: TextStyle(color: Colors.black),
                    dropdownColor: Colors.white,
                    items: ['All', 'AVAILABLE', 'RECHARGING'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status,style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                        _filterDonors();
                      });
                    },
                  ),

                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredDonors.length,
                itemBuilder: (context, index) {
                  final donor = _filteredDonors[index];
                  final isAvailable = _isDonorAvailable(donor);

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.person, color: Colors.white)
                      ),
                      title: Text(donor['name'], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bloodtype, size: 16, color: Colors.red[700]),
                              SizedBox(width: 5),
                              Text("Blood Group: ${donor['bloodGroup']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16, color: Colors.red[700]),
                              SizedBox(width: 5),
                              Text("Contact: ${donor['contact']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.red[700]),
                              SizedBox(width: 5),
                              Text("District: ${donor['district']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle, size: 16, color: isAvailable ? Colors.green[800] : Colors.red),
                              SizedBox(width: 5),
                              Text(
                                "Status: ${isAvailable ? 'AVAILABLE' : 'RECHARGING'}",
                                style: TextStyle(
                                  color: isAvailable ? Colors.green[800] : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.0,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.phone, color: Colors.red[700]),
                          onPressed: () {
                            // Implement Function to Call the donor
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}