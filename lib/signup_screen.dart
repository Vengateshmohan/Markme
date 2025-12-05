// import 'package:flutter/material.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final nameCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final cpassCtrl = TextEditingController();
//
//   String userType = ""; // <-- employee or company
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Create Account"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // 🔥 SELECTION BUTTONS
//             const Text(
//               "Select Account Type",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//
//             Row(
//               children: [
//                 // COMPANY BUTTON
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: userType == "company"
//                           ? Colors.blue
//                           : Colors.grey[300],
//                       foregroundColor:
//                       userType == "company" ? Colors.white : Colors.black,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         userType = "company";
//                       });
//                     },
//                     child: const Text("Company"),
//                   ),
//                 ),
//
//                 const SizedBox(width: 15),
//
//                 // EMPLOYEE BUTTON
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: userType == "employee"
//                           ? Colors.blue
//                           : Colors.grey[300],
//                       foregroundColor:
//                       userType == "employee" ? Colors.white : Colors.black,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         userType = "employee";
//                       });
//                     },
//                     child: const Text("Employee"),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 30),
//
//             // NAME
//             TextField(
//               controller: nameCtrl,
//               decoration: const InputDecoration(
//                 labelText: "Full Name",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // EMAIL
//             TextField(
//               controller: emailCtrl,
//               decoration: const InputDecoration(
//                 labelText: "Email",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // PHONE
//             TextField(
//               controller: phoneCtrl,
//               decoration: const InputDecoration(
//                 labelText: "Phone Number",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // PASSWORD
//             TextField(
//               controller: passCtrl,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Password",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // CONFIRM PASSWORD
//             TextField(
//               controller: cpassCtrl,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Confirm Password",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // SIGNUP BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (userType == "") {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Please select Employee or Company"),
//                       ),
//                     );
//                     return;
//                   }
//
//                   Navigator.pushReplacementNamed(context, '/home');
//                 },
//                 child: const Text("Sign Up"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final nameCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final cpassCtrl = TextEditingController();
//
//   String selectedRole = "employee"; // Default
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Account")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameCtrl,
//               decoration: const InputDecoration(labelText: "Full Name"),
//             ),
//             const SizedBox(height: 15),
//
//             TextField(
//               controller: emailCtrl,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             const SizedBox(height: 15),
//
//             TextField(
//               controller: passCtrl,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),
//             const SizedBox(height: 15),
//
//             TextField(
//               controller: cpassCtrl,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Confirm Password"),
//             ),
//             const SizedBox(height: 20),
//
//             // ROLE SELECTION
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Radio(
//                   value: "company",
//                   groupValue: selectedRole,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedRole = value.toString();
//                     });
//                   },
//                 ),
//                 const Text("Company"),
//
//                 Radio(
//                   value: "employee",
//                   groupValue: selectedRole,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedRole = value.toString();
//                     });
//                   },
//                 ),
//                 const Text("Employee"),
//               ],
//             ),
//
//             const SizedBox(height: 30),
//
//             ElevatedButton(
//               onPressed: signupUser,
//               style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
//               child: const Text("Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future signupUser() async {
//     if (passCtrl.text != cpassCtrl.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }
//
//     try {
//       // Create user
//       UserCredential cred = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//         email: emailCtrl.text.trim(),
//         password: passCtrl.text.trim(),
//       );
//
//       // Store user data in Firestore
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(cred.user!.uid)
//           .set({
//         "name": nameCtrl.text.trim(),
//         "email": emailCtrl.text.trim(),
//         "role": selectedRole,
//         "createdAt": Timestamp.now(),
//       });
//
//       Navigator.pushReplacementNamed(context, "/login");
//
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Common controllers
  final emailCtrl = TextEditingController();
  final emppassCtrl = TextEditingController();
  final adpassCtrl = TextEditingController();
  final empcpassCtrl = TextEditingController();
  final adcpassCtrl = TextEditingController();


  // Employee controllers
  final empNameCtrl = TextEditingController();

  // Company controllers
  final companyNameCtrl = TextEditingController();
  final adminNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  String selectedRole = "employee"; // default role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ROLE SELECTION at top
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: "company",
                  groupValue: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value.toString();
                    });
                  },
                ),
                const Text("Company"),
                Radio(
                  value: "employee",
                  groupValue: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value.toString();
                    });
                  },
                ),
                const Text("Employee"),
              ],
            ),
            const SizedBox(height: 20),

            // DYNAMIC FORM FIELDS
            if (selectedRole == "employee") ...[
              TextField(
                controller: empNameCtrl,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emppassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: empcpassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Confirm Password"),
              ),
            ] else
              ...[
                TextField(
                  controller: companyNameCtrl,
                  decoration: const InputDecoration(labelText: "Company Name"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: adminNameCtrl,
                  decoration: const InputDecoration(labelText: "Admin Name"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: adpassCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: adcpassCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Confirm Password"),
                ),
              ],

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: signupUser,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

//   Future signupUser() async {
//     if (emppassCtrl.text != empcpassCtrl.text) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }
//
//     try {
//       // CREATE USER
//       UserCredential cred = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//         email: emailCtrl.text.trim(),
//         password: emppassCtrl.text.trim(),
//       );
//
//       // STORE DATA IN FIRESTORE BASED ON ROLE
//       if (selectedRole == "employee") {
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc("employee")
//             .collection("userInfo")
//             .doc(cred.user!.uid)
//             .set({
//           "name": empNameCtrl.text.trim(),
//           "email": emailCtrl.text.trim(),
//           "role": "employee",
//           "createdAt": Timestamp.now(),
//         });
//       } else {
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc("company")
//             .collection("companyInfo")
//             .doc(cred.user!.uid)
//             .set({
//           "companyName": companyNameCtrl.text.trim(),
//           "adminName": adminNameCtrl.text.trim(),
//           "email": emailCtrl.text.trim(),
//           "phone": phoneCtrl.text.trim(),
//           "role": "company",
//           "createdAt": Timestamp.now(),
//         });
//       }
//
//       // NAVIGATE TO LOGIN SCREEN
//       Navigator.pushReplacementNamed(context, "/login");
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }


  Future signupUser() async {
    // Password validation
    if (selectedRole == "employee") {
      if (emppassCtrl.text != empcpassCtrl.text) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            const SnackBar(content: Text("Employee passwords do not match")));
        return;
      }
    } else {
      if (adpassCtrl.text != adcpassCtrl.text) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            const SnackBar(content: Text("Company passwords do not match")));
        return;
      }
    }

    try {
      // CREATE USER IN FIREBASE AUTH
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: selectedRole == "employee"
            ? emppassCtrl.text.trim()
            : adpassCtrl.text.trim(),
      );

      // STORE DATA IN FIRESTORE
      if (selectedRole == "employee") {
        await FirebaseFirestore.instance
            .collection("users")
            .doc("employee")
            .collection("userInfo")
            .doc(cred.user!.uid)
            .set({
          "name": empNameCtrl.text.trim(),
          "email": emailCtrl.text.trim(),
          "password": emppassCtrl.text.trim(), // <<< storing password
          "role": "employee",
          "createdAt": Timestamp.now(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("users")
            .doc("company")
            .collection("companyInfo")
            .doc(cred.user!.uid)
            .set({
          "companyName": companyNameCtrl.text.trim(),
          "adminName": adminNameCtrl.text.trim(),
          "email": emailCtrl.text.trim(),
          "phone": phoneCtrl.text.trim(),
          "password": adpassCtrl.text.trim(), // <<< storing password
          "role": "company",
          "createdAt": Timestamp.now(),
        });
      }

      // GO TO LOGIN SCREEN
      Navigator.pushReplacementNamed(context, "/login");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}