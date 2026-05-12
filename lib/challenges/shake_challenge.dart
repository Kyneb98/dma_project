import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';

class ShakeChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const ShakeChallenge({super.key, this.onCompleted});

  @override
  State<ShakeChallenge> createState() => _ShakeChallengeState();
}

class _ShakeChallengeState extends State<ShakeChallenge> {
  bool _isCompleted = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // NEW VARIABLES
  double _lastMagnitude = 0;
  int _shakeScore = 0;

  @override
  void initState() {
    super.initState();

    _accelerometerSubscription = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((AccelerometerEvent event) {
      // Calculate magnitude of acceleration
      double magnitude = sqrt(
        event.x * event.x +
        event.y * event.y +
        event.z * event.z,
      );

      // Calculate change in movement (delta)
      double delta = (magnitude - _lastMagnitude).abs();
      _lastMagnitude = magnitude;

      // Count only strong back-and-forth movements
      if (delta > 8.0) {
        _shakeScore++;
      }

      // Require multiple shake motions
      if (!_isCompleted && _shakeScore > 6) {
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
    _accelerometerSubscription?.cancel();
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
            Icon(
              Icons.vibration,
              size: 150,
              color: _isCompleted ? Colors.white : Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              _isCompleted ? 'Completed!' : 'Shake your phone',
              style: TextStyle(
                fontSize: 36,
                color: _isCompleted ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
