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
  final _firestore = FirebaseFirestore.instance;

  void _topUpBalance() async {
    String? userId =
        Provider.of<UserProvider>(context, listen: false).user?.userId;
    if (userId != null && _paymentController.text.isNotEmpty) {
      try {
        int PaymentAmount = int.parse(_paymentController.text);

        // Get the current balance from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();
        int currentBalance =
            (userDoc.data() as Map<String, dynamic>)['balance'] ?? 0;

        int newBalance = currentBalance;

        // Update the balance
        if (PaymentAmount > currentBalance) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed! Not enough Balance!')),
          );
          return;
        } else {
          newBalance = currentBalance - PaymentAmount;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Payment successful! Your balance: $newBalance')),
          );
        }

        await _firestore.collection('users').doc(userId).update({
          'balance': newBalance,
        });

        _paymentController.clear();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed. Please try again.')),
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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
                    onPressed: _topUpBalance,
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
