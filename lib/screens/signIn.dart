import 'package:flutter/material.dart';
import 'package:petcoin/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('L O G I N'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _inputField(context),
            _forgotPassword(context),
            _signup(context),
          ],
        ),
      ),
    );
  }
}

Widget _header(context) {
  return const Column(
    children: [
      Text(
        'Login',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget _inputField(context) {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final theme = Theme.of(context);

  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: theme.colorScheme.primary.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
          controller: usernameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter username';
            } else if (value.length < 5) {
              return 'Username must be at least 5 character';
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
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            } else if (value.length < 8) {
              return 'Password must be at least 8 character';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
            }
          },
        ),
      ],
    ),
  );
}

Widget _forgotPassword(context) {
  return TextButton(
    onPressed: () {},
    child: Text(
      'Forgot Password',
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

Widget _signup(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Dont have an account?'),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignupPage(),
            ),
          );
        },
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      )
    ],
  );
}
