import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petkeeper/models/post.dart';
import 'package:petkeeper/providers/posts_provider.dart';
import 'package:provider/provider.dart';

class PostForm extends StatefulWidget {
  PostForm(this.postImage, this.userId, this.isEditing, this.postdata);
  bool isEditing;
  Post? postdata;
  String userId;
  XFile? postImage;
  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _firebaseStorage = FirebaseStorage.instance;
  late String postId;
  String _jobDescription = '';
  String _dates = '';
  String _title = '';
  int _salary = 0;
  int _dropdownWaterValue = 0;
  int _dropdownFeedingValue = 0;
  int _dropdownWalksValue = 0;
  int _dropdownPetValue = 0;
  TextEditingController dateinput = TextEditingController();
  final _postKey = GlobalKey<FormState>();

  void trySubmit() async {
    final isValid = _postKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid != null && isValid && widget.postImage != null) {
      _postKey.currentState?.save();
      if (widget.isEditing == false) {
        final docPath = FirebaseFirestore.instance.collection('posts').doc();
        await docPath.set({
          'petNum': _dropdownPetValue,
          'title': _title,
          'dates': _dates,
          'salary': _salary,
          'description': _jobDescription,
          'walks': _dropdownWalksValue,
          'feeding': _dropdownFeedingValue,
          'watering': _dropdownWaterValue,
          'userid': widget.userId
        }).then((value) {
          postId = docPath.id;
        });
        await _firebaseStorage
            .ref()
            .child('images/$postId')
            .putFile(File(widget.postImage!.path));
        Provider.of<PostsProvider>(context, listen: false).addPost(Post(
            petNum: _dropdownPetValue,
            postId: postId,
            userId: widget.userId,
            dates: _dates,
            title: _title,
            description: _jobDescription,
            salary: _salary,
            walks: _dropdownWalksValue,
            feeding: _dropdownFeedingValue,
            watering: _dropdownWaterValue));
      } else {
        postId = widget.postdata!.postId;
        await FirebaseFirestore.instance.collection('posts').doc(postId).set({
          'petNum': _dropdownPetValue,
          'title': _title,
          'dates': _dates,
          'salary': _salary,
          'description': _jobDescription,
          'walks': _dropdownWalksValue,
          'feeding': _dropdownFeedingValue,
          'watering': _dropdownWaterValue,
          'userid': widget.userId,
        });
        Provider.of<PostsProvider>(context, listen: false)
            .replaceImage(widget.postImage!, postId);
        Provider.of<PostsProvider>(context, listen: false).changePost(
            Post(
                petNum: _dropdownPetValue,
                postId: postId,
                userId: widget.userId,
                dates: _dates,
                title: _title,
                description: _jobDescription,
                salary: _salary,
                walks: _dropdownWalksValue,
                feeding: _dropdownFeedingValue,
                watering: _dropdownWaterValue),
            widget.postdata!.postId);
      }
      Navigator.of(context).pop();
    } else {
      print('is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing == true) {
      _jobDescription = widget.postdata!.description;
      _dates = widget.postdata!.dates;
      _title = widget.postdata!.title;
      _salary = widget.postdata!.salary;
      _dropdownWaterValue = widget.postdata!.watering;
      _dropdownFeedingValue = widget.postdata!.feeding;
      _dropdownWalksValue = widget.postdata!.walks;
      _dropdownPetValue = widget.postdata!.petNum;
      dateinput.text = widget.postdata!.dates;
    }
    return Form(
      key: _postKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _title,
            key: const ValueKey('Title'),
            validator: (value) {
              if (value == null) {
                return 'Please enter a title.';
              }
              return null;
            },
            decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
            onSaved: (value) {
              _title = value!;
            },
          ),
          const Padding(padding: EdgeInsets.all(5)),
          TextFormField(
            key: const ValueKey('Dates'),
            validator: (value) {
              if (value == null) {
                return 'Please enter Dates';
              }
              return null;
            },
            controller: dateinput,
            onTap: () async {
              DateTimeRange? pickedDate = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(3000));
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(pickedDate.start) +
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
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
            onSaved: (value) {
              _dates = value!;
            },
          ),
          const Padding(padding: EdgeInsets.all(5)),
          TextFormField(
            initialValue: _salary.toString(),
            key: const ValueKey('Salary'),
            onSaved: (value) {
              _salary = int.parse(value!);
            },
            validator: (value) {
              if (int.tryParse(value!) == null) {
                return 'Please enter only numbers.';
              }
              if (value == null) {
                return 'Please enter a salary.';
              }
              return null;
            },
            decoration: const InputDecoration(
                icon: Icon(Icons.monetization_on),
                labelText: 'Salary(USD\$)',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
            keyboardType: TextInputType.number,
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          TextFormField(
            initialValue: _jobDescription,
            key: const ValueKey('Job Description'),
            decoration: const InputDecoration(
                labelText: 'Job Description',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
            onSaved: (value) {
              _jobDescription = value!;
            },
            validator: (value) {
              if (value == null) {
                return 'Please enter a Description.';
              }
              return null;
            },
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          FormField(
            initialValue: _dropdownPetValue,
            validator: (value) {
              if (value == '0') {
                return 'Please choose a number of pets.';
              }
              return null;
            },
            builder: (FormFieldState state) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text('Number of pets',
                        style: TextStyle(
                            decorationColor: Colors.blue, fontSize: 17)),
                    const SizedBox(width: 185),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 17),
                        underline: Container(height: 2, color: Colors.blue),
                        value: _dropdownPetValue,
                        items: <int>[0, 1, 2, 3, 4, 5, 6]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _dropdownPetValue = newValue!;
                          });
                        }),
                    const SizedBox(width: 5)
                  ]));
            },
            key: const ValueKey('petNum'),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          FormField(
            initialValue: _dropdownWalksValue,
            builder: (FormFieldState state) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text('Walks(per day)',
                        style: TextStyle(
                            decorationColor: Colors.blue, fontSize: 17)),
                    const SizedBox(width: 200),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 17),
                        underline: Container(height: 2, color: Colors.blue),
                        value: _dropdownWaterValue,
                        items: <int>[0, 1, 2, 3, 4, 5, 6]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _dropdownWaterValue = newValue!;
                          });
                        }),
                    const SizedBox(width: 5)
                  ]));
            },
            key: const ValueKey('Walks'),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          FormField(
            initialValue: _dropdownFeedingValue,
            builder: (FormFieldState state) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text('Feeding(per day)',
                        style: TextStyle(
                            decorationColor: Colors.blue, fontSize: 17)),
                    const SizedBox(width: 185),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 17),
                        underline: Container(height: 2, color: Colors.blue),
                        value: _dropdownFeedingValue,
                        items: <int>[0, 1, 2, 3, 4, 5, 6]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _dropdownFeedingValue = newValue!;
                          });
                        }),
                    const SizedBox(width: 5)
                  ]));
            },
            key: const ValueKey('Feeding'),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          FormField(
            initialValue: _dropdownWaterValue,
            builder: (FormFieldState state) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text('Watering(per day)',
                        style: TextStyle(
                            decorationColor: Colors.blue, fontSize: 17)),
                    const SizedBox(width: 180),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 17),
                        underline: Container(height: 2, color: Colors.blue),
                        value: _dropdownWalksValue,
                        items: <int>[0, 1, 2, 3, 4, 5, 6]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _dropdownWalksValue = newValue!;
                          });
                        }),
                    const SizedBox(width: 5)
                  ]));
            },
            key: const ValueKey('Watering'),
          ),
          ButtonTheme(
              child: OutlinedButton.icon(
                  onPressed: trySubmit,
                  icon: const Icon(Icons.done),
                  label: const Text('Submit')))
        ],
      ),
    );
  }
}
