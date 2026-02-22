import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_design/account_screen.dart';
import 'package:responsive_design/auth_service.dart';
import 'package:responsive_design/success_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? logoutMessage;
  final String? signupMessage;
  
  const LoginScreen({
    super.key,
    this.logoutMessage,
    this.signupMessage,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _passHidden = true;

  // there could be mulitple forms, this assigns a unique key to each form
  // and calls the validator function for each field in the form
  final _formKey = GlobalKey<FormState>();

  // objext used for extracting data from fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;  // spinning circle feedback

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Show message if provided (either from logout or signup)
    if (widget.logoutMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: widget.logoutMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      });
    } else if (widget.signupMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: widget.signupMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true, // make the screen push up when keyboard pops up
      appBar: AppBar(title: Text('Login')
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,  // key is basically an ID for a particular form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height:20),
                _username(),
                const SizedBox(height:20),
                _password(),
                const SizedBox(height:30),

                // show a spinning circle while logging in
                _isLoading ? const CircularProgressIndicator() : _loginButton(),
                const SizedBox(height:20),
                _createAccountButton()
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _header() {
    return const Text(
      'Welcome Back',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _username() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _passHidden,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_passHidden ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _passHidden = !_passHidden;
            });
          },
        )
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!value.contains(RegExp(r'[A-Z]'))) {
          return 'Password must contain at least one uppercase letter';
        }
        if (!value.contains(RegExp(r'[a-z]'))) {
          return 'Password must contain at least one lowercase letter';
        }
        if (!value.contains(RegExp(r'[0-9]'))) {
          return 'Password must contain at least one digit';
        }
        if (!value.contains(RegExp(r'[^\w\s]'))) {
          return 'Password must contain at least one symbol';
        }
        return null;
      },
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () { _submitLogin(); }, 
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Login')
    );
  }

  Widget _createAccountButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AccountScreen()),
        );
      },
      child: const Text('New here? Create an account'),
    );
  }

  void _submitLogin() async {

    if (!_formKey.currentState!.validate()) return;

    // start spinnning the progresss indicator
    setState(() => _isLoading = true);

    // call the sign in function
    final email = _usernameController.text;
    final password = _passwordController.text;

    try {
      await _authService.signIn(email: email, password: password);

      // from the inherited State we can check to make sure the 
      // signing widget is still on the screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SuccessScreen())
        );
      }
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: 'Check that your username and password are correct. \n\n $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  } // _submitLogin
}