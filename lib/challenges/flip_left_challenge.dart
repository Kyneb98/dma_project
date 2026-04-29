import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';

class FlipLeftChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const FlipLeftChallenge({super.key, this.onCompleted});

  @override
  State<FlipLeftChallenge> createState() => _FlipLeftChallengeState();
}

class _FlipLeftChallengeState extends State<FlipLeftChallenge> {
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



    _gyroscopeSubscription = SensorsPlatform.instance
        .gyroscopeEventStream()
        .listen((GyroscopeEvent event) {
      if (!_isCompleted && event.x < -3.0) { // Threshold for flip left
        setState(() {
          _isCompleted = true;

        _audioPlayer.play(
          AssetSource('sounds/complete.mp3'),
        );



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
  margin: EdgeInsets.only(right: _bounce ? 40 : 0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.arrow_back,
        size: 150,
        color: Colors.blue,
      ),
      const SizedBox(height: 20),
      Text(
        _isCompleted ? 'Challenge Completed!' : 'FLIP!',
        style: const TextStyle(fontSize: 44),
      ),
    ],
  ),
),
      ],
    ),
  ),
);
  }
}