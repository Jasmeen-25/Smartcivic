
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'location_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;

  bool isInitialized = false;
  bool isCapturing = false;
  String? cameraError;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No camera found on this device.');
      }

      final selectedCamera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _controller = controller;

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        isInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cameraError = e.toString();
      });
    }
  }

  Future<void> captureGarbage() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        isCapturing) {
      return;
    }

    setState(() {
      isCapturing = true;
    });

    try {
      final XFile photo =
          await _controller!.takePicture();

      final Uint8List imageBytes =
          await photo.readAsBytes();

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationScreen(
            imageBytes: imageBytes,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCapturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F3),

      appBar: AppBar(
        title: const Text(
          'Report Garbage',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Expanded(
            child: Center(
              child: cameraError != null
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        cameraError!,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : !isInitialized
                      ? const CircularProgressIndicator(
                          color: Colors.green,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CameraPreview(_controller!),
                        ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed:
                    isInitialized && !isCapturing
                        ? captureGarbage
                        : null,

                icon: const Icon(Icons.camera_alt),

                label: Text(
                  isCapturing
                      ? 'Capturing...'
                      : 'Capture Garbage',
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
