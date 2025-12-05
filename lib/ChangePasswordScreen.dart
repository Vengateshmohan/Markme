// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({super.key});
//
//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }
//
// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final oldPassCtrl = TextEditingController();
//   final newPassCtrl = TextEditingController();
//   final confirmPassCtrl = TextEditingController();
//   bool isLoading = false;
//
//   Future<void> updatePassword() async {
//     if (newPassCtrl.text != confirmPassCtrl.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Passwords do not match")),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//
//       AuthCredential credential = EmailAuthProvider.credential(
//         email: user!.email!,
//         password: oldPassCtrl.text.trim(),
//       );
//
//       // 🟢 THIS LINE verifies OLD PASSWORD
//       await user.reauthenticateWithCredential(credential);
//
//       await user.updatePassword(newPassCtrl.text.trim());
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password Updated Successfully!")),
//       );
//
//       Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'wrong-password') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Old password is incorrect")),
//         );
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.message ?? "Error occurred")));
//       }
//     }
//
//     setState(() => isLoading = false);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Change Password")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: oldPassCtrl,
//               obscureText: true,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly, // only allow 0–9
//               ],
//               maxLength: 6,
//               decoration: const InputDecoration(
//                 labelText: "Old Password",
//                 counterText: "",
//               ),
//             ),
//
//             const SizedBox(height: 15),
//
//             TextField(
//               controller: newPassCtrl,
//               obscureText: true,
//               keyboardType: TextInputType.number,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               maxLength: 6,
//               decoration: const InputDecoration(
//                 labelText: "New Password",
//                 counterText: "",
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: confirmPassCtrl,
//               obscureText: true,
//               keyboardType: TextInputType.number,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               maxLength: 6,
//               decoration: const InputDecoration(
//                 labelText: "Confirm New Password",
//                 counterText: "",
//               ),
//             ),
//
//
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: updatePassword,
//               style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
//               child: const Text("Update Password"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void showBottomMessage(String message, {Color? background}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        backgroundColor: background ?? Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> updatePassword() async {
    // Basic local validation (digits only + 6 length)
    final digitOnly = RegExp(r'^\d{6}$');
    if (!digitOnly.hasMatch(oldPassCtrl.text.trim()) ||
        !digitOnly.hasMatch(newPassCtrl.text.trim()) ||
        !digitOnly.hasMatch(confirmPassCtrl.text.trim())) {
      showBottomMessage("Passwords must be exactly 6 digits (numbers only).");
      return;
    }

    if (newPassCtrl.text.trim() != confirmPassCtrl.text.trim()) {
      showBottomMessage("New passwords do not match.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        showBottomMessage("User not logged in. Please login again.");
        setState(() => isLoading = false);
        return;
      }

      // Re-authenticate with OLD password (this verifies correctness)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassCtrl.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // After successful re-auth, update password
      await user.updatePassword(newPassCtrl.text.trim());

      showBottomMessage("Password updated successfully.", background: Colors.green);

      // Optionally sign out or navigate back
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Map Firebase error codes to user-friendly messages
      String friendlyMessage;
      switch (e.code) {
        case 'wrong-password':
          friendlyMessage = "Old password is incorrect.";
          break;
        case 'weak-password':
          friendlyMessage = "New password is too weak. Choose a stronger 6-digit PIN.";
          break;
        case 'requires-recent-login':
        // This means the user must re-login to perform sensitive operations
          friendlyMessage = "Please login again and try updating your password.";
          break;
        case 'user-disabled':
          friendlyMessage = "User account is disabled. Contact support.";
          break;
        case 'network-request-failed':
          friendlyMessage = "Network error. Check your internet connection.";
          break;
        default:
        // Generic friendly message for any other code
          friendlyMessage = "Could not update password. Please try again.";
      }

      showBottomMessage(friendlyMessage);
    } catch (e) {
      // Any other non-Firebase errors
      showBottomMessage("Something went wrong. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: oldPassCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: "Old Password (6 digits)",
                counterText: "",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: "New Password (6 digits)",
                counterText: "",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: confirmPassCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: "Confirm New Password (6 digits)",
                counterText: "",
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: updatePassword,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}
