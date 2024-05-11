import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _videoPath; // Path to save the recorded video
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller
    _controller = CameraController(
      CameraDescription(
        name: '0',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ),
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();

    // Set up video path
    _videoPath = '';
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the camera preview
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          _isRecording ? Icons.stop : Icons.videocam,
        ),
        onPressed: () {
          _isRecording ? _stopRecording() : _startRecording();
        },
      ),
    );
  }

  Future<String> _getVideoFilePath() async {
    final directory = await getTemporaryDirectory();
    return path.join(directory.path, '${DateTime.now()}.mp4');
  }

  void _startRecording() async {
    try {
      // Get video file path
      _videoPath = await _getVideoFilePath();

      // Start video recording
      await _controller.startVideoRecording();

      // Update recording state
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  void _stopRecording() async {
    if (_controller.value.isRecordingVideo) {
      try {
        // Stop video recording
        await _controller.stopVideoRecording();

        // Save the recorded video to the specified path
        // This step can be performed after stopping the recording
        // using the `_videoPath` obtained during `_startRecording()`
        print('Video recorded and saved to: $_videoPath');

        // Navigate back to previous screen or perform other actions
        Navigator.pop(context, _videoPath);
      } catch (e) {
        print('Error stopping video recording: $e');
      } finally {
        // Reset recording state
        setState(() {
          _isRecording = false;
        });
      }
    }
  }
}
