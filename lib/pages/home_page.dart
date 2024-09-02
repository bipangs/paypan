import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Make sure to add this dependency
import 'package:paypan/pages/payment_page.dart';
import 'package:paypan/pages/profile_page.dart';
import 'package:paypan/pages/top_up_page.dart';
import 'package:paypan/providers/user_provider.dart';
import 'package:paypan/widgets/header_widget.dart';
import 'package:paypan/widgets/balance_widget.dart';
import 'package:paypan/widgets/actions_row_widget.dart';
import 'package:paypan/widgets/bottom_navbar_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final PageController _controller = PageController(initialPage: 0);
  String fullName = '';
  String balance = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Get the userID from UserProvider
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?.userId;

    if (userId == null) {
      // Handle the case where userId is null
      return;
    }

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        fullName = userDoc.data()?['full_name'] ?? '';
        balance = userDoc.data()?['balance']?.toString() ?? '0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text("No user is signed in"),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  _buildHomeContent(context,
                      userId), // This should be the content of the home page
                  TopUpPage(),
                  PaymentPage(),
                  ProfilePage(),
                ],
              ),
            ),
            BottomNavbarWidget(
              currentIndex: index,
              onTap: (int newIndex) {
                setState(() {
                  index = newIndex;
                  _controller.jumpToPage(newIndex);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, String userId) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderWidget(name: fullName),
            SizedBox(height: 20),
            BalanceWidget(userId: userId),
            SizedBox(height: 20),
            ActionsRowWidget(),
          ],
        ),
      ),
    );
  }
}
