import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
                _loginButton()
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
          return 'Please enter your username';
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

  void _submitLogin() {
    // call all of the validator functions in the Form
    // I am certain currentState is not going to be null so I can put the bang at the end to get rid of error
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text; // captured password
      
      // proceed with authentication using username and password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('logging in user $username'))
      );
    }
  }
}