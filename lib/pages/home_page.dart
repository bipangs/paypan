import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?.userId;

    if (userId == null) {
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
              child: _buildHomeContent(context,
                  userId), // This should be the content of the home page
            ),
            BottomNavbarWidget(
              currentIndex: index,
              onTap: (int newIndex) {
                _navigateToPage(context, newIndex);
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
            const SizedBox(height: 20),
            BalanceWidget(userId: userId),
            const SizedBox(height: 20),
            const ActionsRowWidget(),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/top_up');
        break;
      case 2:
        Navigator.pushNamed(context, '/payment');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }
}
