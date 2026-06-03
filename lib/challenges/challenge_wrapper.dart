import 'dart:async';
import 'package:flutter/material.dart';

class ChallengeWrapper extends StatefulWidget {
  final Widget challenge;
  final Stopwatch stopwatch;

  const ChallengeWrapper({
    super.key,
    required this.challenge,
    required this.stopwatch,
  });

  @override
  State<ChallengeWrapper> createState() => _ChallengeWrapperState();
}

class _ChallengeWrapperState extends State<ChallengeWrapper> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = widget.stopwatch.elapsed;

    final seconds = elapsed.inSeconds.toString();
    final milliseconds =
        (elapsed.inMilliseconds % 1000).toString().padLeft(3, '0');

    

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
          ),

          Text(
            "$seconds.$milliseconds",
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(child: widget.challenge),
        ],
      ),
    );
  }
}
