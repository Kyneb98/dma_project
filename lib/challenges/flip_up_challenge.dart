import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';

class FlipUpChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const FlipUpChallenge({super.key, this.onCompleted});

  @override
  State<FlipUpChallenge> createState() => _FlipUpChallengeState();
}

class _FlipUpChallengeState extends State<FlipUpChallenge> {
  bool _isCompleted = false;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  final AudioPlayer _audioPlayer = AudioPlayer(); // 🔊 lydafspiller

  bool _bounce = false;

  @override
  void initState() {
    super.initState();

    // Start bounce animation loop
    Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      setState(() {
        _bounce = !_bounce;
      });
    });

    

    

    _gyroscopeSubscription = SensorsPlatform.instance
        .gyroscopeEventStream()
        .listen((GyroscopeEvent event) {
      if (!_isCompleted && event.x < -3.0) {
        setState(() {
          _isCompleted = true;
        });

        // 🔊 Afspil completion-lyd
        _audioPlayer.play(
          AssetSource('sounds/complete.mp3'),
        );

        widget.onCompleted?.call();

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    _audioPlayer.dispose(); // 🔊 ryd op efter lydafspiller
    super.dispose();
  }

    @override
Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: _isCompleted ? Colors.green : Colors.white,
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.only(top: _bounce ? 0 : 50),
          child: const Icon(
            Icons.arrow_upward,
            size: 150,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isCompleted ? 'Challenge Completed!' : 'FLIP!',
          style: const TextStyle(fontSize: 44),
        ),
      ],
    ),
  ),
);
  }
} 
