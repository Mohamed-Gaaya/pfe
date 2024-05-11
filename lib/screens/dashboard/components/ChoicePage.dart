import 'dart:html' as html;

import 'package:flutter/material.dart';

class ChoicePage extends StatelessWidget {
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
                // Navigate to screen to take a photo
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
                // Navigate to screen to record a video
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
                // Choose a file (image) from local filesystem
                _pickImageFromFilesystem(context);
              },
              icon: Icon(Icons.folder),
              label: Text('Choose from Local Files'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImageFromFilesystem(BuildContext context) {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files!.first;
      Navigator.pop(context, file); // Navigate back with selected image file
    });
  }
}

class TakePhotoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Photo'),
      ),
      body: Center(
        child: Text('Screen to take a photo'),
      ),
    );
  }
}

class RecordVideoScreen extends StatefulWidget {
  @override
  _RecordVideoScreenState createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Video'),
      ),
      body: Center(
        child: Text('Screen to record a video'),
      ),
    );
  }
}
