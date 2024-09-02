import 'package:flutter/material.dart';

class MyGradientBackground extends StatefulWidget {
  final Widget child;

  const MyGradientBackground({super.key, required this.child});

  @override
  _MyGradientBackgroundState createState() => _MyGradientBackgroundState();
}

class _MyGradientBackgroundState extends State<MyGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
    _animation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
