import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'company_emppage.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {

  String? companyId;   // ⭐ store company ID
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCompanyId();
  }
  String? companyName;

  Future<void> fetchCompanyId() async {
    String adminUid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot adminDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc("company")
        .collection("companyInfo")
        .doc(adminUid)
        .get();

    setState(() {
      companyId = adminDoc["companyId"];

      companyName = adminDoc["companyName"];   // ⭐ add this
    });
  }


  @override
  Widget build(BuildContext context) {
    // ⚠ Show loading until companyId is fetched
    if (companyId == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    // AFTER companyId is loaded — now build screens
    final List<Widget> screens = [
      const Center(child: Text("Welcome Admin!")),
      EmployeesPage(companyId: companyId!, companyName: companyName!),  // ⭐ pass both
      const Center(child: Text("Profile Page")),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Company Dashboard")),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.blue), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.apartment, color: Colors.blue), label: "Employees"),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.blue), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Colors.blue), label: "Settings"),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, "/login");
        },
        child: const Text("Logout"),
      ),
    );
  }
}
