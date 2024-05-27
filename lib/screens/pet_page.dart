import 'package:flutter/material.dart';

import 'duel_page.dart';

/*
======================
  Utility functions
======================
*/

int calculatePetLevel({
  required double savingsRate,
  required double expenseRate,
  required double investmentReturnRate,
  required double debtRate,
  required double goalCompletionRate,
}) {
  /*
  1. Monthly Savings Rate: 
    The proportion of savings to income. This variable indicates the user's saving ability.
  
  2. Expense Control Rate: 
    The ratio of monthly expenses to income. This variable shows the user's ability to control spending.
  
  3. Investment Return Rate:
    The proportion of investment returns to the total amount invested. This variable indicates the user's investment capability.
  
  4. Debt Ratio:
    The proportion of debt to income. This variable shows the user's debt management ability.
  
  5. Financial Goal Completion Rate:
    The progress towards achieving set financial goals.
  */

  // Weights for each factor
  double savingsWeight = 0.3;
  double expenseWeight = 0.2;
  double investmentWeight = 0.25;
  double debtWeight = 0.15;
  double goalCompletionWeight = 0.1;

  // Calculate the level score
  double levelScore = (savingsRate * savingsWeight) +
                      ((1 - expenseRate) * expenseWeight) +
                      (investmentReturnRate * investmentWeight) +
                      ((1 - debtRate) * debtWeight) +
                      (goalCompletionRate * goalCompletionWeight);

  // Level 1 ~ 100
  int petLevel = (levelScore * 100).toInt().clamp(1, 100);
  
  return petLevel;
}

/*
======================
  Dummy Database Query
======================
*/

List<Map<String, dynamic>> getFriendList() {
  return [
    {
      'id': 1,
      'name': 'Alice',
      'pet': 'cat',
      'level': calculatePetLevel(
        savingsRate: 0.3,
        expenseRate: 0.9,
        investmentReturnRate: 0.6,
        debtRate: 0.9,
        goalCompletionRate: 0.2
      ),
    },
    {
      'id': 2,
      'name': 'Bob',
      'pet': 'dog',
      'level': calculatePetLevel(
        savingsRate: 0.5,
        expenseRate: 0.5,
        investmentReturnRate: 0.6,
        debtRate: 0.4,
        goalCompletionRate: 0.7
      ),
    },
    {
      'id': 3,
      'name': 'Charlie',
      'pet': 'bird',
      'level': calculatePetLevel(
        savingsRate: 0.3,
        expenseRate: 0.1,
        investmentReturnRate: 0.1,
        debtRate: 0.2,
        goalCompletionRate: 0.1
      ),
    },
    {
      'id': 4,
      'name': 'David',
      'pet': 'dolphin',
      'level': calculatePetLevel(
        savingsRate: 0.5,
        expenseRate: 0.5,
        investmentReturnRate: 0.5,
        debtRate: 0.5,
        goalCompletionRate: 0.5
      ),
    },
    {
      'id': 5,
      'name': 'Eve',
      'pet': 'snake',
      'level': calculatePetLevel(
        savingsRate: 0.6,
        expenseRate: 0.4,
        investmentReturnRate: 0.6,
        debtRate: 0.3,
        goalCompletionRate: 0.7
      ),
    },
    {
      'id': 6,
      'name': 'Frank',
      'pet': 'turtle',
      'level': calculatePetLevel(
        savingsRate: 0.5,
        expenseRate: 0.5,
        investmentReturnRate: 0.5,
        debtRate: 0.4,
        goalCompletionRate: 0.6
      ),
    },
    {
      'id': 7,
      'name': 'Grace',
      'pet': 'unicorn',
      'level': calculatePetLevel(
        savingsRate: 0.8,
        expenseRate: 0.2,
        investmentReturnRate: 0.9,
        debtRate: 0.1,
        goalCompletionRate: 1.0
      ),
    },
    {
      'id': 8,
      'name': 'Hank',
      'pet': 'dragon',
      'level': calculatePetLevel(
        savingsRate: 0.7,
        expenseRate: 0.3,
        investmentReturnRate: 0.8,
        debtRate: 0.2,
        goalCompletionRate: 0.9
      ),
    },
  ];
}


List<String> getPetList() {
  return ['cat', 'dog', 'bird', 'dolphin', 'snake', 'turtle', 'unicorn', 'dragon'];
}

/*
======================
  Dummy User Data
======================
*/

String? selectedPet;
bool hasSelectedPet = false;
double savingsRate = 0.5;
double expenseRate = 0.5;
double investmentReturnRate = 0.5;
double debtRate = 0.5;
double goalCompletionRate = 0.5;

/*
======================
  Flutter code snippet
======================
*/

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
                    _startDuel(friend);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _startDuel(Map<String, dynamic> friend) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DuelPage(
          friendName: friend['name'],
          userPet: selectedPet!,
          friendPet: friend['pet'],
          ),
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.of(context).pop();
      _showDuelResult(friend);
    });
  }

  void _showDuelResult(Map<String, dynamic> friend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool win = (calculatePetLevel(
          savingsRate: savingsRate,
          expenseRate: expenseRate,
          investmentReturnRate: investmentReturnRate,
          debtRate: debtRate,
          goalCompletionRate: goalCompletionRate
        ) >= friend['level']);
        return AlertDialog(
          title: Text('Duel Result'),
          content: Text(
            win ? 'You won against ${friend['name']}! with ${friend['level']} ${friend['pet']} level.' :
            'You lost to ${friend['name']} with ${friend['level']} ${friend['pet']} level.'),
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
    int petLevel = calculatePetLevel(
      savingsRate: savingsRate,
      expenseRate: expenseRate,
      investmentReturnRate: investmentReturnRate,
      debtRate: debtRate,
      goalCompletionRate: goalCompletionRate
    );
    
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
