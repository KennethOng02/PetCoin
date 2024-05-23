import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _inputField(context),
            _login(context),
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
        'Sign up',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      Text(
        'Create an account',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
    ],
  );
}

Widget _inputField(context) {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
            hintText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
          controller: emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
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
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            } else if (value.length < 8) {
              return 'Username must be at least 8 character';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
          controller: confirmPasswordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            } else if (value.length < 8) {
              return 'Username must be at least 8 character';
            } else if (value != passwordController.text) {
              return 'Password does not match';
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
            'Sign up',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Processing Data')),
              // );
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text that the user has entered by using the
                    // TextEditingController.
                    content: Text(usernameController.text),
                  );
                },
              );
            }
          },
        ),
      ],
    ),
  );
}

Widget _login(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Already have an account?'),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Login',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      )
    ],
  );
}
