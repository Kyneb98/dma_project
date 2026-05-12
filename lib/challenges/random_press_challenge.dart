import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RandomPressChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const RandomPressChallenge({super.key, this.onCompleted});

  @override
  State<RandomPressChallenge> createState() => _RandomPressChallengeState();
}

class _RandomPressChallengeState extends State<RandomPressChallenge> {
  bool _isCompleted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  double _x = 0;
  double _y = 0;

  @override
  void initState() {
    super.initState();
    _generateRandomPosition();
  }

  void _generateRandomPosition() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final size = MediaQuery.of(context).size;
    final random = Random();

    // Safe zone around the center text
    const double safeWidth = 300;  
    const double safeHeight = 200;  

    double newX;
    double newY;

    do {
      newX = random.nextDouble() * (size.width - 100);
      newY = random.nextDouble() * (size.height - 200);
    } while (
      // Check if inside safe zone
      newX > (size.width / 2 - safeWidth / 2) &&
      newX < (size.width / 2 + safeWidth / 2) &&
      newY > (size.height / 2 - safeHeight / 2) &&
      newY < (size.height / 2 + safeHeight / 2)
    );

    setState(() {
      _x = newX;
      _y = newY;
    });
  });
}


  void _completeChallenge() {
    if (_isCompleted) return;

    setState(() {
      _isCompleted = true;   
    });

    _audioPlayer.play(AssetSource('sounds/complete.mp3'));
    widget.onCompleted?.call();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isCompleted ? Colors.green : Colors.white,
      body: Stack(
        children: [
          Center(
            child: Text(
              _isCompleted ? "Completed!" : "Tap the circle",
              style: TextStyle(
                fontSize: 36,
                color: _isCompleted ? Colors.white : Colors.black,
              ),
            ),
          ),

          
          if (!_isCompleted)
            Positioned(
              left: _x,
              top: _y,
              child: GestureDetector(
                onTap: _completeChallenge,
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
