// lib/features/attendance/presentation/screens/face_detection_screen.dart
import 'package:camera/camera.dart';
import 'package:dio/dio.dart'; // YE IMPORT ADD KARNA HAI
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';

class FaceDetectionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final VoidCallback onSuccess;

  const FaceDetectionScreen({
    required this.cameras,
    required this.onSuccess,
    super.key,
  });

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen>
    with TickerProviderStateMixin {
  late CameraController _controller;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isDetecting = false;
  int _blinkCount = 0;
  bool _isBlinking = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[1], ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.startImageStream(_processCameraImage);
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting || _blinkCount >= 3) return;
    _isDetecting = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isDetecting = false;
      return;
    }

    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      final face = faces.first;

      if (face.headEulerAngleY != null && (face.headEulerAngleY!.abs() > 20)) {
        _showInstruction("Keep head straight");
        _isDetecting = false;
        return;
      }

      final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
      final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

      if (leftEyeOpen < 0.3 && rightEyeOpen < 0.3 && !_isBlinking) {
        _isBlinking = true;
      } else if (leftEyeOpen > 0.7 && rightEyeOpen > 0.7 && _isBlinking) {
        _blinkCount++;
        _isBlinking = false;
        setState(() {});

        if (_blinkCount >= 3) {
          _captureAndUpload();
        }
      }
    }

    _isDetecting = false;
  }

  Future<void> _captureAndUpload() async {
    try {
      final image = await _controller.takePicture();

      final response = await Dio().post(
        'http://10.0.2.2:5000/api/attendance/checkin', // ← Apna backend URL daal
        data: FormData.fromMap({
          'image': await MultipartFile.fromFile(
            image.path,
            filename: 'face.jpg',
          ),
          'type': 'face',
        }),
      );

      if (response.statusCode == 200) {
        widget.onSuccess();
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check-in Successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload Failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInstruction(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation90deg,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_controller),
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, child) => Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _blinkCount >= 3 ? Colors.green : Colors.white,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              _blinkCount >= 3 ? 'Verified!' : 'Blink $_blinkCount/3 times',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    _pulseController.dispose();
    super.dispose();
  }
}
