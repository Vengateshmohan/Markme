import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

import 'package:intl/intl.dart';

import 'EmployeeNotificationsPage.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  late Timer _timer;
  String _timeString = "00:00:00";



  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _timeString =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String userName = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
    _startTimer();
    fetchLocation();
  }

  Future<void> fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc("employee")
        .collection("userInfo")
        .doc(uid)
        .get();

    setState(() {
      userName = doc["name"] ?? "Employee";
    });
  }


  String today = DateFormat('d MMMM yyyy').format(DateTime.now());
  String currentLocation = "Fetching location...";


  Future<void> fetchLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        currentLocation = "Location service OFF";
      });
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentLocation = "Permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        currentLocation = "Permission permanently denied";
      });
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks =
    await placemarkFromCoordinates(pos.latitude, pos.longitude);

    setState(() {
      currentLocation = "${placemarks[0].locality}, ${placemarks[0].country}";
    });
  }


  ///

  List<Timer?> taskTimers = [null, null, null];


  List<Map<String, dynamic>> tasks = [
    {"title": "Task 1", "started": false, "status": "Pending", "seconds": 0},
    {"title": "Task 2", "started": false, "status": "Pending", "seconds": 0},
    {"title": "Task 3", "started": false, "status": "Pending", "seconds": 0},
  ];

  String formatTime(int sec) {
    int h = sec ~/ 3600;
    int m = (sec % 3600) ~/ 60;
    int s = sec % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }


  void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Confirm"),
          )
        ],
      ),
    );
  }

  final user = FirebaseAuth.instance.currentUser!;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F5FF),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Good morning, $userName!",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 🔔 NOTIFICATION BADGE STREAMBUILDER
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("notifications")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("messages")
                      .where("status", isEqualTo: "pending")
                      .snapshots(),
                  builder: (context, snapshot) {
                    int count = 0;

                    if (snapshot.hasData) {
                      count = snapshot.data!.docs.length;
                    }

                    return Stack(
                      children: [
                        IconButton(
                          onPressed: ()async {


                              String uid = FirebaseAuth.instance.currentUser!.uid;

                              // 🔄 Update all pending notifications to read
                              var pending = await FirebaseFirestore.instance
                                  .collection("notifications")
                                  .doc(uid)
                                  .collection("messages")
                                  .where("status", isEqualTo: "pending")
                                  .get();

                              for (var doc in pending.docs) {
                                doc.reference.update({"status": "seen"});

                              }

                              // 📌 Then navigate
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeNotificationsPage(
                                    employeeUid: uid,
                                  ),
                                ),
                              );




                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeNotificationsPage(
                                  employeeUid:
                                  FirebaseAuth.instance.currentUser!.uid,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications),
                        ),

                        // 🔴 Badge
                        if (count > 0)
                          Positioned(
                            right: 4,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),



            const SizedBox(height: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today, $today",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  currentLocation,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),


            const SizedBox(height: 20),

            // TIMER CARD

            // TASKS SECTION
            _sectionTitle("Your Tasks"),
            const SizedBox(height: 10),

            ...List.generate(tasks.length, (index) => buildTaskCard(index)),



            // Container(
            //   padding: const EdgeInsets.all(20),
            //   decoration: _cardDecoration(),
            //   child: Column(
            //     children: [
            //       Text(_timeString,
            //           style: const TextStyle(
            //               fontSize: 32, fontWeight: FontWeight.bold)),
            //       const SizedBox(height: 10),
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.orange,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(30))),
            //         onPressed: () {},
            //         child: const Padding(
            //           padding:
            //           EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            //           child: Text("End Working",
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold)),
            //         ),
            //       )
            //     ],
            //   ),
            // ),

            const SizedBox(height: 20),

            // TODAY EVENTS
            _sectionTitle("Today Events"),
            _eventCard("Albert's birthday", "08:00 am - 09:00 am", true),
            _eventCard("Meeting with Jason", "13:00 pm - 14:00 pm", false),

            const SizedBox(height: 20),

            // WORKING STATISTIC
            _sectionTitle("Working Statistic"),
            _statsCard(),

            const SizedBox(height: 20),

            // LEAVE ALLOWANCE
            _sectionTitle("Leave Allowance"),
            _leaveSection(),

            const SizedBox(height: 20),

            // REIMBURSEMENT CARD
            _reimbursementCard(),
          ],
        ),
      ),

      // FLOATING RIGHT MENU
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _fabButton(Icons.event, "Event"),
          const SizedBox(height: 12),
          _fabButton(Icons.beach_access, "Leave"),
          const SizedBox(height: 12),
          _fabButton(Icons.receipt_long, "Reimbursement"),
          const SizedBox(height: 12),
          _fabButton(Icons.access_time_filled, "Attendance", active: true),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // WIDGETS BELOW
  // --------------------------------------------------------

  Decoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
            color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold));
  }

  // EVENT CARD
  Widget _eventCard(String title, String time, bool active) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Icon(Icons.calendar_today,
              color: active ? Colors.orange : Colors.blue),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(time, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
          Switch(value: active, onChanged: (_) {})
        ],
      ),
    );
  }

  // WORKING STATISTICS CARD
  Widget _statsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildBar(80, "21 Feb"),
          buildBar(50, "22 Feb"),
          buildBar(40, "23 Feb"),
          buildBar(90, "24 Feb"),
          buildBar(60, "25 Feb"),
        ],
      ),
    );
  }

  Widget buildBar(double height, String label) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }



  // BAR WIDGET




  // LEAVE SECTION
  Widget _leaveSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildLeaveCircle("Annual Leave", 5),
        buildLeaveCircle("Sick Leave", 3),
        buildLeaveCircle("Special Leave", 5),
      ],
    );
  }

  Widget buildLeaveCircle(String label, int days) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xffE8EAFE),
          child: Text(
            "$days",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }



  // LEAVE CIRCLE

  // REIMBURSEMENT CARD
  Widget _reimbursementCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Medical Reimbursement",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text("Rp350.000 / Rp1.000.000"),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.35,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  // FLOAT ACTION MENU BUTTON
  Widget _fabButton(IconData icon, String label, {bool active = false}) {
    return FloatingActionButton(
      backgroundColor: active ? Colors.blue : Colors.white,
      onPressed: () {},
      mini: true,
      child: Icon(icon, color: active ? Colors.white : Colors.black),
    );
  }

  Widget buildTaskCard(int index) {
    final task = tasks[index];
    bool started = task["started"];
    String status = task["status"];
    int seconds = task["seconds"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TASK TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task["title"],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: status == "Pending"
                      ? Colors.grey.shade300
                      : status == "In-Progress"
                      ? Colors.orange.shade300
                      : Colors.green.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // TIMER TEXT
          Text(
            "Time: ${formatTime(seconds)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          // START / END BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: started ? Colors.red : Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              if (!started) {
                // START TASK
                showConfirmDialog(
                  title: "Start Task",
                  message: "Do you want to start ${task["title"]}?",
                  onConfirm: () {
                    setState(() {
                      tasks[index]["started"] = true;
                      tasks[index]["status"] = "In-Progress";

                      // Start timer
                      taskTimers[index]?.cancel();
                      taskTimers[index] =
                          Timer.periodic(const Duration(seconds: 1), (timer) {
                            setState(() {
                              tasks[index]["seconds"] += 1;
                            });
                          });
                    });
                  },
                );
              } else {
                // END TASK
                showConfirmDialog(
                  title: "End Task",
                  message: "Do you want to end ${task["title"]}?",
                  onConfirm: () {
                    setState(() {
                      tasks[index]["started"] = false;
                      tasks[index]["status"] = "Completed";

                      // Stop timer
                      taskTimers[index]?.cancel();
                      taskTimers[index] = null;
                    });
                  },
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                started ? "End Working" : "Start Working",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}


