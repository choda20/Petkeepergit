import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  static const routename = '/new_post-screen';

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController dateinput = TextEditingController();
  final _postKey = GlobalKey<FormState>();
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {},
          )
        ],
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
                        child: Image.file(
                          File(_storedImage!.path),
                          width: 200,
                          height: 150,
                        ),
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
                      icon: const Icon(Icons.camera),
                      label: const Text('Choose an image'),
                    ),
                  )
                ]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Form(
                key: _postKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                      style: const TextStyle(color: Colors.blue),
                    ),
                    TextFormField(
                      controller: dateinput,
                      onTap: () async {
                        DateTimeRange? pickedDate = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(3000));
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(pickedDate.start) +
                              ' to ' +
                              DateFormat('dd-MM-yyyy').format(pickedDate.end);
                          setState(() {
                            dateinput.text = formattedDate;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: 'Dates',
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                      style: const TextStyle(color: Colors.blue),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.monetization_on),
                          labelText: 'Salary(USD\$)',
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                      style: const TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Job Description',
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                      style: const TextStyle(color: Colors.blue),
                    ), FormField(builder: (FormFieldState state) {return InputDecoration()})
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
