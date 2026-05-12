import 'package:flutter/material.dart';
import 'time_storage.dart';

class HighscoreScreen extends StatefulWidget {
  const HighscoreScreen({super.key});

  @override
  State<HighscoreScreen> createState() => _HighscoreScreenState();
}

class _HighscoreScreenState extends State<HighscoreScreen> {
  List<int> _times = [];

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  Future<void> _loadTimes() async {
    final times = await TimeStorage.loadTimes();

    setState(() {
      _times = times.take(7).toList(); // best 7
    });
  }

  String formatTime(int ms) {
    final seconds = (ms ~/ 1000).toString();
    final milliseconds = (ms % 1000).toString().padLeft(3, '0');
    return "$seconds.$milliseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Highscores")),
      body: _times.isEmpty
          ? const Center(
              child: Text(
                "No times saved yet",
                style: TextStyle(fontSize: 22),
              ),
            )
          : ListView.builder(
              itemCount: _times.length,
              itemBuilder: (context, index) {
                final time = _times[index];
                final formatted = formatTime(time);

                // ⭐ Special box for #1
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade300,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade700,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "         🥇\n #1   $formatted",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Normal centered entries for #2–#7
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      "#${index + 1}   $formatted",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
