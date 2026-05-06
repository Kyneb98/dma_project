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

  final AudioPlayer _audioPlayer = AudioPlayer(); // 🔊 lydafspiller

  @override
  void initState() {
    super.initState();

   /* // 🔊 Afspil start-lyd
    _audioPlayer.play(
      AssetSource('sounds/shake_start.mp3'),
    );*/

    _accelerometerSubscription = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((AccelerometerEvent event) {
      // Calculate the magnitude of acceleration
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (!_isCompleted && magnitude > 15.0) { // Threshold for shake detection
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
  _accelerometerSubscription?.cancel();
  _audioPlayer.dispose(); // ryd op efter lydafspiller
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isCompleted ? Colors.green : Colors.white,
      body: Center(
        child: Text(
          _isCompleted ? 'Challenge Completed!' : 'Shake your phone',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
