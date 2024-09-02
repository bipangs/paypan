import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceWidget extends StatelessWidget {
  final String userId;

  BalanceWidget({required this.userId});

  Future<String> getBalance() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    int balance = (userDoc.data() as Map<String, dynamic>)['balance'] ?? 0;
    return balance.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No balance found');
        }

        return Container(
          width: double.infinity,
          height: 140,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 13, 31, 165),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              _buildBalanceDetail("Balance", snapshot.data!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceDetail(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
