import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import '../components/missing_ppe_alert.dart';
import '../components/detection_results.dart';
import '../services/ppe_detection_service.dart';
import '../models/detection_model.dart';


class DetectionScreen extends StatefulWidget {
  const DetectionScreen({Key? key}) : super(key: key);

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isRealtime = false;
  Timer? _realtimeTimer;

  DetectionResult? _detectionResult;
  String? _capturedImagePath;

  final PPEDetectionService _detectionService = PPEDetectionService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      _showPermissionDialog();
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      _showErrorDialog('Failed to initialize camera');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text('Please allow camera access to use this feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_isProcessing || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      final image = await _cameraController!.takePicture();
      _capturedImagePath = image.path;

      await _processImage(File(image.path));
    } catch (e) {
      debugPrint('Error taking picture: $e');
      _showErrorDialog('Failed to take picture');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      final result = await _detectionService.detectPPE(imageFile);

      setState(() {
        _detectionResult = result;
      });

      if (result.missingPpe.isNotEmpty && !_isRealtime) {
        _showMissingPPEDialog(result.missingPpe);
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
      if (!_isRealtime) {
        _showErrorDialog('Failed to process image');
      }
    }
  }

  void _showMissingPPEDialog(List<String> missingItems) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Safety Alert'),
          ],
        ),
        content: Text('Missing: ${missingItems.join(', ')}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleRealtime() {
    if (_isRealtime) {
      _stopRealtime();
    } else {
      _startRealtime();
    }
  }

  void _startRealtime() {
    setState(() {
      _isRealtime = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Realtime Detection Activated - Capturing every 2 seconds'),
        duration: Duration(seconds: 2),
      ),
    );

    _realtimeTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!_isProcessing) {
        _takePicture();
      }
    });
  }

  void _stopRealtime() {
    _realtimeTimer?.cancel();
    _realtimeTimer = null;
    setState(() {
      _isRealtime = false;
    });
  }

  void _toggleCamera() {
    if (_cameras != null && _cameras!.length > 1) {
      final currentCameraIndex = _cameras!.indexOf(_cameraController!.description);
      final newCameraIndex = (currentCameraIndex + 1) % _cameras!.length;

      _initializeCameraWithDescription(_cameras![newCameraIndex]);
    }
  }

  Future<void> _initializeCameraWithDescription(CameraDescription description) async {
    await _cameraController?.dispose();

    _cameraController = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _stopRealtime();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf1f5f9),
      appBar: AppBar(
        title: Text('PPE Detection'),
        backgroundColor: Color(0xFF1e40af),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: _toggleRealtime,
              icon: Icon(
                _isRealtime ? Icons.stop : Icons.play_arrow,
                size: 18,
              ),
              label: Text(
                _isRealtime ? 'Stop' : 'Realtime',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRealtime ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 400,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              children: [
                if (_isInitialized && _cameraController != null)
                  SizedBox.expand(
                    child: CameraPreview(_cameraController!),
                  )
                else
                  Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'Analyzing...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_isInitialized)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          mini: true,
                          onPressed: _toggleCamera,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.flip_camera_ios, color: Colors.white),
                        ),
                        FloatingActionButton(
                          onPressed: _isProcessing ? null : _takePicture,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt, color: Colors.black, size: 32),
                        ),
                        FloatingActionButton(
                          mini: true,
                          onPressed: () {},
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.flash_off, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                if (_isRealtime)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fiber_manual_record, color: Colors.white, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_detectionResult?.missingPpe.isNotEmpty == true)
                    MissingPPEAlert(items: _detectionResult!.missingPpe),
                  if (_detectionResult?.detections.isNotEmpty == true && _capturedImagePath != null)
                    DetectionResults(
                      detections: _detectionResult!.detections,
                      imagePath: _capturedImagePath!,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
