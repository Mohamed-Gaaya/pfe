import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
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

class RecordVideoScreen extends StatelessWidget {
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
