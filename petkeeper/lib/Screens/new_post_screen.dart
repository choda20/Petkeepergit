import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'package:petkeeper/widgets/post_form.dart';

class NewPost extends StatefulWidget {
  static const routename = '/new_post-screen';

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  XFile? _storedImage;
  Future<void> _takePicture() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 250, maxHeight: 250);
    setState(() {
      _storedImage = imageFile;
    });
  }

  Future<void> _choosePicture() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 250, maxHeight: 250);
    setState(() {
      _storedImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userId = Provider.of<AuthProvider>(context).user.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                _storedImage != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.file(File(_storedImage!.path),
                            width: 200, height: 150),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.network(
                          'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                          width: 200,
                          height: 150,
                        ),
                      ),
                Column(children: [
                  ButtonTheme(
                    child: OutlinedButton.icon(
                        onPressed: _takePicture,
                        icon: const Icon(Icons.camera),
                        label: _storedImage == null
                            ? const Text('Take an image')
                            : const Text('Change image')),
                  ),
                  ButtonTheme(
                    child: OutlinedButton.icon(
                      onPressed: _choosePicture,
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Choose an image'),
                    ),
                  )
                ]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: PostForm(_storedImage, _userId),
            )
          ],
        ),
      ),
    );
  }
}
