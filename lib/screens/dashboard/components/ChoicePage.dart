import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ChoicePage extends StatefulWidget {
  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
        title: Text('Choose an Option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Open camera when button is pressed
                _openCamera();
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Open Camera'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                // Handle selecting from local files
                // Implement your file selection logic here
              },
              icon: Icon(Icons.folder),
              label: Text('Choose from Local Files'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    try {
      await _initializeControllerFuture;

      // Navigate to camera preview screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPreviewScreen(controller: _controller),
        ),
      );
    } catch (e) {
      print('Error opening camera: $e');
    }
  }
}

class CameraPreviewScreen extends StatelessWidget {
  final CameraController controller;

  const CameraPreviewScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Preview'),
      ),
      body: FutureBuilder<void>(
        future: controller.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the camera preview
            return CameraPreview(controller);
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
