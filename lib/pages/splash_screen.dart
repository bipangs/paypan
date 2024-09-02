import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..forward().then((_) {
        // Navigate to HomePage
        Navigator.pushReplacementNamed(context, '/home');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 3),
            decoration: const BoxDecoration(
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
          Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(
                      parent: _controller, curve: Curves.easeInOut)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('lib/assets/paypan_logo.png', height: 100),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _controller,
                    child: const Text(
                      'Seamless Payments, Easy Top-ups',
                      style: TextStyle(
                        fontFamily: 'Futura',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
