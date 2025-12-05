// import 'package:flutter/material.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             children: [
//
//               const SizedBox(height: 60),
//
//               // 🔥 TOP CENTER LOGO
//               Center(
//                 child: Image.asset(
//                   'assets/login_logo.png',
//                   height: 120,   // adjust size
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               Text(
//                 "MarkMe",
//                 style: TextStyle(
//                   fontSize: 34,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               TextField(
//                 controller: emailCtrl,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               TextField(
//                 controller: passCtrl,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/home');
//                   },
//                   child: const Text("Login"),
//                 ),
//               ),
//
//               const SizedBox(height: 15),
//
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushNamed(context, '/signup');
//                 },
//                 child: const Text(
//                   "Create Account",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 40),
//
//             TextField(
//               controller: emailCtrl,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             const SizedBox(height: 20),
//
//             TextField(
//               controller: passCtrl,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),
//             const SizedBox(height: 30),
//
//             ElevatedButton(
//               onPressed: loginUser,
//               style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
//               child: const Text("Login"),
//             ),
//
//             SizedBox(height: 20,),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/signup');
//               },
//               child: const Text(
//                 "Create an Account",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 16,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future loginUser() async {
//     try {
//       // Login user
//       UserCredential cred = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//         email: emailCtrl.text.trim(),
//         password: passCtrl.text.trim(),
//       );
//
//       // Get user role
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(cred.user!.uid)
//           .get();
//
//       String role = userDoc["role"];
//
//       if (role == "company") {
//         Navigator.pushReplacementNamed(context, "/companyHome");
//       } else {
//         Navigator.pushReplacementNamed(context, "/employeeHome");
//       }
//
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();


  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }
  bool isValidPassword(String pass) {
    return pass.length >= 6;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email",border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: passCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,  // Show number-only keyboard
              maxLength: 6,                         // Limit password to 6 digits
              decoration: const InputDecoration(
                labelText: "Password",
                counterText: "",                    // Removes the small text showing "0/6"
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
                onPressed: () async {
                  String email = emailCtrl.text.trim();
                  String pass = passCtrl.text.trim();

                  // --------------------------- Validations -----------------------------

                  if (email.isEmpty || pass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All fields are required")),
                    );
                    return;
                  }

                  if (!isValidEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter a valid email address")),
                    );
                    return;
                  }

                  if (pass.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password must be at least 6 characters")),
                    );
                    return;
                  }

                  // ----------------------------- LOGIN USER -----------------------------

                  try {
                    // Firebase login
                    UserCredential cred = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: email,
                      password: pass,
                    );

                    final uid = cred.user!.uid;
                    String? role;

                    // Check employee collection
                    DocumentSnapshot empDoc = await FirebaseFirestore.instance
                        .collection("users")
                        .doc("employee")
                        .collection("userInfo")
                        .doc(uid)
                        .get();

                    if (empDoc.exists) {
                      role = "employee";
                      String fcm = await FirebaseMessaging.instance.getToken() ?? "";

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc("employee")
                          .collection("userInfo")
                          .doc(uid)
                          .update({
                        "fcmToken": fcm,
                      });

                    } else {
                      // Check company collection
                      DocumentSnapshot compDoc = await FirebaseFirestore.instance
                          .collection("users")
                          .doc("company")
                          .collection("companyInfo")
                          .doc(uid)
                          .get();

                      if (compDoc.exists) {
                        role = "company";
                      }
                    }

                    // Role-based navigation
                    if (role == "company") {
                      Navigator.pushReplacementNamed(context, "/companyHome");
                    } else if (role == "employee") {
                      Navigator.pushReplacementNamed(context, "/employeeHome");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User data not found")),
                      );
                    }

                  } catch (e) {
                    String message = e.toString();

                    // Clean developer message
                    if (message.contains("user-not-found")) {
                      message = "No account found for this email.";
                    } else if (message.contains("wrong-password")) {
                      message = "Incorrect password.";
                    } else if (message.contains("invalid-email")) {
                      message = "Invalid email format.";
                    }

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  }
                },

                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Login"),
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                "Create an Account",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future loginUser() async {
    try {
      // 1️⃣ Login with Firebase Auth
      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final uid = cred.user!.uid;
      String? role;

      // 2️⃣ Check in employee collection
      DocumentSnapshot empDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc("employee")
          .collection("userInfo")
          .doc(uid)
          .get();

      if (empDoc.exists) {
        role = "employee";
      } else {
        // 3️⃣ Check in company collection
        DocumentSnapshot compDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc("company")
            .collection("companyInfo")
            .doc(uid)
            .get();

        if (compDoc.exists) {
          role = "company";
        }
      }

      // 4️⃣ Navigate based on role
      if (role == "company") {
        Navigator.pushReplacementNamed(context, "/companyHome");
      } else if (role == "employee") {
        Navigator.pushReplacementNamed(context, "/employeeHome");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User data not found."))
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

