import 'dart:math';

// importer challenges nedenfor
import 'package:dma_project/challenges/shake_challenge.dart';
import 'package:flutter/material.dart';

import 'challenges/random_press_challenge.dart';
import 'challenges/shout_challenge.dart';
import 'challenges/punch_challenge.dart';
import 'challenges/flip_up_challenge.dart';
import 'challenges/flip_down_challenge.dart';
import 'challenges/flip_left_challenge.dart';
import 'challenges/flip_right_challenge.dart';
import 'challenges/shake_challenge.dart';




typedef Challenge = Future<void> Function();

//en liste over alle challenges, som kan bruges til af vælge en random challenge fra
final List<Challenge> challenges = [
  
  // Tilføj flere her
];

// Random generator
final Random _rand = Random();

// Funktion der returnerer en tilfældig challenge fra challengelisten
Challenge getRandomChallenge() {
  return challenges[_rand.nextInt(challenges.length)];
}

// sekvensen som kører de 7 challenges
Future<void> runChallengeSequence(BuildContext context) async {
  final List<Widget> challengeWidgets = [
    const FlipDownChallenge(),
   
    
    // ... etc
  ];
  for (int i = 0; i < 7; i++) {
    final challenge = challengeWidgets[_rand.nextInt(challengeWidgets.length)];
    print("Starter challenge ${i + 1}");
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => challenge));
    print("Challenge ${i + 1} færdig");
  }

  print("Alle 7 challenges gennemført!");
}
