import 'package:flutter/material.dart';

class DuelPage extends StatelessWidget {
  final String friendName;

  DuelPage({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
        ),
        child: Center(
          child: Text(
            'Dueling with $friendName...',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
