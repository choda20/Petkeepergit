import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  static const routename = '/new_post-screen';

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  XFile? _storedImage;
  Future<void> _takePicture() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 220, maxHeight: 250);
    setState(() {
      _storedImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {},
          )
        ],
        title: Text('Create a new post'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                child: Column(children: [
                  _storedImage != null
                      ? Image.file(File(_storedImage!.path))
                      : Image.network(
                          'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                          height: 250,
                          width: 220,
                        ),
                  ButtonTheme(
                    minWidth: 500,
                    height: 50,
                    child: OutlinedButton.icon(
                        onPressed: _takePicture,
                        icon: Icon(Icons.camera),
                        label: Text('Change picture')),
                  )
                ]),
              ),
              Column(
                children: [],
              )
            ],
          ),
        ],
      ),
    );
  }
}
