import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petkeeper/models/user.dart';
import 'package:petkeeper/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../screens/screen_args/edit_user_screen_args.dart';
import '../widgets/gradient_button.dart';

class EditUserScreen extends StatefulWidget {
  static const routename = '/edit-user-screen';
  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phonenumberController = TextEditingController();
  String _username = '';
  String _email = '';
  String _phonenumber = '';
  XFile? _storedImage;
  bool isInit = true;

  // טענת כניסה: אין
  // טענת יציאה: הפעולה מאפשרת למשתמש לבחור תמונה מהגלריה של מכשירו
  // _storedImage ומאחסנת אותה במשתנה
  Future<void> _choosePicture() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 250, maxHeight: 250);
    setState(() {
      _storedImage = imageFile!;
    });
  }

  // טענת כניסה: הפעולה מקבלת מחרוזת
  // טענת יציאה: הפעולה מחזירה "אמת" אם המחרוזת היא מספר שלם ו"שקר" אם לא
  bool isNumeric(String num) {
    return int.tryParse(num) != null;
  }

  // טענת כניסה: אין
  // .טענת יציאה: הפעולה בודקת האם מספר הטלפון שהזין המשתמש תקין
  // אם מספר הטלפון תקין תחזיר הפעולה "ריק" ואם לא תחזיר הפעולה מחרוזת המכילה הסבר לכך
  String? _phoneError() {
    final text = _phonenumberController.text;
    if (!isNumeric(text) || text.isEmpty) {
      return 'Please enter a valid number';
    }
    if (text.trim().length > 11) {
      return 'a number\'s maximum length is 11 characters';
    }
    return null;
  }

  // טענת כניסה: אין
  // .טענת יציאה: הפעולה בודקת האם המייל שהזין המשתמש תקין
  // אם המייל תקין תחזיר הפעולה "ריק" ואם לא תחזיר הפעולה מחרוזת המכילה הסבר לכך
  String? _emailError() {
    final text = _emailController.text;
    if (text.isEmpty || !text.contains('@')) {
      return 'Please enter an email adress';
    }
    if (text.trim().length > 33) {
      return 'An emails maximun length is 33 characteres';
    }
    return null;
  }

  // טענת כניסה: אין
  //.טענת יציאה: הפעולה בודקת האם שם המשתמש שהזין המשתמש תקין
  // אם שם המשתמש תקין תחזיר הפעולה "ריק" ואם לא תחזיר הפעולה מחרוזת המכילה הסבר לכך
  String? _usernameError() {
    final text = _usernameController.text;
    if (text.trim().length > 22) {
      return 'a usernames maximun length is 22 characters';
    }
    if (text.isEmpty) {
      return 'Please enter a username.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EditUserScreenArgs;
    final defaultImage = NetworkImage(args.userData.downloadurl);
    final userProvider = Provider.of<UserProvider>(context);
    if (isInit) {
      _usernameController.text = args.userData.userName;
      _emailController.text = args.userData.email;
      _phonenumberController.text = args.userData.phoneNumber;
      _username = args.userData.userName;
      _email = args.userData.email;
      _phonenumber = args.userData.phoneNumber;
      isInit = false;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text("Edit your information"),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xfffe5858), Color(0xffee9617)])))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            const SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                child: GestureDetector(onTap: _choosePicture),
                radius: 100,
                backgroundImage: _storedImage == null
                    ? defaultImage
                    : Image.file(File(_storedImage!.path)).image,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 450,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Username: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 225,
                      child: TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: _usernameController,
                        decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffee9617))),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffee9617))),
                            errorText: _usernameError()),
                        onChanged: (text) {
                          if (_usernameError() == null) {
                            setState(() {
                              _username = text.trim();
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 450,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Email: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 225,
                      child: TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: _emailController,
                        decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffee9617))),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffee9617))),
                            errorText: _emailError()),
                        onChanged: (text) {
                          if (_emailError() == null) {
                            setState(() {
                              _email = text.trim();
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 450,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Phone number: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 225,
                      child: TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: _phonenumberController,
                        decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffee9617))),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffee9617))),
                            errorText: _phoneError()),
                        onChanged: (text) {
                          if (_phoneError() == null) {
                            setState(() {
                              _phonenumber = text.trim();
                            });
                          } else {
                            setState(() {});
                          }
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 30),
            GradientButton(() {
              if (_phoneError() == null &&
                  _emailError() == null &&
                  _usernameError() == null) {
                _storedImage == null
                    ? userProvider.updateUserData(User(
                        _username,
                        _email,
                        _phonenumber,
                        args.userData.userId,
                        args.userData.downloadurl))
                    : userProvider.replaceImage(
                        User(_username, _email, _phonenumber,
                            args.userData.userId, args.userData.downloadurl),
                        _storedImage!);
                Navigator.of(context).pop();
              }
            }, 40, 120, Icons.upload, 'Update', 20)
          ]),
        ),
      ),
    );
  }
}
