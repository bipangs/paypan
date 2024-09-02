import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypan/components/my_gradient_background.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new user with Firebase Auth
        UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Add additional user data to Firestore
        await _firestore.collection('users').doc(newUser.user!.uid).set({
          'full_name': _fullNameController.text.trim(),
          'username': _usernameController.text.trim(),
          'phone_number': _phoneNumberController.text.trim(),
          'email': _emailController.text.trim(),
          'balance': 0
        });

        // Navigate back to the login page after successful registration
        Navigator.pop(context);
      } catch (e) {
        // Handle errors here, such as showing a snackbar or alert dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to register: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Registration form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(labelText: "Full Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        } else if (value.length < 5) {
                          return "Name must be at least 5 characters!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: "Username"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a username";
                        } else if (value.length < 5) {
                          return "Username must be at least 5 characters";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(labelText: "Phone Number"),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration:
                          InputDecoration(labelText: "Confirm Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      child: Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
