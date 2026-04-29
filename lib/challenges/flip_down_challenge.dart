import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';

class FlipDownChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const FlipDownChallenge({super.key, this.onCompleted});

  @override
  State<FlipDownChallenge> createState() => _FlipDownChallengeState();
}

class _FlipDownChallengeState extends State<FlipDownChallenge> {
  bool _isCompleted = false;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // 🔽 Animation state
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

    // Play start sound
    _audioPlayer.play(
      AssetSource('sounds/flip_down_start.mp3'),
    );

    _gyroscopeSubscription = SensorsPlatform.instance
        .gyroscopeEventStream()
        .listen((GyroscopeEvent event) {
      if (!_isCompleted && event.x > 3.0) {
        setState(() {
          _isCompleted = true;
        });

        _audioPlayer.play(
          AssetSource('sounds/complete.mp3'),
        );

        widget.onCompleted?.call();

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    _audioPlayer.dispose();
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
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(top: _bounce ? 18 : 0),
          child: const Icon(
            Icons.arrow_downward,
            size: 100,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isCompleted ? 'Challenge Completed!' : 'Flip your phone down',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    ),
  ),
);
  }
} 