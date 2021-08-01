import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFileScreen extends StatefulWidget {
  @override
  _UploadFileScreenState createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  late File _image;
  String _message = '';
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload To FireStore')),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                child: Text('Choose Image'), onPressed: () => getImage()),
            // ignore: unnecessary_null_comparison
            // (_image == null)
            //     ? Container(height: 200)
            //     : Container(height: 200, child: Image.file(_image)),
            ElevatedButton(
                child: Text('Upload Image'), onPressed: () => uploadImage()),
            Text(_message),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      pickedFile != null
          ? _image = File(pickedFile.path)
          : print('No image selected.');
    });
  }

  Future uploadImage() async {
    // ignore: unnecessary_null_comparison
    if (_image != null) {
      String fileName = basename(_image.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref(fileName);
      setState(() => _message = 'Uploading file. Please wait...');
      ref.putFile(_image).then((TaskSnapshot result) {
        result.state == TaskState.success
            ? setState(() => _message = 'File Uploaded Successfully')
            : setState(() => _message = 'Error Uploading File');
      });
    }
  }
}
