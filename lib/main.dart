import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:petcoin/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/home': (context) => MainPage(),
      },
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
    );
  }
}
