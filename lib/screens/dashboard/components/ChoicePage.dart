import 'dart:html' show FileUploadInputElement, FileReader;
import 'dart:io' show File, Platform;

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
      // For web, use file input element to pick files
      final input = FileUploadInputElement()..accept = 'image/*';
      input.click();

      input.onChange.listen((e) {
        final files = input.files;
        if (files?.length == 1) {
          final file = files?[0];
          final reader = FileReader();

          reader.onLoadEnd.listen((e) {
            // Handle the selected image file here
            final result = reader.result;
            if (result is String) {
              // Create a blob URL for the selected file
              final blob = File([result] as String);
              Navigator.pop(context, blob);
            }
          });

          reader.readAsDataUrl(file!);
        }
      });
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
                if (!kIsWeb) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakePhotoScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Camera is not supported on web.'),
                  ));
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Take Photo'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                if (!kIsWeb) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordVideoScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Recording video is not supported on web.'),
                  ));
                }
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
