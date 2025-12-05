import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    handleNavigation();
  }

  Future<void> handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    User? user = FirebaseAuth.instance.currentUser;

    // Not logged in → go to Login
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    String uid = user.uid;

    // 1️⃣ CHECK COMPANY COLLECTION
    DocumentSnapshot companyDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc("company")
        .collection("companyInfo")
        .doc(uid)
        .get();


    if (companyDoc.exists) {
      // Logged-in user is a company
      Navigator.pushReplacementNamed(context, '/companyHome');
      return;
    }

    // 2️⃣ CHECK EMPLOYEE COLLECTION
    DocumentSnapshot employeeDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc("employee")
        .collection("userInfo")
        .doc(uid)
        .get();

    if (employeeDoc.exists) {
      // Logged-in user is an employee
      Navigator.pushReplacementNamed(context, '/employeeHome');
      return;
    }

    // 3️⃣ NO DATA → force login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/MarkMe_logo.png',
          width: 180,
          height: 180,
        ),
      ),
    );
  }
}
