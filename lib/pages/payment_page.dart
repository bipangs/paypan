import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypan/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  void _makePayment() async {
    String? userId =
        Provider.of<UserProvider>(context, listen: false).user?.userId;
    String recipientUsername = _usernameController.text.trim();
    if (userId != null &&
        _paymentController.text.isNotEmpty &&
        recipientUsername.isNotEmpty) {
      try {
        int paymentAmount = int.parse(_paymentController.text);

        // Get the current user's balance
        DocumentSnapshot currentUserDoc =
            await _firestore.collection('users').doc(userId).get();
        int currentBalance =
            (currentUserDoc.data() as Map<String, dynamic>)['balance'] ?? 0;

        if (paymentAmount > currentBalance) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed! Not enough balance!')),
          );
          return;
        }

        // Find the recipient by username
        QuerySnapshot recipientSnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: recipientUsername)
            .limit(1)
            .get();

        if (recipientSnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed! Username not found!')),
          );
          return;
        }

        DocumentSnapshot recipientDoc = recipientSnapshot.docs.first;
        String recipientId = recipientDoc.id;
        int recipientBalance =
            (recipientDoc.data() as Map<String, dynamic>)['balance'] ?? 0;

        // Update balances
        int newCurrentBalance = currentBalance - paymentAmount;
        int newRecipientBalance = recipientBalance + paymentAmount;

        // Update Firestore
        await _firestore.collection('users').doc(userId).update({
          'balance': newCurrentBalance,
        });

        await _firestore.collection('users').doc(recipientId).update({
          'balance': newRecipientBalance,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Payment successful! Your new balance: $newCurrentBalance')),
        );

        _paymentController.clear();
        _usernameController.clear();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all the required fields.')),
      );
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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Image.asset('lib/assets/paypan_logo.png', height: 100),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Enter recipient's username",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
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
                        controller: _paymentController,
                        decoration: InputDecoration(
                          labelText: "Enter payment amount",
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
                    onPressed: _makePayment,
                    child: Text(
                      "Pay",
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
