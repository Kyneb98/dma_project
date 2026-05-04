import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class ShoutChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const ShoutChallenge({super.key, this.onCompleted});

  @override
  State<ShoutChallenge> createState() => _ShoutChallengeState();
}

class _ShoutChallengeState extends State<ShoutChallenge> {
  bool _isCompleted = false;
  bool _hasError = false;
  bool _isListening = false;
  double _decibel = 0.0;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late final NoiseMeter _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;

  static const double _shoutThresholdDb = 88.0;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (!mounted) return;
    if (!status.isGranted) {
      setState(() {
        _hasError = true;
      });
      return;
    }
    _startListening();
  }

  void _startListening() {
    try {
      _isListening = true;
      _noiseSubscription = _noiseMeter.noise.listen((NoiseReading reading) {
        if (!mounted) return;
        setState(() {
          _decibel = reading.meanDecibel;
          if (!_isCompleted && _decibel >= _shoutThresholdDb) {
            _isCompleted = true;
            _audioPlayer.play(AssetSource('sounds/complete.mp3'));
            widget.onCompleted?.call();
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        });
      }, onError: _onNoiseError);
    } catch (error) {
      _onNoiseError(error);
    }
  }

  void _onNoiseError(Object error) {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _isListening = false;
    });
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String readingText = _hasError
        ? 'Microphone access denied'
        : _isListening
        ? '${_decibel.toStringAsFixed(1)} dB'
        : 'Waiting for microphone permission...';

    return Scaffold(
      backgroundColor: _isCompleted ? Colors.green : Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mic,
                  size: 100,
                  color:Colors.blue,
                ),
                const SizedBox(height: 20),
                Text(
                  _isCompleted
                      ? 'Challenge Completed!'
                      : 'Shout into the microphone',
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  readingText,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                if (!_isCompleted && !_hasError)
                  const Text(
                    'Try yelling as loudly as you can! (88 dB or more)',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                if (_hasError)
                  const Text(
                    'Please allow microphone access in settings.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
