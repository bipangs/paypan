import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paypan/pages/home_page.dart';
import 'package:paypan/pages/login_page.dart';
import 'package:paypan/pages/payment_page.dart';
import 'package:paypan/pages/profile_page.dart';
import 'package:paypan/pages/register_page.dart';
import 'package:paypan/pages/splash_screen.dart';
import 'package:paypan/pages/top_up_page.dart';
import 'package:paypan/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/payment': (context) => PaymentPage(),
        '/profile': (context) => ProfilePage(),
        '/register': (context) => RegisterPage(),
        '/top_up': (context) => TopUpPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('404'),
            ),
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
      },
    );
  }
}
