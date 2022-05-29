import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/gradient_icons.dart';
import '../models/post.dart';
import '../widgets/gradient_button.dart';
import '../providers/posts_provider.dart';

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
  String _postId = '';
  String _jobDescription = '';
  String _startingDate = '';
  String _endinggDate = '';
  String _title = '';
  int _salary = 0;
  int _dropdownWaterValue = 0;
  int _dropdownFeedingValue = 0;
  int _dropdownWalksValue = 0;
  int _dropdownPetValue = 1;
  TextEditingController _startingDateController = TextEditingController();
  TextEditingController _endingDateController = TextEditingController();
  final _postKey = GlobalKey<FormState>();

  void trySubmit() async {
    bool? isValid = _postKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    _postKey.currentState?.save();
    DateTime startingDate = DateTime.parse('2020-01-01');
    DateTime endingDate = DateTime.parse('2021-01-01');
    bool hasDates = true;
    if (_startingDate == '' || _endinggDate == '' || _dropdownPetValue == 0) {
      isValid = false;
      hasDates = false;
    }
    if (_startingDate != '' && _endinggDate != '') {
      startingDate = DateTime.parse(_startingDate);
      endingDate = DateTime.parse(_endinggDate);
    }
    bool? newImage = null;

    if (widget.isEditing) {
      if (widget.postImage == null) {
        newImage = false;
      } else {
        newImage = true;
      }
    }

    try {
      if (isValid != null &&
              isValid &&
              widget.postImage != null &&
              startingDate.isBefore(endingDate) ||
          isValid != null &&
              isValid &&
              newImage == false &&
              startingDate.isBefore(endingDate)) {
        if (widget.isEditing == false) {
          Provider.of<PostsProvider>(context, listen: false).addPost(
              Post(
                  downloadUrl: '',
                  petNum: _dropdownPetValue,
                  postId: _postId,
                  userId: widget.userId,
                  startingDate: _startingDate,
                  endingDate: _endinggDate,
                  title: _title,
                  description: _jobDescription,
                  salary: _salary,
                  walks: _dropdownWalksValue,
                  feeding: _dropdownFeedingValue,
                  watering: _dropdownWaterValue),
              widget.postImage!);
        } else {
          _postId = widget.postdata!.postId;
          String downloadUrl = widget.postdata!.downloadUrl;
          if (newImage == true) {
            Provider.of<PostsProvider>(context, listen: false)
                .replaceImage(widget.postImage!, _postId);
          }
          Provider.of<PostsProvider>(context, listen: false).changePost(
              Post(
                  downloadUrl: downloadUrl,
                  petNum: _dropdownPetValue,
                  postId: _postId,
                  userId: widget.userId,
                  startingDate: _startingDate,
                  endingDate: _endinggDate,
                  title: _title,
                  description: _jobDescription,
                  salary: _salary,
                  walks: _dropdownWalksValue,
                  feeding: _dropdownFeedingValue,
                  watering: _dropdownWaterValue),
              widget.postdata!.postId);
        }
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e.toString());
    }

    if (!startingDate.isBefore(endingDate) && hasDates) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Starting date is after ending date.'),
          backgroundColor: Colors.red));
    } else if (widget.postImage == null && widget.isEditing == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please choose an Image'),
          backgroundColor: Colors.red));
    } else if (_dropdownPetValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please choose a number of pets'),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextFormField DatePicker(int indicator) {
      return TextFormField(
        key: indicator == 0
            ? const ValueKey('Starting Date')
            : const ValueKey('Ending Date'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a date';
          }
          return null;
        },
        controller:
            indicator == 0 ? _startingDateController : _endingDateController,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              initialDate: indicator == 0
                  ? DateTime.now()
                  : DateTime.parse(_startingDateController.text),
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(3000));
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              indicator == 0
                  ? _startingDateController.text = formattedDate
                  : _endingDateController.text = formattedDate;
            });
          }
        },
        decoration: InputDecoration(
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffee9617))),
            icon: RadiantGradientMask(
                child: const Icon(Icons.calendar_month, color: Colors.white)),
            labelText: indicator == 0 ? 'Starting date' : 'Ending date',
            labelStyle: const TextStyle(color: Colors.black),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffee9617)))),
        style: const TextStyle(color: Colors.black),
        onSaved: (value) {
          indicator == 0 ? _startingDate = value! : _endinggDate = value!;
        },
        keyboardType: TextInputType.none,
      );
    }

    if (widget.isEditing == true) {
      _jobDescription = widget.postdata!.description;
      _startingDate = widget.postdata!.startingDate;
      _endinggDate = widget.postdata!.endingDate;
      _title = widget.postdata!.title;
      _salary = widget.postdata!.salary;
      _dropdownWaterValue = widget.postdata!.watering;
      _dropdownFeedingValue = widget.postdata!.feeding;
      _dropdownWalksValue = widget.postdata!.walks;
      _dropdownPetValue = widget.postdata!.petNum;
      _startingDateController.text = widget.postdata!.startingDate;
      _endingDateController.text = widget.postdata!.endingDate;
    }
    return Form(
      key: _postKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _title,
            key: const ValueKey('Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title.';
              }
              if (value.length > 19) {
                return 'A title\'s length cannot be longer then 19 characters.';
              }
              return null;
            },
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffee9617))),
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffee9617)))),
            style: const TextStyle(color: Colors.black),
            onSaved: (value) {
              _title = value!;
            },
          ),
          const SizedBox(height: 6),
          DatePicker(0),
          const SizedBox(height: 6),
          _startingDateController.text == '' ? SizedBox() : DatePicker(1),
          const SizedBox(height: 6),
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
              if (value == null || value.isEmpty) {
                return 'Please enter a salary.';
              }
              if (int.tryParse(value)! <= 0) {
                return 'Please enter a number greater then 0';
              }
              return null;
            },
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffee9617))),
                icon: RadiantGradientMask(
                    child:
                        const Icon(Icons.monetization_on, color: Colors.white)),
                labelText: 'Salary(\$)',
                labelStyle: const TextStyle(color: Colors.black),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffee9617)))),
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: null,
            initialValue: _jobDescription,
            key: const ValueKey('Job Description'),
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffee9617))),
                labelText: 'Job Description',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffee9617)))),
            style: const TextStyle(color: Colors.black),
            onSaved: (value) {
              _jobDescription = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a Description.';
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          FormField(
            initialValue: _dropdownPetValue,
            validator: (value) {
              if (value == 0) {
                return 'Please choose a number of pets.';
              }
              return null;
            },
            builder: (FormFieldState state) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      RadiantGradientMask(
                        child: const Icon(
                          Icons.pets,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Text('Number of pets',
                          style: TextStyle(
                              decorationColor: Color(0xffee9617),
                              fontSize: 17)),
                    ]),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                        underline: Container(
                            height: 2, color: const Color(0xffee9617)),
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
                  ]);
            },
            key: const ValueKey('petNum'),
          ),
          const SizedBox(height: 6),
          FormField(
            initialValue: _dropdownWalksValue,
            builder: (FormFieldState state) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      RadiantGradientMask(
                        child: const Icon(
                          Icons.directions_walk_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Text('Walks(per day)',
                          style: TextStyle(
                              decorationColor: Color(0xffee9617),
                              fontSize: 17)),
                    ]),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                        underline:
                            Container(height: 2, color: Color(0xffee9617)),
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
                  ]);
            },
            key: const ValueKey('Walks'),
          ),
          const SizedBox(height: 6),
          FormField(
            initialValue: _dropdownFeedingValue,
            builder: (FormFieldState state) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      RadiantGradientMask(
                        child: const Icon(
                          Icons.food_bank,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Text('Feeding(per day)',
                          style: TextStyle(
                              decorationColor: Color(0xffee9617),
                              fontSize: 17)),
                    ]),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                        underline:
                            Container(height: 2, color: Color(0xffee9617)),
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
                  ]);
            },
            key: const ValueKey('Feeding'),
          ),
          const SizedBox(height: 6),
          FormField(
            initialValue: _dropdownWaterValue,
            builder: (FormFieldState state) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      RadiantGradientMask(
                          child: const Icon(
                        Icons.water_drop,
                        size: 20,
                        color: Colors.white,
                      )),
                      const Text('Watering(per day)',
                          style: TextStyle(
                              decorationColor: Color(0xffee9617),
                              fontSize: 17)),
                    ]),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                        underline:
                            Container(height: 2, color: Color(0xffee9617)),
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
                  ]);
            },
            key: const ValueKey('Watering'),
          ),
          const SizedBox(height: 20),
          GradientButton(trySubmit, 40, 130, Icons.done, "Submit", 20),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
