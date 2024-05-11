import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';

class ChoicePage extends StatelessWidget {
  Future<void> _pickImage(BuildContext context) async {
    if (!kIsWeb) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Handle the selected image file here
        Navigator.pop(context, File(pickedFile.path));
      } else {
        print('Image selection canceled.');
      }
    } else {
      // For web, show a custom file picker dialog
      final input = await FilePicker.platform.pickFiles(type: FileType.image);

      if (input != null && input.files.isNotEmpty) {
        final file = File(input.files.single.path!);
        Navigator.pop(context, file);
      } else {
        print('Image selection canceled.');
      }
    }
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePhotoScreen(),
                  ),
                );
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Take Photo'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordVideoScreen(),
                  ),
                );
              },
              icon: Icon(Icons.videocam),
              label: Text('Record Video'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                _pickImage(context);
              },
              icon: Icon(Icons.folder),
              label: Text('Choose from Local Files'),
            ),
          ],
        ),
      ),
    );
  }
}

class TakePhotoScreen extends StatefulWidget {
  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Take Photo'),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;

              // Take the picture and get the XFile object representing the saved image
              final XFile? imageFile = await _controller.takePicture();

              if (imageFile != null) {
                // Image capture was successful, handle the image file here
                print('Image captured: ${imageFile.path}');

                // Pass the image file path back to the previous screen
                Navigator.pop(context, imageFile.path);
              } else {
                print('Error: No image captured');
              }
            } catch (e) {
              print('Error taking photo: $e');
            }
          },
          child: Icon(Icons.camera),
        ));
  }
}

class RecordVideoScreen extends StatefulWidget {
  @override
  _RecordVideoScreenState createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> {
  late CameraController _controller;
  late FlutterFFmpeg _flutterFFmpeg;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      CameraDescription(
        name: '0',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ),
      ResolutionPreset.medium,
    );

    _flutterFFmpeg = FlutterFFmpeg(); // Initialize FlutterFFmpeg instance

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Video'),
      ),
      body: _controller.value.isInitialized
          ? CameraPreview(_controller)
          : CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_controller.value.isRecordingVideo) {
            final path = 'path_to_save_video.mp4';
            await _controller.startVideoRecording();
          } else {
            final XFile? videoFile = await _controller.stopVideoRecording();
            if (videoFile != null) {
              // Process the recorded video using FlutterFFmpeg if needed
              await _flutterFFmpeg.execute('-i ${videoFile.path} output.mp4');

              // Pass the video file path back to the previous screen
              Navigator.pop(context, videoFile.path);
            }
          }
        },
        child: Icon(
          _controller.value.isRecordingVideo ? Icons.stop : Icons.videocam,
        ),
      ),
    );
  }
}
