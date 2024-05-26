// lib/main.dart
import 'package:flutter/material.dart';
import 'duel_page.dart';

/*
======================
  utility functions
======================
*/

int getPetLevel() {
  return 1;
}

/* 
======================
  Dummy Database query
======================
*/

List<Map> getFriendList() {
  return [
    {'id': 1, 'name': 'Alice', 'pet': 'cat'},
    {'id': 2, 'name': 'Bob', 'pet': 'dog'},
    {'id': 3, 'name': 'Charlie', 'pet': 'bird'},
    {'id': 4, 'name': 'David', 'pet': 'dolphin'},
    {'id': 5, 'name': 'Eve', 'pet': 'snake'},
    {'id': 6, 'name': 'Frank', 'pet': 'turtle'},
    {'id': 7, 'name': 'Grace', 'pet': 'unicorn'},
    {'id': 8, 'name': 'Hank', 'pet': 'dragon'},
  ];
}

List<String> getPetList() {
  return ['cat', 'dog', 'bird', 'dolphin', 'snake', 'turtle', 'unicorn', 'dragon'];
}

/*
======================
  User Data
======================
*/

int petLevel = getPetLevel();
String? selectedPet;
bool hasSelectedPet = false;

// Flutter code snippet
class PetPage extends StatefulWidget {
  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPetSelectionDialog(context));
  }

  void _showPetSelectionDialog(BuildContext context) {
    if (!hasSelectedPet) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pick Your First Pet'),
            content: SingleChildScrollView(
              child: Column(
                children: getPetList().map((pet) {
                  return ListTile(
                    title: Text(pet),
                    onTap: () {
                      setState(() {
                        selectedPet = pet;
                        petLevel = 1;
                        hasSelectedPet = true;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    }
  }

  void _showFriendSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose a Friend to Duel'),
          content: SingleChildScrollView(
            child: Column(
              children: getFriendList().map((friend) {
                return ListTile(
                  title: Text(friend['name']),
                  onTap: () {
                    Navigator.of(context).pop();
                    _startDuel(friend['name']);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _startDuel(String friendName) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DuelPage(friendName: friendName),
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
      _showDuelResult(friendName);
    });
  }

  void _showDuelResult(String friendName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool win = (petLevel % 2 == 0);  // 假設：等級是偶數則勝利，否則失敗
        return AlertDialog(
          title: Text('Duel Result'),
          content: Text(win ? 'You won against $friendName!' : 'You lost to $friendName.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Raise Your Pet',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 105, 180),
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: const Color.fromARGB(255, 64, 255, 64),
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.pink[100],
      ),
      body: Container(
        // Background Image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/raise-background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Level Text
              Text(
                'Level: $petLevel',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              
              // Pet Image
              Center(
                child: selectedPet != null
                    ? Image.asset(
                        'assets/${selectedPet!.toLowerCase()}.jpg',
                        width: 300,
                        height: 300,
                      )
                    : SizedBox.shrink(),
              ),
              
              // Duel Button
              ElevatedButton(
                onPressed: () {
                  _showFriendSelectionDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize: Size(150, 50),
                ),
                child: Text('Duel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
