import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FlipUpChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const FlipUpChallenge({super.key, this.onCompleted});

  @override
  State<FlipUpChallenge> createState() => _FlipUpChallengeState();
}

class _FlipUpChallengeState extends State<FlipUpChallenge> {
  bool _isCompleted = false;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = SensorsPlatform.instance
        .gyroscopeEventStream()
        .listen((GyroscopeEvent event) {
      if (!_isCompleted && event.x < -3.0) { // Threshold for flip up
        setState(() {
          _isCompleted = true;
        });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _isCompleted ? 'Challenge Completed!' : 'Flip your phone up', 
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}