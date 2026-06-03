import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';

class PhotoChallenge extends StatefulWidget {
  final VoidCallback? onCompleted;

  const PhotoChallenge({super.key, this.onCompleted});

  @override
  State<PhotoChallenge> createState() => _PhotoChallengeState();
}

class _PhotoChallengeState extends State<PhotoChallenge> {
  CameraController? _controller;
  bool _isCompleted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  XFile? _capturedImage; // store the selfie

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _takePhoto() async {
    if (_isCompleted || _controller == null || !_controller!.value.isInitialized) return;

    final picture = await _controller!.takePicture();

    setState(() {
      _capturedImage = picture;
      _isCompleted = true;
    });

    _audioPlayer.play(AssetSource('sounds/complete.mp3'));

    widget.onCompleted?.call();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Live camera preview before completion
          if (!_isCompleted &&
              _controller != null &&
              _controller!.value.isInitialized)
            Positioned.fill(child: CameraPreview(_controller!)),

          // Show captured selfie after completion
          if (_isCompleted && _capturedImage != null)
            Positioned.fill(
              child: Image.file(
                File(_capturedImage!.path),
                fit: BoxFit.cover,
              ),
            ),

          // Tap button (only before completion)
          if (!_isCompleted)
            Center(
              child: ElevatedButton(
                onPressed: _takePhoto,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(40),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  "TAP!",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            ),

          // Completed text overlay
          if (_isCompleted)
            const Center(
              child: Text(
                "Completed!",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
