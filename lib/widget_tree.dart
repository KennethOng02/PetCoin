import 'package:flutter/material.dart';
import 'package:petcoin/services/auth_service.dart';
import 'package:petcoin/screens/login_register_page.dart';
import 'package:petcoin/screens/main_page.dart';

class WidgetTree extends StatefulWidget {
  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
