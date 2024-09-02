import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DocumentReference userDocRef;

  @override
  void initState() {
    super.initState();
    _initializeUserDocRef();
  }

  void _initializeUserDocRef() {
    // Get the current user ID from FirebaseAuth
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // Use the actual user ID to reference the document
      userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    } else {
      // Handle the case where userId is null (e.g., not logged in)
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _changeUsername() async {
    String? newUsername =
        await _showInputDialog("Change Username", "Enter new username");
    if (newUsername != null) {
      await userDocRef.update({'username': newUsername});
    }
  }

  Future<void> _changePhoneNumber() async {
    String? newPhoneNumber =
        await _showInputDialog("Change Phone Number", "Enter new phone number");
    if (newPhoneNumber != null) {
      await userDocRef.update({'phone_number': newPhoneNumber});
    }
  }

  Future<String?> _showInputDialog(String title, String hint) {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () => Navigator.of(context).pop(controller.text),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(
        '/login'); // Adjust this route to match your login page route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.blue[900],
            fontFamily: 'Futura',
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == "Change Username") {
                _changeUsername();
              } else if (choice == "Change Phone Number") {
                _changePhoneNumber();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Change Username', 'Change Phone Number'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDocRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No data found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String username = userData['username'] ?? "Unknown";
          String phoneNumber = userData['phone_number'] ?? "Unknown";

          return Stack(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF003087),
                      Color(0xFF0070BA),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/paypan_logo.png',
                    height: 200,
                  ),
                  Text(
                    "$username",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Futura',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Text(
                    "Phone Number: $phoneNumber",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Futura',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _logout,
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontFamily: 'Futura',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
