import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:petcoin/firebase_options.dart';
import 'package:petcoin/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}
