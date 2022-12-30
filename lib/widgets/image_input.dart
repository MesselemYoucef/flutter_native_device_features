import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  Future<void> takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      if(imageFile != null){
        _storedImage = File(imageFile.path) ;
      }
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    if(imageFile != null){
     final fileName = path.basename(imageFile.path);
      final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  "No Image Available",
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            label: const Text('Take Picture'),
            icon: const Icon(Icons.camera),
            onPressed: takePicture,
          ),
        ),
      ],
    );
  }
}
