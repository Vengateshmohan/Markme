import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeNotificationsPage extends StatelessWidget {
  final String employeeUid;

  const EmployeeNotificationsPage({super.key, required this.employeeUid});

  // ⭐ MAIN ACCEPT FUNCTION
  Future<void> _acceptJoinRequest({
    required String employeeUid,
    required String docId,
    required BuildContext context,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // 1️⃣ Get notification details (companyId, companyName)
    DocumentSnapshot noti = await firestore
        .collection("notifications")
        .doc(employeeUid)
        .collection("messages")
        .doc(docId)
        .get();

    String companyId = noti["companyId"];
    String companyName = noti["fromCompany"];

    // 2️⃣ Fetch employee details
    DocumentSnapshot userDoc = await firestore
        .collection("users")
        .doc("employee")
        .collection("userInfo")
        .doc(employeeUid)
        .get();

    String empName = userDoc["name"];
    String empEmail = userDoc["email"];

    // 3️⃣ Add employee under company > employees collection
    await firestore
        .collection("companies")
        .doc(companyId)
        .collection("employees")
        .doc(employeeUid)
        .set({
      "name": empName,
      "email": empEmail,
      "joinedDate": DateTime.now(),
      "uid": employeeUid,
    });


    // 4️⃣ Update employee profile with company details
    await firestore
        .collection("users")
        .doc("employee")
        .collection("userInfo")
        .doc(employeeUid)
        .update({
      "companyId": companyId,
      "companyName": companyName,
      "joined": true,
    });

    // 5️⃣ Update notification status
    await firestore
        .collection("notifications")
        .doc(employeeUid)
        .collection("messages")
        .doc(docId)
        .update({"status": "accepted"});

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Successfully joined the company!")),
    );
  }

  // ⭐ JOIN CONFIRMATION POPUP
  void _showJoinDialog(
      BuildContext context, String employeeUid, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Do you want to join this company?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _acceptJoinRequest(
                  employeeUid: employeeUid,
                  docId: docId,
                  context: context,
                );
              },
              child: const Text("Join"),
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
        title: const Text("Notifications"),
        backgroundColor: Colors.blue,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .doc(employeeUid)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No notifications yet",
                  style: TextStyle(fontSize: 16)),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data = notifications[index].data();

              return _notificationCard(
                title: data["fromCompany"] ?? "Unknown Company",
                message: data["message"] ?? "",
                status: data["status"] ?? "pending",
                time: data["timestamp"],
                docId: notifications[index].id,
                employeeUid: employeeUid,
                context: context,
              );
            },
          );
        },
      ),
    );
  }

  Widget _notificationCard({
    required String title,
    required String message,
    required String status,
    required Timestamp? time,
    required String docId,
    required String employeeUid,
    required BuildContext context,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.notifications, color: Colors.white),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),

        trailing: status != "accepted"
            ? ElevatedButton(
          onPressed: () {
            _showJoinDialog(context, employeeUid, docId);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("JOIN"),
        )
            : Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "ACCEPTED",
            style: TextStyle(color: Colors.white),
          ),
        ),

      ),
    );
  }
}
