import 'package:flutter/material.dart';
import 'package:responsive_design/auth_service.dart';
import 'package:responsive_design/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final _authService = AuthService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _successIcon(),
              const SizedBox(height: 30),
              _successMessage(),
              const SizedBox(height: 20),
              _userEmail(),
              const SizedBox(height: 50),
              _logoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _successIcon() {
    return const Center(
      child: Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 100,
      ),
    );
  }

  Widget _successMessage() {
    return const Text(
      'Welcome!',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _userEmail() {
    return Text(
      'You have successfully logged in as:\n${_currentUser?.email ?? "User"}',
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: () async {
        await _authService.signOut();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(logoutMessage: 'You have successfully logged out.'),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Logout'),
    );
  }
}
