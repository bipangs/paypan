import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypan/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _topUpController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;


  void _topUpBalance() async {
    String? userId =
        Provider.of<UserProvider>(context, listen: false).user?.userId;
    if (userId != null && _topUpController.text.isNotEmpty) {
      try {
        int topUpAmount = int.parse(_topUpController.text);

        // Get the current balance from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();
        int currentBalance =
            (userDoc.data() as Map<String, dynamic>)['balance'] ?? 0;

        // Update the balance
        int newBalance = currentBalance + topUpAmount;
        await _firestore.collection('users').doc(userId).update({
          'balance': newBalance,
        });

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Top-up successful! New balance: $newBalance')),
        );

        // Clear the text field
        _topUpController.clear();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Top-up failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: [
          AnimatedContainer(
            duration: Duration(seconds: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF003087), // Darker blue
                  Color(0xFF0070BA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/paypan_logo.png', height: 100),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Rp',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Futura',
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: _topUpController,
                        decoration: InputDecoration(
                          labelText: "Enter top-up amount",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _topUpBalance,
                    child: Text(
                      "Top Up",
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontFamily: 'Futura',
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
