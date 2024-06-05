import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petcoin/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthService().signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await AuthService().createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(BuildContext context) {
    return const Column(
      children: [
        Text(
          'P E T C O I N',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text(
          'Start Budgeting!',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: theme.colorScheme.primary.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.mail),
            ),
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              } else if (value.length < 5) {
                return 'email must be at least 5 character';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: theme.colorScheme.primary.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 character';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _errorMessage(BuildContext context) {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  Widget _submitButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
      ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          isLogin ? 'Login' : 'Register',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'Register instead' : 'Login instead',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _title(context),
            const SizedBox(height: 20),
            _form(context),
            _errorMessage(context),
            _submitButton(context),
            _loginOrRegisterButton(context),
          ],
        ),
      ),
    );
  }
}
