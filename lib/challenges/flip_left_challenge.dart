import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FlipLeftChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const FlipLeftChallenge({super.key, this.onCompleted});

  @override
  State<FlipLeftChallenge> createState() => _FlipLeftChallengeState();
}

class _FlipLeftChallengeState extends State<FlipLeftChallenge> {
  bool _isCompleted = false;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = SensorsPlatform.instance
        .gyroscopeEventStream()
        .listen((GyroscopeEvent event) {
      if (!_isCompleted && event.x < -3.0) { // Threshold for flip left
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
          _isCompleted ? 'Challenge Completed!' : 'Flip your phone left',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}