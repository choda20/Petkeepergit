import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/gradient_button.dart';
import '../screens/screen_args/new_post_screen_args.dart';
import '../providers/auth_provider.dart';
import '../widgets/post_form.dart';

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
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[Color(0xfffe5858), Color(0xffee9617)]))),
        title: const Text('Create a new post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                _storedImage != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5, right: 10),
                        child: Image.file(File(_storedImage!.path),
                            fit: BoxFit.cover, width: 200, height: 150),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 5, right: 10),
                        child: args.isEditing
                            ? Image.network(
                                args.postData!.downloadUrl,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 150,
                              )
                            : Image.asset(
                                'assets/A4RnHy7isSNmUEaBpbhl.jpg',
                                fit: BoxFit.cover,
                                width: 200,
                                height: 150,
                              ),
                      ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GradientButton(
                      _takePicture,
                      30,
                      180,
                      Icons.camera,
                      _storedImage == null ? 'Take an image' : 'Change image',
                      15),
                  const SizedBox(height: 10),
                  GradientButton(_choosePicture, 30, 180, Icons.folder_open,
                      "Choose an image", 15)
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
