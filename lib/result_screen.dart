import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final Duration totalTime;

  const ResultsScreen({super.key, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    final seconds = totalTime.inSeconds.toString();
    final milliseconds =
        (totalTime.inMilliseconds % 1000).toString().padLeft(3, '0');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Final Time",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "$seconds.$milliseconds",
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
