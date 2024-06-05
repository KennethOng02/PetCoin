import 'package:flutter/material.dart';

class DuelPage extends StatefulWidget {
  final String friendName;
  final String userPet;
  final String friendPet;

  DuelPage(
      {required this.friendName,
      required this.userPet,
      required this.friendPet});

  @override
  // ignore: library_private_types_in_public_api
  _DuelPageState createState() => _DuelPageState();
}

class _DuelPageState extends State<DuelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    _controller.forward().whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/duel-background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 200,
              child: Transform.scale(
                scale: 1.3,
                child: Image.asset(
                  'assets/${widget.userPet.toLowerCase()}.jpg',
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 200,
              child: Transform.scale(
                scale: 1.3,
                child: Image.asset(
                  'assets/${widget.friendPet.toLowerCase()}.jpg',
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                value: _controller.value,
                backgroundColor: Colors.white,
                color: Colors.blueAccent,
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
