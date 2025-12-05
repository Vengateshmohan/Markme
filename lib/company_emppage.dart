import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeesPage extends StatelessWidget {
  final String companyId;
  final String companyName;


  EmployeesPage({super.key,   required this.companyId,
    required this.companyName, });




  void _showAddEmployeeDialog(BuildContext context) {





    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add Employee"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Employee Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email is required")),
                  );
                  return;
                }

                final emp = await findEmployeeByEmail(email);

                if (emp == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Employee not found")),
                  );
                  return;
                }

                String employeeUid = emp["uid"];

                await FirebaseFirestore.instance
                    .collection("notifications")
                    .doc(employeeUid)
                    .collection("messages")
                    .add({
                  "fromCompany": companyName,        // REAL NAME
                  "companyId": companyId,            // REAL ID
                  "message": "$companyName wants to add you as employee",
                  "status": "pending",
                  "timestamp": FieldValue.serverTimestamp(),
                });



                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("In-app notification sent")),
                );
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>?> findEmployeeByEmail(String email) async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc("employee")
        .collection("userInfo")
        .where("email", isEqualTo: email)
        .get();

    if (snap.docs.isEmpty) return null;

    return {
      "uid": snap.docs.first.id,
      "data": snap.docs.first.data(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(
                  icon: Icons.person_add,
                  color: Colors.blue,
                  text: "Add Employee",
                  onTap: () => _showAddEmployeeDialog(context),
                ),
                _actionButton(
                  icon: Icons.work,
                  color: Colors.green,
                  text: "Assign Work",
                  onTap: () => Navigator.pushNamed(context, "/assignWork"),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Employees",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("companies")
                  .doc(companyId)
                  .collection("employees")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No employees added yet"));
                }

                final employees = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    var data = employees[index].data();
                    return _employeeCard(
                      name: data["name"] ?? "Unknown",
                      email: data["email"] ?? "",
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _employeeCard({required String name, required String email}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(email),
      ),
    );
  }
}
