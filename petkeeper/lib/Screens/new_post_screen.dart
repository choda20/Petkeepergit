import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:petkeeper/widgets/widget_args/new_post_screen_args.dart';
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
    final args =
        ModalRoute.of(context)!.settings.arguments as NewPostScreenArgs;
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
                          'https://firebasestorage.googleapis.com/v0/b/petkeeper-7a537.appspot.com/o/empty.jpg?alt=media&token=a653f578-0fff-4ef1-ab35-40fbd355c534',
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
              child: PostForm(
                  _storedImage, _userId, args.isEditing, args.postData),
            )
          ],
        ),
      ),
    );
  }
}
